//
//  DishTableViewController.m
//  onepick
//
//  Created by yiqin on 4/22/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "DishTableViewController.h"

@interface DishTableViewController ()

@end

@implementation DishTableViewController

// Why synthesize?
@synthesize category;
// @synthesize bannerView = _bannerView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// initWithCoder: load only one time, which is the first time
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        // self.objectsPerPage = 2;

    }
    return self;
}

// viewWilAppear: load eveytime the page is visited
// viewDidLoad: load only one time, which is the first time
- (void)viewWillAppear:(BOOL)animated
{
    // You usually want to call the super class' implementation first in any method. In many languages it's required. In Objective-C it's not, but you can easily run into trouble if you don't put it at the top of your method. (That said, I sometimes break this pattern.)
    // So the answer is no not in a technical sense, but you should probably always do it.
    [super viewWillAppear:animated];
    
    // Grab the context
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SelectedDishes"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    // Return a fetch array.
    self.previousCart = [context executeFetchRequest:fetchRequest error:&error];

    
    NAMOTargeting *targeting = [[NAMOTargeting alloc] init];
    [targeting setEducation:NAMOEducationCollege];
    // [targeting setGender:NAMOGenderMale];
    [self.adPlacer requestAdsWithTargeting:targeting];
    
    
    [self.tableView namo_reloadData];
}

- (void)viewDidLoad
{
    //NSLog(@"Load dishes.");
    [super viewDidLoad];
    self.navigationItem.title = category;

    self.adPlacer = [NAMOTableViewAdPlacer placerForTableView:self.tableView];
    [self.adPlacer registerAdFormat:NAMOAdFormatSample1.class];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocalyticsSession shared] tagScreen:category];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable
{

    NSString *locationIndicator = [[NSString alloc] init];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"locationIndicator"] != nil) {
        locationIndicator = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationIndicator"];
    }
    else {
        locationIndicator = @"IN";
    }
    
    NSString *parseClassName =  [@"Dishes" stringByAppendingString:locationIndicator];
    
    PFQuery *query = [PFQuery queryWithClassName:parseClassName];
    [query whereKey:@"category" equalTo:category];
    
    //NSLog(@"parseClassName: %@", parseClassName);
    
    // enable caching.
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
}

// not namo_cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *) object
{
    static NSString *simpleTableIdentifier = @"dishCell";
    
    UITableViewCell *cell = [tableView namo_dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // [object objectForKey:@"dish"] is a JSON string.
    NSDictionary *dishInformation =  [[object objectForKey:@"dish"] JSONStringToDictionay];
    
    NSString *name = [dishInformation objectForKey:@"name"];
    UILabel *nameLabel = (UILabel *) [cell viewWithTag:200];
    nameLabel.text = name;
    
    UILabel *nameChineseLabel = (UILabel *) [cell viewWithTag:202];
    nameChineseLabel.text = [dishInformation objectForKey:@"nameChinese"];
    
    UILabel *priceLabel = (UILabel *) [cell viewWithTag:201];
    // NSNumber -> float -> string
    NSNumber *price = [dishInformation objectForKey:@"price"];
    priceLabel.text = [NSString stringWithFormat:@"Price: %.2f",[price floatValue]];

    NSNumber *ordered = [object objectForKey:@"orderCount"];
    UILabel *orderedLabel = (UILabel *) [cell viewWithTag:203];
    orderedLabel.text = [NSString stringWithFormat:@"Ordered: %i",[ordered intValue]];

    
    cell.accessoryType = UITableViewCellAccessoryNone;
    // Note that in self.previousCart is not NSString objects.
    for(SelectedDishes *previousDish in self.previousCart) {
        if ([previousDish.name isEqualToString:name]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Row: %i", indexPath.row);
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    NSDictionary *dishInformation =  [[object objectForKey:@"dish"] JSONStringToDictionay];
    
    UITableViewCell *cell = [tableView namo_cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Reflect selection in data model
        [self create:dishInformation withParseObjectId:[object objectId]];
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        // Reflect deselection in data model
        [self delete:[dishInformation objectForKey:@"name"]];
    }
    [tableView namo_deselectRowAtIndexPath:indexPath animated:YES];
}


// Core Data
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) create:(NSDictionary *)dishInformation withParseObjectId:(NSString *) parseObjectId{
    // As there is no built in method available, you need to fetch results and check whether result contains object you don't want to be duplicated.
    
    // Grab the context
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Grab the Label entity
    SelectedDishes *selectedDishes = [NSEntityDescription insertNewObjectForEntityForName:@"SelectedDishes" inManagedObjectContext:context];
    
    // Set dish name
    NSString *name = [dishInformation objectForKey:@"name"];
    if (name != nil) [selectedDishes setName:name];
    else [selectedDishes setName:@"no good name"];
    
    NSNumber *price = [dishInformation objectForKey:@"price"];
    if (price != nil) [selectedDishes setPrice:price];
    else [selectedDishes setPrice:[[NSNumber alloc] initWithFloat:10]];

    NSString *nameChinese = [dishInformation objectForKey:@"nameChinese"];
    if (nameChinese != nil) [selectedDishes setNameChinese:nameChinese];
    else [selectedDishes setNameChinese:@"还没有名字"];
    
    [selectedDishes setParseObjectId:parseObjectId];
    
    NSNumber *count = [[NSNumber alloc] initWithInt:1];
    [selectedDishes setCount:count];
    
    // Save everything
    NSError *error = nil;
    if (![context save:&error])
    {
        //NSLog(@"Error deleting movie, %@", [error userInfo]);
    }
    
}

- (void) delete: (NSString *)dishName {
    // As there is no built in method available, you need to fetch results and check whether result contains object you don't want to be duplicated.
    
    // Grab the context
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Fetch all the data we wanna delete
    NSFetchRequest *fetchDelete = [[NSFetchRequest alloc] init];
    fetchDelete.entity = [NSEntityDescription entityForName:@"SelectedDishes" inManagedObjectContext:context];
    fetchDelete.predicate = [NSPredicate predicateWithFormat:@"name == %@", dishName];
    NSArray *arrayDelete = [context executeFetchRequest:fetchDelete error:nil];
    
    for (NSManagedObject *managedObject in arrayDelete) {
        [context deleteObject:managedObject];
    }
    
    // Delete
    NSError *error = nil;
    if (![context save:&error])
    {
        //NSLog(@"Error deleting movie, %@", [error userInfo]);
    }

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
