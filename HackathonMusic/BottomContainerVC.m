//
//  BottomContainerVC.m
//  HackathonMusic
//
//  Created by Everett Gilmore on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import "BottomContainerVC.h"

@interface BottomContainerVC ()<SwipeableCircleViewDelegate>

@property (strong) SwipeableCircleView * circleView1;
@property (strong) SwipeableCircleView * circleView2;
@property (strong) SwipeableCircleView * circleView3;
@property (strong) SwipeableCircleView * circleView4;
@property (strong) SwipeableCircleView * circleView5;

@property (strong) IBOutlet UILabel *descriptionLabel;
@property (strong) NSArray *descriptionsArray;

@property (strong) NSMutableArray *circleViewArray;
@property (strong) NSMutableArray *yesObjects;
@property (strong) NSMutableArray *noObjects;

@property (strong) UIView * underlineView;

@end

@implementation BottomContainerVC{
    CGFloat viewSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.descriptionsArray = [NSArray arrayWithObjects:@"Production Value", @"item 2", @"item 3", @"item 4", @"item 5", nil];
    
    
    
    [self resetViews];
    
    self.underlineView = [[UIView alloc] init];
    self.underlineView.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    self.underlineView.layer.cornerRadius = 2;
    self.underlineView.clipsToBounds = YES;
    [self.view addSubview: self.underlineView];
    
}

-(void)resetViews{
    
    self.yesObjects = [NSMutableArray array];
    self.noObjects = [NSMutableArray array];
    self.circleViewArray = [NSMutableArray array];
    
    self.underlineView.alpha = 1;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:kNilOptions
                     animations:
     ^{
         
         self.circleView1.alpha = 0;
         self.circleView2.alpha = 0;
         self.circleView3.alpha = 0;
         self.circleView4.alpha = 0;
         self.circleView5.alpha = 0;
         self.descriptionLabel.alpha = 0;
         
     }completion:^(BOOL finished) {
         if (finished) {
             self.circleView1 = nil;
             self.circleView2 = nil;
             self.circleView3 = nil;
             self.circleView4 = nil;
             self.circleView5 = nil;
             
             [self.circleView1 removeFromSuperview];
             [self.circleView2 removeFromSuperview];
             [self.circleView3 removeFromSuperview];
             [self.circleView4 removeFromSuperview];
             [self.circleView5 removeFromSuperview];
             
             viewSize = 60.0;
             CGFloat yPositionTop = 10;
             CGFloat xPosition = self.view.frame.size.width/2 - viewSize/2 - viewSize*2 -10;
             
             self.circleView1 = [[SwipeableCircleView alloc] initWithFrame:CGRectMake(xPosition, yPositionTop, viewSize, viewSize)];
             self.circleView1.delegate = self;
             [self.circleView1.iconImageView setImage:[UIImage imageNamed:@""]];
             //self.circleView1.descriptionLabel.text = @"PV";
             self.circleView1.descriptionTitle = [self.descriptionsArray objectAtIndex:0];
             [self.circleView1.iconImageView setImage:[UIImage imageNamed:@"icon-ruby.png"]];
             [self.view addSubview:self.circleView1];
             [self.circleViewArray addObject:self.circleView1];
             
             
             self.circleView2 = [[SwipeableCircleView alloc] initWithFrame:CGRectMake(xPosition + 65 , yPositionTop, viewSize, viewSize)];
             self.circleView2.delegate = self;
             [self.circleView2.iconImageView setImage:[UIImage imageNamed:@""]];
             //self.circleView2.descriptionLabel.text = @"SW";
             self.circleView2.descriptionTitle = [self.descriptionsArray objectAtIndex:1];
             [self.circleView2.iconImageView setImage:[UIImage imageNamed:@"note.png"]];
             [self.view addSubview:self.circleView2];
             [self.circleViewArray addObject:self.circleView2];
             
             self.circleView3 = [[SwipeableCircleView alloc] initWithFrame:CGRectMake(xPosition + 65*2 , yPositionTop, viewSize, viewSize)];
             self.circleView3.delegate = self;
             [self.circleView3.iconImageView setImage:[UIImage imageNamed:@""]];
             //self.circleView3.descriptionLabel.text = @"CA";
             self.circleView3.descriptionTitle = [self.descriptionsArray objectAtIndex:2];
             [self.circleView3.iconImageView setImage:[UIImage imageNamed:@"speaker.png"]];
             [self.view addSubview:self.circleView3];
             [self.circleViewArray addObject:self.circleView3];
             
             self.circleView4 = [[SwipeableCircleView alloc] initWithFrame:CGRectMake(xPosition + 65*3, yPositionTop, viewSize, viewSize)];
             self.circleView4.delegate = self;
             [self.circleView4.iconImageView setImage:[UIImage imageNamed:@""]];
             //self.circleView4.descriptionLabel.text = @"ST";
             self.circleView4.descriptionTitle = [self.descriptionsArray objectAtIndex:3];
             [self.circleView4.iconImageView setImage:[UIImage imageNamed:@"headphone.png"]];
             [self.view addSubview:self.circleView4];
             [self.circleViewArray addObject:self.circleView4];
             
             self.circleView5 = [[SwipeableCircleView alloc] initWithFrame:CGRectMake(xPosition + 65*4, yPositionTop, viewSize, viewSize)];
             self.circleView5.delegate = self;
             [self.circleView5.iconImageView setImage:[UIImage imageNamed:@"equalizer.png"]];
             //self.circleView5.descriptionLabel.text = @"BE";
             self.circleView5.descriptionTitle = [self.descriptionsArray objectAtIndex:4];
             [self.view addSubview:self.circleView5];
             [self.circleViewArray addObject:self.circleView5];
             
             self.descriptionLabel.text = self.circleView1.descriptionTitle;
             self.descriptionLabel.alpha = 1;
             
             self.underlineView.frame = CGRectMake(self.circleView1.frame.origin.x,
                                                   self.circleView1.frame.origin.y + self.circleView1.frame.size.height + 8,
                                                   self.circleView1.frame.size.width,
                                                   4);
             
             for (SwipeableCircleView *circleView in self.circleViewArray){
                 
                 circleView.userInteractionEnabled = NO;
             }
             
             self.circleView1.userInteractionEnabled = YES;

         }
     }];

    
    
   }

