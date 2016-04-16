//
//  HMUser.m
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import "HMUser.h"

@implementation HMUser

+(HMUser *) currentUser{
    static dispatch_once_t pred;
    static HMUser *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[HMUser alloc] init];
    });
    return shared;
}

@end
