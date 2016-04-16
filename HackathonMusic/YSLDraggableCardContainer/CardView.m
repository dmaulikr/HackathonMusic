//
//  CardView.m
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _imageView = [[UIImageView alloc]init];
    _imageView.backgroundColor = [UIColor clearColor];
    
    _imageView.frame = CGRectMake(0, 40, self.frame.size.width, self.frame.size.width);
    [self addSubview:_imageView];
    
    _artistLabel = [[MarqueeLabel alloc]init];
    _artistLabel.backgroundColor = [UIColor clearColor];
    _artistLabel.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    _artistLabel.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:14];
    _artistLabel.textColor = [UIColor blackColor];
    _artistLabel.marqueeType = MLContinuous;
    [self addSubview:_artistLabel];
    
    _titleLabel = [[MarqueeLabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.frame = CGRectMake(0, 15, self.frame.size.width, 30);
    _titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.marqueeType = MLContinuous;
    [self addSubview:_titleLabel];


    

}

@end
