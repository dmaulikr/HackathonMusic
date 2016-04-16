//
//  SwipeableCircleView.h
//  HackathonMusic
//
//  Created by Everett Gilmore on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwipeableCircleView;

@protocol SwipeableCircleViewDelegate <NSObject>
@required
-(void) leftSwipedOnView: (SwipeableCircleView *)swipeableView;
-(void) rightSwipedOnView: (SwipeableCircleView *)swipeableView;
-(void) tappedOnView: (SwipeableCircleView *)swipeableView;

@end

@interface SwipeableCircleView : UIView

@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) NSString *descriptionTitle;

@property (unsafe_unretained) id<SwipeableCircleViewDelegate> delegate;

@end
