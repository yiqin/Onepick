//
//  MenuTableViewController.m
//  onepick
//
//  Created by yiqin on 4/21/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "MenuTableViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // self.parseClassNmae didn't work efficiently.
        // The className to query on
        // self.parseClassName = @"ichibanCategoryIN";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        // self.objectsPerPage = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    //NSLog(@"Load the menu.");
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocalyticsSession shared] tagScreen:@"Menu"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
- (PFQuery *)queryForTable
{
    
    NSString *locationIndicator = [[NSString alloc] init];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"locationIndicator"] != nil) {
        locationIndicator = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationIndicator"];
    }
    else {
        locationIndicator = @"IN";
    }
    
    NSString *parseClassName =  [@"ichibanCategory" stringByAppendingString:locationIndicator];
    
    PFQuery *query = [PFQuery queryWithClassName:parseClassName];
    
    // enable caching.
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;

    return query;
}

// Not sure it is UITableViewCell or PFTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *) object
{
    static NSString *simpleTableIdentifier = @"categoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *categoryLabel = (UILabel *) [cell viewWithTag:100];
    categoryLabel.text = [object objectForKey:@"category"];
    
    UILabel *categoryChineseLabel = (UILabel *) [cell viewWithTag:101];
    categoryChineseLabel.text = [object objectForKey:@"category"];
    
    
    return cell;
}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //NSLog(@"Start to move to dishes.");
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    // Send selection to DishTableViewController.
    DishTableViewController *destViewController = segue.destinationViewController;
    
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    
    destViewController.category = [object objectForKey:@"category"];
    
    //NSLog(@"%@",destViewController.category);
    
}


@end
