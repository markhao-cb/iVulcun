//
//  GameDetailScrollView.m
//  iVulcun
//
//  Created by Yu Qi Hao on 9/17/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//

#import "GameDetailScrollView.h"
#import "GameScreenshotsScrollView.h"

#define MARGIN_HORIZONTAL 8
#define MARGIN_VERTICAL 20
#define IMAGE_WIDTH 460
#define IMAGE_HEIGHT 215
#define SCREENSHOT_WIDTH 600
#define SCREENSHOT_HEIGHT 370
#define LABEL_MIN_HEIGHT 35
#define FONT @"STHeitiSC-Light"
#define FONT_SIZE_SMALL 14

@implementation GameDetailScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setupSubViews {
    //settings
    self.backgroundColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.5];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //setup game image
    _ivGameImage = [[UIImageView alloc] init];
    _ivGameImage.frame = CGRectMake(MARGIN_HORIZONTAL, 84, screenWidth - MARGIN_HORIZONTAL * 2, (screenWidth - MARGIN_HORIZONTAL * 2) * IMAGE_HEIGHT / IMAGE_WIDTH);
    [self addSubview:_ivGameImage];
    
    //setup categories
    _lblCategories = [[UILabel alloc] init];
    _lblCategories.frame = CGRectMake(MARGIN_HORIZONTAL, _ivGameImage.frame.origin.y + _ivGameImage.frame.size.height + MARGIN_VERTICAL, screenWidth - MARGIN_HORIZONTAL * 2, LABEL_MIN_HEIGHT);
    _lblCategories.font = [UIFont fontWithName:FONT size:FONT_SIZE_SMALL];
    _lblCategories.textColor = [UIColor whiteColor];
    _lblCategories.numberOfLines = 0;
    [self addSubview:_lblCategories];
    
    //setup genres
    _lblGrenes = [[UILabel alloc] init];
    _lblGrenes.frame = CGRectMake(MARGIN_HORIZONTAL, _lblCategories.frame.origin.y + _lblCategories.frame.size.height + MARGIN_VERTICAL, screenWidth - MARGIN_HORIZONTAL * 2, LABEL_MIN_HEIGHT);
    _lblGrenes.font = [UIFont fontWithName:FONT size:FONT_SIZE_SMALL];
    _lblGrenes.textColor = [UIColor whiteColor];
    _lblGrenes.numberOfLines = 0;
    [self addSubview:_lblGrenes];
    
    //setup description
    _lblDescription = [[UILabel alloc] init];
    _lblDescription.frame = CGRectMake(MARGIN_HORIZONTAL, _lblGrenes.frame.origin.y + _lblGrenes.frame.size.height + MARGIN_VERTICAL, screenWidth - MARGIN_HORIZONTAL * 2, LABEL_MIN_HEIGHT);
    _lblDescription.font = [UIFont fontWithName:FONT size:FONT_SIZE_SMALL];
    _lblDescription.textColor = [UIColor whiteColor];
    _lblDescription.numberOfLines = 0;
    [self addSubview:_lblDescription];
    
    //setup screenshots scrollview
    _SVGameScreenshots = [[GameScreenshotsScrollView alloc] init];
    _SVGameScreenshots.frame = CGRectMake(MARGIN_HORIZONTAL, _lblDescription.frame.origin.y + _lblDescription.frame.size.height + MARGIN_VERTICAL, screenWidth - MARGIN_HORIZONTAL * 2, (screenWidth - MARGIN_HORIZONTAL * 2) * SCREENSHOT_HEIGHT / SCREENSHOT_WIDTH);
    [self addSubview:_SVGameScreenshots];
}

-(void)resetFrame{
    
    CGRect frame = _lblGrenes.frame;
    frame.origin.y = _lblCategories.frame.origin.y + _lblCategories.frame.size.height + MARGIN_VERTICAL;
    _lblGrenes.frame = frame;
    
    frame = _lblDescription.frame;
    frame.origin.y += _lblGrenes.frame.size.height;
    _lblDescription.frame = frame;
    
    frame = _SVGameScreenshots.frame;
    frame.origin.y += (_lblDescription.frame.size.height + MARGIN_VERTICAL);
    _SVGameScreenshots.frame = frame;
}

@end
