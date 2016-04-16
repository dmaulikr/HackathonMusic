//
//  HMPlayer.m
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import "HMPlayer.h"

@interface HMPlayer ()

@property (strong, nonatomic) AVQueuePlayer * player;
@property (strong,nonatomic) NSArray * timeObservers;


@end


@implementation HMPlayer

+(HMPlayer *) shared{
    static dispatch_once_t pred;
    static HMPlayer *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[HMPlayer alloc] init];
    });
    return shared;
}

- (HMPlayer *) init
{
    if (self = [super init]) {
        _player = [[AVQueuePlayer alloc] init];
        _player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    }
    return self;
}


- (void) loadTracks
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"songs" ofType:@"json"];
    NSString *JSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSArray * jsonsongs = [NSJSONSerialization JSONObjectWithData:[JSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSMutableArray<Song*> * songs = [NSMutableArray new];
    for (NSDictionary * jsonsong in jsonsongs) {
        Song * song = [Song songFromDictionary:jsonsong];
        [songs addObject:song];
        NSURL * url = [[NSBundle mainBundle] URLForResource:song.musicFileName
                                              withExtension:@"mp3"];
        
//        AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
//        [self.player insertItem:item
//                      afterItem:nil];
    }

}


- (void) addTimeObservers
{
    __weak __typeof__(self) weakSelf = self;
    
    //create Time observers and keep them in a property which should be removed once the observers are not needed anymore (when playback stops)
    
    self.timeObservers = @[
                           [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1,1)
                                                                     queue:NULL
                                                                usingBlock:^(CMTime time)
    {
        if (weakSelf.everySecond) {
            weakSelf.everySecond(time);
        }
    }]];
    
}

- (void) removeObservers
{
    if (self.timeObservers){
        for (id observer in self.timeObservers) {
            [self.player removeTimeObserver:observer];
            self.timeObservers = nil;
        }
    }
}

- (void) togglePlay
{
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

- (void) play
{
    if (![self isPlaying]) {
        [self addTimeObservers];
        [self.player play];
    }
}


- (void) pause
{
    [self.player pause];
    [self removeObservers];
}

- (void) stop
{
    [self.player pause];
    [self removeObservers];
    [self seekToTime:0.f];
}

- (BOOL) isPlaying
{
    return self.player.rate;
}

- (void) skip
{
    if (self.player.items.count > 1){
        
        BOOL wasPlaying = [self isPlaying];
        [self pause];
        
        [self.player advanceToNextItem];

        
        if (wasPlaying) {
            [self play];
        }
    }
    
}



- (void) seekToTime:(float)floatTime
{
    
    CMTime seekCMTime = [self timeFromFloat:floatTime];
    if (!CMTIME_IS_INDEFINITE(seekCMTime)) {
        [self.player seekToTime:seekCMTime];
    }
}


#pragma mark Utility
- (CMTime) timeFromFloat:(float) number
{
    CMTime timeRelativeToCurrentItem = CMTimeMultiplyByFloat64(self.player.currentItem.duration,number);
    
    return timeRelativeToCurrentItem;
}

- (NSString *)stringFromTime: (CMTime) time
{
    NSString *timeIntervalString;
    if (time.value == 0) {
        return @"00:00";
    }
    
    NSInteger ti =(NSInteger)(time.value / time.timescale);
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    if (hours) {
        timeIntervalString = [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    } else {
        timeIntervalString = [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds];
    }
    
    return timeIntervalString;
}

@end
