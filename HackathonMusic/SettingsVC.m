//
//  SettingsVC.m
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import "SettingsVC.h"
#import "VisaAPI.h"

@implementation SettingsVC

- (void) viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)TriggerAsyncCall:(id)sender {
    [VisaAPI triggerCall];
}

@end
