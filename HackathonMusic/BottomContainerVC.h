//
//  BottomContainerVC.h
//  HackathonMusic
//
//  Created by Everett Gilmore on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeableCircleView.h"


@protocol BottomContainerDelegate <NSObject>

- (void) didSwipeCircleView:(SwipeableCircleView *) circleView;

@end


@interface BottomContainerVC : UIViewController
@property (unsafe_unretained) id <BottomContainerDelegate> delegate;
-(void) resetViews;
@end
