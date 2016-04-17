//
//  VisaAPI.h
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VisaAPI : NSObject
@property (strong, nonatomic) NSString * status;
@property (strong, nonatomic) NSString * response;
@property (nonatomic, copy) void (^callFinished)(NSDictionary * response);

+(VisaAPI *) shared;

+ (void)triggerCall;

@end
