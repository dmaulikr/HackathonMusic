//
//  HMUser.h
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMUser : NSObject

+ (HMUser *) currentUser;

@property (strong, nonatomic) NSString * name;
@property (nonatomic) float credits;

@end
