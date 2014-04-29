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
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        // self.objectsPerPage = 2;
        
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

        
        
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"Load dishes.");
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:category];
    NSLog(@"parseClassName: %@", category);
    
    // enable caching.
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *) object
{
    static NSString *simpleTableIdentifier = @"dishCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // [object objectForKey:@"dish"] is a JSON string.
    NSDictionary *dishInformation =  [[object objectForKey:@"dish"] JSONStringToDictionay];
    
    NSString *name = [dishInformation objectForKey:@"name"];
    UILabel *nameLabel = (UILabel *) [cell viewWithTag:200];
    nameLabel.text = [dishInformation objectForKey:@"name"];
    UILabel *priceLabel = (UILabel *) [cell viewWithTag:201];
    priceLabel.text = [[dishInformation objectForKey:@"price"] stringValue];

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
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    NSDictionary *dishInformation =  [[object objectForKey:@"dish"] JSONStringToDictionay];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Reflect selection in data model
        [self create:[dishInformation objectForKey:@"name"]];
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        // Reflect deselection in data model
        [self delete:[dishInformation objectForKey:@"name"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// Core Data
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) create: (NSString *)dishName {
    // As there is no built in method available, you need to fetch results and check whether result contains object you don't want to be duplicated.
    
    // Grab the context
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Grab the Label entity
    SelectedDishes *selectedDishes = [NSEntityDescription insertNewObjectForEntityForName:@"SelectedDishes" inManagedObjectContext:context];
    
    // Set dish name
    [selectedDishes setName:dishName];
    
    // Save everything
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"The save was successful!");
        // Read all data
        NSLog(@"Now we wanna retrieve the one just stored.");
        // Construct a fetch request
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SelectedDishes"
                                                  inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        // Return a fetch array.
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (SelectedDishes *tempselectedDishes in fetchedObjects) {
            NSLog(@"%@", tempselectedDishes.name);
        }
        
    } else {
        NSLog(@"The save wasn't successful: %@", [error userInfo]);
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
        NSLog(@"Error deleting movie, %@", [error userInfo]);
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
