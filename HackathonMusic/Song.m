//
//  Song.m
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import "Song.h"

@implementation Song


+ (Song *) songFromDictionary:(NSDictionary *) jsonDict
{
    Song * song = [[Song alloc] init];
    
    song.title = jsonDict[@"title"];
    song.artist = jsonDict[@"artist"];
    song.musicFileName = jsonDict[@"music_file_name"];
    song.artworkFilename = jsonDict[@"artwork_file_name"];
    
    return song;
    
}

@end
