//
//  SavedGameTableViewController.m
//  iVulcun
//
//  Created by Yu Qi Hao on 9/18/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//

#import "SavedGameTableViewController.h"
#import "SavedGamesTableViewCell.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "SavedGame.h"
#import "SavedGamesTableViewCell.h"
#import "GameDetailViewController.h"
#import "GameCategory.h"
#import "GameGenre.h"
#import "GameScreenshot.h"

@interface SavedGameTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SavedGameTableViewController {
    NSMutableArray *filteredNames;
    UISearchDisplayController *searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Fetch data
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SavedGame"];
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    
    
    fetchRequest.sortDescriptors = @[dateSort];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                   managedObjectContext:[self.appDelegate managedObjectContext]
                                                     sectionNameKeyPath:nil
                                                              cacheName:nil
                ];
    self.frc.delegate = self;
    NSError *fetchingError = nil;
    if ([self.frc performFetch:&fetchingError]) {
        NSLog(@"Successfully fetched");
    } else {
        NSLog(@"Failed to fetch");
    }
    filteredNames = [NSMutableArray arrayWithArray:[self.frc fetchedObjects]];
    
    //Initialize Search controller
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource=self;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
//     Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segment Control

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SavedGame"];
    if ([sender selectedSegmentIndex] == 0) {
        NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
        fetchRequest.sortDescriptors = @[dateSort];
        
        self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:[self.appDelegate managedObjectContext]
                                                         sectionNameKeyPath:nil
                                                                  cacheName:nil
                    ];
        
        self.frc.delegate = self;
        NSError *fetchingError = nil;
        if ([self.frc performFetch:&fetchingError]) {
            NSLog(@"Successfully fetched");
        } else {
            NSLog(@"Failed to fetch");
        }

    } else {
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        fetchRequest.sortDescriptors = @[nameSort];
        
        self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:[self.appDelegate managedObjectContext]
                                                         sectionNameKeyPath:nil
                                                                  cacheName:nil
                    ];
        
        self.frc.delegate = self;
        NSError *fetchingError = nil;
        if ([self.frc performFetch:&fetchingError]) {
            NSLog(@"Successfully fetched");
        } else {
            NSLog(@"Failed to fetch");
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    id <NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    if (tableView == self.tableView) {
        return sectionInfo.numberOfObjects;
    } else {
        return [filteredNames count];
    }
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView beginUpdates];
    
}
- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath{
    
    if (type == NSFetchedResultsChangeDelete){
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeInsert){
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView endUpdates];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SavedGamesTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SavedGamesTableViewCell"
                                           forIndexPath:indexPath];
    SavedGame *game = [self.frc objectAtIndexPath:indexPath];
    if(tableView == self.tableView) {
        cell.lblName.text = game.name;
        cell.ivGameImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: game.imageUrl]]];
    } else {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchGameTableViewCell" owner:nil options:nil];
        
        cell = (SavedGamesTableViewCell*)[topLevelObjects objectAtIndex:0];
        
        cell.lblName.text = ((SavedGame*)(filteredNames[indexPath.row])).name;
        cell.ivGameImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: ((SavedGame*)(filteredNames[indexPath.row])).imageUrl]]];
        
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing
             animated:animated];
    [self.tableView setEditing:editing
                    animated:animated];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SavedGame *gameToDelete = [self.frc objectAtIndexPath:indexPath];
    
    [[self.appDelegate managedObjectContext] deleteObject:gameToDelete];
    if ([gameToDelete isDeleted]) {
        NSError *savingError = nil;
        if ([[self.appDelegate managedObjectContext] save:&savingError]) {
            NSLog(@"Successfully deleted the object");
        } else {
            NSLog(@"Failed to save the context with error = %@", savingError);
        }
    }
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark - Search

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:@"SavedGamesTableViewCell"];
    tableView.delegate = self;
    tableView.rowHeight = 84.0f;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [filteredNames removeAllObjects];
    if (searchString.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SavedGame *games, NSDictionary *b) {
            NSRange range = [games.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            return range.location != NSNotFound;
        }];
        NSArray *matches = [[self.frc fetchedObjects] filteredArrayUsingPredicate: predicate];
        [filteredNames addObjectsFromArray:matches];
    }
    return YES;
}



#pragma mark - Navigation



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        return;
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SavedGame *game = [self.frc objectAtIndexPath:indexPath];
        GameDetailViewController *gameDetailVC = segue.destinationViewController;
        NSMutableDictionary *gameDataDic = [[NSMutableDictionary alloc] init];
        [gameDataDic setObject:game.name forKey:@"name"];
        [gameDataDic setObject:game.appId forKey:@"appid"];
        [gameDataDic setObject:game.backgroundUrl forKey:@"backgroundUrl"];
        [gameDataDic setObject:game.imageUrl forKey:@"gameImageUrl"];
        [gameDataDic setObject:game.gameDescription forKey:@"gameDescription"];
        
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        for (GameCategory *category in ((GameCategory*)game.gameCategories)) {
            NSMutableDictionary *catDict = [[NSMutableDictionary alloc] init];
            [catDict setValue:category.categoryName forKey:@"description"];
            [categories addObject:catDict];
        }
        [gameDataDic setObject:categories forKey:@"categories"];
        
        NSMutableArray *genres = [[NSMutableArray alloc] init];
        for (GameGenre *genre in ((GameGenre*)game.gameGenres)) {
            NSMutableDictionary *genDict = [[NSMutableDictionary alloc] init];
            [genDict setValue:genre.genreName forKey:@"description"];
            [genres addObject:genDict];
        }
        [gameDataDic setObject:genres forKey:@"genres"];
        
        
        NSMutableArray *screenshots = [[NSMutableArray alloc] init];
        for (GameScreenshot *screenshot in ((GameScreenshot*)game.gameScreenshot)) {
            NSMutableDictionary *scrDict = [[NSMutableDictionary alloc] init];
            [scrDict setValue:screenshot.url forKey:@"path_thumbnail"];
            [screenshots addObject:scrDict];
        }
        [gameDataDic setObject:screenshots forKey:@"screenshots"];
        
        gameDetailVC.transitioningDelegate = self;
        gameDetailVC.modalPresentationStyle = UIModalPresentationCustom;
        gameDetailVC.detailsDict = gameDataDic;
    }
    
}


@end
