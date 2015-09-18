//
//  SavedGame.h
//  iVulcun
//
//  Created by Yu Qi Hao on 9/18/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameCategory, GameGenre, GameScreenshot;

@interface SavedGame : NSManagedObject

@property (nonatomic, retain) NSNumber * appId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * gameDescription;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * backgroundUrl;
@property (nonatomic, retain) NSSet *gameGenres;
@property (nonatomic, retain) NSSet *gameCategories;
@property (nonatomic, retain) NSSet *gameScreenshot;
@end

@interface SavedGame (CoreDataGeneratedAccessors)

- (void)addGameGenresObject:(GameGenre *)value;
- (void)removeGameGenresObject:(GameGenre *)value;
- (void)addGameGenres:(NSSet *)values;
- (void)removeGameGenres:(NSSet *)values;

- (void)addGameCategoriesObject:(GameCategory *)value;
- (void)removeGameCategoriesObject:(GameCategory *)value;
- (void)addGameCategories:(NSSet *)values;
- (void)removeGameCategories:(NSSet *)values;

- (void)addGameScreenshotObject:(GameScreenshot *)value;
- (void)removeGameScreenshotObject:(GameScreenshot *)value;
- (void)addGameScreenshot:(NSSet *)values;
- (void)removeGameScreenshot:(NSSet *)values;

@end
