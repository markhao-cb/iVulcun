//
//  GameDetailScrollView.h
//  iVulcun
//
//  Created by Yu Qi Hao on 9/17/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScreenshotsScrollView.h"

@interface GameDetailScrollView : UIScrollView

@property (strong, nonatomic) UILabel *lblCategories;
@property (strong, nonatomic) UILabel *lblDescription;
@property (strong, nonatomic) UILabel *lblGrenes;
@property (strong, nonatomic) UIImageView *ivGameImage;
@property (strong, nonatomic) GameScreenshotsScrollView *SVGameScreenshots;

-(void)setupSubViews;
-(void)resetFrame;

@end
