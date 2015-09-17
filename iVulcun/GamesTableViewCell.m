//
//  GamesTableViewCell.m
//  iVulcun
//
//  Created by Yu Qi Hao on 9/16/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//

#import "GamesTableViewCell.h"

@implementation GamesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self sendSubviewToBack:_ivGameImage];
    _ivGameImage.alpha = 0.7;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
