//
//  Category.h
//  iVulcun
//
//  Created by Yu Qi Hao on 9/18/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SavedGame;

@interface GameCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) SavedGame *game;

@end
