//
//  SettingsVC.m
//  HackathonMusic
//
//  Created by Yair Szarf on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import "SettingsVC.h"
#import "VisaAPI.h"
#import "HMUser.h"
#import <AVFoundation/AVFoundation.h>

@interface SettingsVC ()

@property (strong, nonatomic) NSDecimalNumber * minCredits;
@property (weak, nonatomic) IBOutlet UILabel *ResponseLabel;
@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *CreditsLabel;

@end

@implementation SettingsVC
{
    AVAudioPlayer * audioPlayer;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.minCredits = [NSDecimalNumber decimalNumberWithString:@"8"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.UsernameLabel.text = [HMUser currentUser].name;
    
    [self updateCredits];
}

- (void) updateCredits
{
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    [nf setMinimumFractionDigits:2];
    [nf setMaximumFractionDigits:2];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.CreditsLabel.text = [nf stringFromNumber:[HMUser currentUser].credits];
}


- (IBAction)TriggerAsyncCall:(id)sender {
    NSComparisonResult comparison =[[HMUser currentUser].credits compare:self.minCredits];
    if (comparison == NSOrderedDescending) {
        [VisaAPI shared].callFinished = ^ void (NSDictionary * response) {
            [HMUser currentUser].credits =  [NSDecimalNumber decimalNumberWithString:@"0"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ResponseLabel.text = response.description;
                [self playSound];
                [self updateCredits];
                
            });
        };
        [VisaAPI triggerCall];
        
    } else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Not Yet" message:@"You don't have enough credits to cash in yet" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void) playSound
{
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"COINSLOT DROP" withExtension:@"mp3"];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}



@end
