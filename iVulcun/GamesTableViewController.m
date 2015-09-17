//
//  GamesTableViewController.m
//  iVulcun
//
//  Created by Yu Qi Hao on 9/16/15.
//  Copyright (c) 2015 Yu Qi Hao. All rights reserved.
//


#import "GamesTableViewController.h"
#import "GamesTableViewCell.h"
#import "Game.h"

@interface GamesTableViewController () {
    NSMutableArray *_apps;
    NSMutableArray *_games;
    NSMutableArray *_appsWithDetails;
}

@end

@implementation GamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get Games list through API
    NSString *getListurlAsString = @"http://api.steampowered.com/ISteamApps/GetAppList/v2/";
    NSURL *getListurl = [NSURL URLWithString:getListurlAsString];
    NSMutableURLRequest *getListurlRequest = [NSMutableURLRequest requestWithURL:getListurl];
    [getListurlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSLog(@"thread: %@", [NSThread currentThread]);
    [NSURLConnection sendAsynchronousRequest:getListurlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         if ([data length] >0 && error == nil){
             NSString *gamesListJsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSData *gamesListJsonData = [gamesListJsonString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             id gamesListJsonObject = [NSJSONSerialization JSONObjectWithData:gamesListJsonData options:NSJSONReadingAllowFragments error:&error];
             if (gamesListJsonObject != nil && error == nil) {
                _apps = [NSMutableArray arrayWithArray:gamesListJsonObject[@"applist"][@"apps"]];
                _games = [[NSMutableArray alloc] init];
                _appsWithDetails = [[NSMutableArray alloc] init];
                 for (int i = 0; i < 100; i++) {
                     NSString *appidAsString = [_apps[i][@"appid"] stringValue];
                     NSString *getDetailUrlAsString = [NSString stringWithFormat:@"http://store.steampowered.com/api/appdetails/?appids=%@", appidAsString];
                     NSURL *getDetailUrl = [NSURL URLWithString:getDetailUrlAsString];
                     NSMutableURLRequest *getDetailUrlRequest = [NSMutableURLRequest requestWithURL:getDetailUrl];
                     [getDetailUrlRequest setHTTPMethod:@"GET"];
                     
                     NSOperationQueue *queue = [NSOperationQueue mainQueue];
                     NSLog(@"thread: %@", [NSThread currentThread]);
                     [NSURLConnection sendAsynchronousRequest:getDetailUrlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                         if ([data length] >0 && error == nil){
                             NSString *gameDetailJsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                             NSError *error = nil;
                             NSData *gameDetailJsonData = [gameDetailJsonString dataUsingEncoding:NSUTF8StringEncoding];
                             id gameDetailJsonObject = [NSJSONSerialization JSONObjectWithData:gameDetailJsonData options:NSJSONReadingAllowFragments error:&error];
                             if (gameDetailJsonObject != nil && error == nil && [gameDetailJsonObject[appidAsString][@"success"] boolValue]) {
                                 NSLog(@">>>>>>>idx<<<<<<<<: %d",i);
                                 NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_apps[i]];
                                 if ([gameDetailJsonObject[appidAsString][@"data"][@"is_free"] boolValue]) {
                                     [dict setObject:@"Free" forKey:@"price"];
                                 } else {
                                     [dict setObject:@"Paid" forKey:@"price"];
                                 }
                                 [dict setObject:gameDetailJsonObject[appidAsString][@"data"][@"detailed_description"] forKey:@"gameDescription"];
                                 [dict setObject:gameDetailJsonObject[appidAsString][@"data"][@"header_image"] forKey:@"gameImageUrl"];
                                 [_appsWithDetails addObject: dict];
//                                 Game *game = [[Game alloc] init];
//                                 game._gameName = gameDetailJsonObject[appidAsString][@"data"][@"name"];
//                                 game._gamePrice = gameDetailJsonObject[appidAsString][@"data"][@"is_free"];
//                                 game._gameDescription = gameDetailJsonObject[appidAsString][@"data"][@"detailed_description"];
//                                 game._gameImageUrl = gameDetailJsonObject[appidAsString][@"data"][@"header_image"];
//                                 [_games addObject:game];
                                 [self.tableView reloadData];
                             }
                         }
                     }];

                 }
                 NSLog(@">>>thread: %@", [NSThread currentThread]);
             }
             else if (error != nil){
                NSLog(@"An error happened while deserializing the JSON data.");
             }
         }
         else if ([data length] == 0 && error == nil){
             NSLog(@"Nothing was returned.");
         }
         else if (error != nil){
             NSLog(@"Error happened = %@", error);
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//     Return the number of rows in the section.
    return _appsWithDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"GamesTableViewCell";
    GamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GamesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    NSLog(@">>>>count of app details<<<<<: %lu", (unsigned long)_appsWithDetails.count);
    cell.lblGameName.text = _appsWithDetails[indexPath.row][@"name"];
    cell.lblGamePrice.text = _appsWithDetails[indexPath.row][@"price"];
    cell.lblGameDescription.text = _appsWithDetails[indexPath.row][@"gameDescription"];
    cell.ivGameImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: _appsWithDetails[indexPath.row][@"gameImageUrl"]]]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
