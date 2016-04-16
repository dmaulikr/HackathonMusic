//
//  HMPlayer.h
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Song.h"

@interface HMPlayer : NSObject
@property (strong,nonatomic) NSArray<Song*> * songs;

+ (HMPlayer *) shared;

- (void) loadTracks;
- (void) togglePlay;
- (void) play;
- (void) pause;
- (void) stop;
- (void) skip;
- (BOOL) isPlaying;

/**
 * Seek to a time between 0 and 1 realtive to the current items duration
 **/
- (void) seekToTime:(float) floatTime;
@property (nonatomic, readonly) float currentTime;
@property (nonatomic, strong, readonly) NSString * currentTimeString;
@property (nonatomic, strong, readonly) NSString * currentItemDurationString;
@property (nonatomic, copy) void (^everySecond)(CMTime time);


@end
