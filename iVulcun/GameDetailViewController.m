//
//  GameDetailViewController.m
//  iVulcun
//
//  Created by Yu Qi Hao on 9/17/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//

#import "GameDetailViewController.h"
#import "GameScreenshotsScrollView.h"
#import "GameDetailScrollView.h"
#import "SavedGame.h"
#import "GameCategory.h"
#import "GameGenre.h"
#import "GameScreenshot.h"
#import "AppDelegate.h"

@interface GameDetailViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
@property(strong, nonatomic) NSMutableArray *screenshotsArr;
@property(strong, nonatomic) NSMutableArray *gameCategoriesArr;
@property(strong, nonatomic) NSMutableArray *gameGenresArr;
@property(strong, nonatomic) NSMutableArray *gameScreenshotsArr;
@property(strong, nonatomic) GameDetailScrollView *detailSV;

@end

@implementation GameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:_detailsDict[@"name"]];
    
    if ([self isSaved]) {
        _btnAdd.title = @"Added";
        _btnAdd.enabled = NO;
    } else {
        _btnAdd.title = @"Add";
        _btnAdd.enabled = YES;
    };
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: _detailsDict[@"backgroundUrl"]]]]
       drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    _detailSV = [[GameDetailScrollView alloc] initWithFrame:self.view.frame];
    [_detailSV setupSubViews];
    
    
    self.screenshotsArr = [[NSMutableArray alloc] init];
    self.gameScreenshotsArr = [[NSMutableArray alloc] init];
    for(int i = 0; i < [_detailsDict[@"screenshots"] count]; i++) {
        [_gameScreenshotsArr addObject:_detailsDict[@"screenshots"][i][@"path_thumbnail"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: _detailsDict[@"screenshots"][i][@"path_thumbnail"]]]];
        [_screenshotsArr addObject:image];
    }
    [_detailSV.SVGameScreenshots setupImageViews:_screenshotsArr];
    
   _detailSV.ivGameImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: _detailsDict[@"gameImageUrl"]]]];
    
    self.gameCategoriesArr = [[NSMutableArray alloc] init];
    NSString *categories = @"Categories: \n\n";
    for (NSDictionary *dict in _detailsDict[@"categories"]) {
        NSString *category = [NSString stringWithFormat:@"%@ ", dict[@"description"]];
        [self.gameCategoriesArr addObject:category];
        categories = [categories stringByAppendingString:category];
    }
    _detailSV.lblCategories.text = categories;
    [_detailSV.lblCategories sizeToFit];
    
    self.gameGenresArr = [[NSMutableArray alloc] init];
    NSString *genres = @"Genres: \n\n";
    for (NSDictionary *dict in _detailsDict[@"genres"]) {
        NSString *genre = [NSString stringWithFormat:@"%@ ", dict[@"description"]];
        [self.gameGenresArr addObject:genre];
        genres = [genres stringByAppendingString:genre];
    }
    _detailSV.lblGrenes.text = genres;
    [_detailSV.lblGrenes sizeToFit];
    
    _detailSV.lblDescription.text = [NSString stringWithFormat:@"Description: \n\n %@",_detailsDict[@"gameDescription"]];
    [_detailSV.lblDescription sizeToFit];
    [_detailSV resetFrame];
    
    _detailSV.contentSize = CGSizeMake(self.view.frame.size.width, _detailSV.SVGameScreenshots.frame.origin.y + _detailSV.SVGameScreenshots.frame.size.height + 20);
    
    [self.view addSubview:_detailSV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isSaved {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SavedGame"];
    NSError *fetchingError = nil;
    NSArray *games = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&fetchingError];
    if ([games count] > 0) {
        for (SavedGame *game in games) {
            int appId = [_detailsDict[@"appid"] intValue];
            if ([game.appId intValue] == appId) {
                return true;
            }
        }
    }
    return false;
}


- (IBAction)saveToMyList:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SavedGame *game = [NSEntityDescription insertNewObjectForEntityForName:@"SavedGame" inManagedObjectContext: appDelegate.managedObjectContext];
    
    if(game != nil) {
        game.appId = _detailsDict[@"appid"];
        game.name = _detailsDict[@"name"];
        game.imageUrl = _detailsDict[@"gameImageUrl"];
        game.gameDescription = _detailsDict[@"gameDescription"];
        game.backgroundUrl = _detailsDict[@"backgroundUrl"];
        game.createdAt = [NSDate date];
        
        NSMutableArray *categories = [NSMutableArray array];
        for (NSString *cat in self.gameCategoriesArr) {
            GameCategory *gameCategory = [NSEntityDescription insertNewObjectForEntityForName:@"GameCategory" inManagedObjectContext:appDelegate.managedObjectContext];
            gameCategory.categoryName = cat;
            [categories addObject:gameCategory];
        }
        
        NSMutableArray *genres = [NSMutableArray array];
        for (NSString *gen in self.gameGenresArr) {
            GameGenre *gameGenre = [NSEntityDescription insertNewObjectForEntityForName:@"GameGenre" inManagedObjectContext:appDelegate.managedObjectContext];
            gameGenre.genreName = gen;
            [genres addObject:gameGenre];
        }
        
        NSMutableArray *screenshots = [NSMutableArray array];
        for (NSString *scr in self.gameScreenshotsArr) {
            GameScreenshot *gameScreenshot = [NSEntityDescription insertNewObjectForEntityForName:@"GameScreenshot" inManagedObjectContext:appDelegate.managedObjectContext];
            gameScreenshot.url = scr;
            [screenshots addObject:gameScreenshot];
        }
        
        [game addGameCategories:[NSSet setWithArray:categories]];
        [game addGameGenres:[NSSet setWithArray:genres]];
        [game addGameScreenshot:[NSSet setWithArray:screenshots]];
        
        NSError *savingError = nil;
        
        if([appDelegate.managedObjectContext save:&savingError]) {
            NSLog(@"Successfully saved the context");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Saved"
                                                            message:@"This game has been added to your list!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [sender setTitle:@"Added"];
            [sender setEnabled:NO];
        } else {
            NSLog(@"Failed to save the context. Error = %@", savingError);
        }
    } else {
        NSLog(@"Failed to create the new game");
    }
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
