//
//  GamesTableViewCell.h
//  iVulcun
//
//  Created by Yu Qi Hao on 9/16/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblGameName;
@property (weak, nonatomic) IBOutlet UILabel *lblGamePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblGameDescription;
@property (weak, nonatomic) IBOutlet UIImageView *ivGameImage;

@end
