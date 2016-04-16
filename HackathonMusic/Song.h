//
//  Song.h
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

+ (Song *) songFromDictionary:(NSDictionary *) jsonDict;

@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * artist;
@property (strong,nonatomic) NSString * musicFileName;
@property (strong,nonatomic) NSString * artworkFilename;

@end
