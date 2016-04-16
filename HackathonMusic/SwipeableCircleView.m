//
//  SwipeableCircleView.m
//  HackathonMusic
//
//  Created by Everett Gilmore on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import "SwipeableCircleView.h"

@interface SwipeableCircleView()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeftGR;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRightGR;
@property (strong, nonatomic) UIButton *showDescriptionButton;

@end

@implementation SwipeableCircleView


- (void)initialize
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.frame.size.width/2;
    self.clipsToBounds = YES;
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.iconImageView];
    
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.descriptionLabel];
    
    self.showDescriptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showDescriptionButton addTarget:self
                                   action:@selector(tappedOnView)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.showDescriptionButton setTitle:nil forState:UIControlStateNormal];
    self.showDescriptionButton.frame = self.bounds;
    [self addSubview:self.showDescriptionButton];
    
    self.swipeLeftGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedOnView:)];
    self.swipeLeftGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:self.swipeLeftGR];
    
    self.swipeRightGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedOnView:)];
    self.swipeRightGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:self.swipeRightGR];

    
}

-(void)tappedOnView{
    if ([self.delegate respondsToSelector:@selector(tappedOnView:)]){
        [self.delegate tappedOnView:self];
    }
}

-(void)swipedOnView: (UISwipeGestureRecognizer *)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        if ([self.delegate respondsToSelector:@selector(leftSwipedOnView:)]){
            [self.delegate leftSwipedOnView:self];
        }
        
        
        
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionRight){
        if ([self.delegate respondsToSelector:@selector(rightSwipedOnView:)]){
            [self.delegate rightSwipedOnView:self];
        }
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