-(void) tappedOnView:(SwipeableCircleView *)swipeableView{
    
    self.descriptionLabel.text = swipeableView.descriptionTitle;
    [self.delegate didSwipeCircleView:swipeableView];
}

-(void) leftSwipedOnView: (SwipeableCircleView *)swipeableView{
    
    NSString *direction = @"Left";
    [self actionsOnSwipe:swipeableView withDirection:direction];
    [self.delegate didSwipeCircleView:swipeableView];
}

-(void) rightSwipedOnView: (SwipeableCircleView *)swipeableView{
    
    NSString *direction = @"Right";
    [self actionsOnSwipe:swipeableView withDirection:direction];
    [self.delegate didSwipeCircleView:swipeableView];

}

-(void) actionsOnSwipe: (SwipeableCircleView *)view withDirection:(NSString *)direction {
    
    CGFloat yPosition = view.frame.origin.y;
    CGRect originalFrame = view.frame;
    
    NSUInteger index = [self.circleViewArray indexOfObject:view];
    
    for (SwipeableCircleView *circleView in self.circleViewArray){
        
        circleView.userInteractionEnabled = NO;
    }
    
    SwipeableCircleView * nextCircleView = [[SwipeableCircleView alloc] init];
    if (index < self.circleViewArray.count-1){
        
        nextCircleView = [self.circleViewArray objectAtIndex:index +1];
        nextCircleView.userInteractionEnabled = YES;
        
    }else{
        nextCircleView = view;
        self.underlineView.alpha = 0;
        
    }
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:kNilOptions
                     animations:
     ^{
         
         if([direction isEqualToString:@"Right"]){
             
             view.frame = CGRectMake(self.view.frame.size.width + 50, yPosition, viewSize, viewSize);
             
         }else{
             
             view.frame = CGRectMake(-50, yPosition, viewSize, viewSize);
             
         }

         
         self.descriptionLabel.alpha = 0;
         self.underlineView.frame = CGRectMake(nextCircleView.frame.origin.x, self.underlineView.frame.origin.y, self.underlineView.frame.size.width, self.underlineView.frame.size.height);
         
     }completion:^(BOOL finished) {
         
         if (finished) {
             if (index >= self.descriptionsArray.count-1){
                 self.descriptionLabel.alpha = 1;
                 view.descriptionLabel.hidden = YES;
                 
             }else{
                 self.descriptionLabel.text = [self.descriptionsArray objectAtIndex:index + 1];
                 self.descriptionLabel.alpha = 1;
                 view.descriptionLabel.hidden = YES;
             }
             
            
             
             view.backgroundColor = [UIColor clearColor];
             
             if([direction isEqualToString:@"Right"]){
                 
                 [view.iconImageView setImage:[UIImage imageNamed:@"checkmark.png"]];
                 
             }else{
                 
                 [view.iconImageView setImage:[UIImage imageNamed:@"xicon.png"]];
                 
             }

             
             view.alpha = 0;
             view.frame = originalFrame;
             
             [UIView animateWithDuration:0.5
                                   delay:0.0
                                 options: UIViewAnimationOptionCurveEaseIn
                              animations:
              ^{
                  
                  view.alpha = 1;
                  
              }completion:^(BOOL finished) {
                  if (finished) {
                      
                      view.userInteractionEnabled = NO;
                      
                  }
              }];
             
         }
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
