//
//  GameScreenshotsScrollView.m
//  iVulcun
//
//  Created by Yu Qi Hao on 9/17/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//

#import "GameScreenshotsScrollView.h"

@implementation GameScreenshotsScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupImageViews: (NSMutableArray *)screenshotsArr {
    for (int i = 0; i < [screenshotsArr count]; i++) {
        CGRect frame;
        frame.origin.x = self.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [screenshotsArr objectAtIndex:i];
        
        [self addSubview:imageView];
        self.contentSize = CGSizeMake(self.frame.size.width * [screenshotsArr count], self.frame.size.height);
    }
    self.pagingEnabled = YES;
}

@end
