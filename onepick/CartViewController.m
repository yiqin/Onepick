//
//  CartViewController.m
//  onepick
//
//  Created by yiqin on 4/28/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()

@end

@implementation CartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Core Data
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// viewWilAppear: load eveytime the page is visited
// viewDidLoad: load only one time, that is the first time
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Welcome to Cart.");
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
    // Since the table view will use array, it is not necessary to use dictionary to handle these data. Reload all the data here.
    // Also Core Data return an array.
    // Note that all data in Cart are mutable.
    if([self.previousCart count] > 0) {
        self.cartArray = [[NSMutableArray alloc] initWithCapacity:[self.previousCart count]];
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        NSMutableArray *objects = [[NSMutableArray alloc] init];
        NSMutableDictionary *dishDictionary = [[NSMutableDictionary alloc] init];
        for (SelectedDishes *previousDish in self.previousCart) {
            // Why this line never work ?
            // The mutable array doesn't exist at the time this is being called.
            // The mutable array must be initalized first.
            keys = [NSMutableArray arrayWithObjects:@"name", @"price", @"nameChinese", @"parseObjectId",@"count", nil];
            objects = [NSMutableArray arrayWithObjects:previousDish.name, previousDish.price, previousDish.nameChinese, previousDish.parseObjectId,previousDish.count, nil];
            dishDictionary = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
            [self.cartArray addObject:dishDictionary];
        }
    }
    else {
        // [self.cartArray addObject:@"Your cart is empty."];
    }
    
    // Why here I need to add @property (strong, nonatomic) IBOutlet UITableView *cartTableView; to handle reloadData?
    [self.cartTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init a mutable dictionary here, or not?
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.previousCart count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cartCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    NSMutableDictionary *dishDictionary = [self.cartArray objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *) [cell viewWithTag:300];
    nameLabel.text = [dishDictionary objectForKey:@"name"];
    UILabel *priceLabel = (UILabel *) [cell viewWithTag:301];
    priceLabel.text = [[dishDictionary objectForKey:@"price"] stringValue];
    UILabel *nameChineseLabel = (UILabel *) [cell viewWithTag:302];
    nameChineseLabel.text = [dishDictionary objectForKey:@"nameChinese"];
    UILabel *countLabel = (UILabel *) [cell viewWithTag:303];
    countLabel.text = [[dishDictionary objectForKey:@"count"] stringValue];
    
    // Dynamically add buttons
    // add button
    UIButton *addDishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addDishButton.tag = indexPath.row;
    addDishButton.frame = CGRectMake(200.0f, 5.0f, 75.0f, 30.0f);
    [addDishButton setTitle:@"Add" forState:UIControlStateNormal];
    [cell addSubview:addDishButton];
    [addDishButton addTarget:self
                        action:@selector(addDish:)
              forControlEvents:UIControlEventTouchUpInside];

    // minus button
    UIButton *minusDishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    minusDishButton.tag = indexPath.row;
    minusDishButton.frame = CGRectMake(200.0f, 50.0f, 75.0f, 30.0f);
    [minusDishButton setTitle:@"Delete" forState:UIControlStateNormal];
    [cell addSubview:minusDishButton];
    [minusDishButton addTarget:self
                      action:@selector(minusDish:)
            forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (IBAction)addDish:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSMutableDictionary *dishInformation = [self.cartArray objectAtIndex:senderButton.tag];
    // NSNumber are not really used to store numbers in actual math.
    int previousCount = [[dishInformation objectForKey:@"count"] integerValue];
    NSNumber *currentCount = [[NSNumber alloc] initWithInt:previousCount+1];
    [dishInformation setValue:currentCount forKey:@"count"];
    [self.cartTableView reloadData];
    [self updateCount:[dishInformation objectForKey:@"name"] withCount:currentCount];
}

- (IBAction)minusDish:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSMutableDictionary *dishInformation = [self.cartArray objectAtIndex:senderButton.tag];
    // NSNumber are not really used to store numbers in actual math.
    int previousCount = [[dishInformation objectForKey:@"count"] integerValue];
    if (previousCount > 1) {
        NSNumber *currentCount = [[NSNumber alloc] initWithInt:previousCount-1];
        [dishInformation setValue:currentCount forKey:@"count"];
        [self.cartTableView reloadData];
        [self updateCount:[dishInformation objectForKey:@"name"] withCount:currentCount];
    }
    else if (previousCount == 1) {
        NSNumber *currentCount = [[NSNumber alloc] initWithInt:previousCount-1];
        [dishInformation setValue:currentCount forKey:@"count"];
        [self.cartTableView reloadData];
        [self deleteZeroDish:[dishInformation objectForKey:@"name"]];
    }
}

// Save counts in Core Data
- (void) updateCount:(NSString *)dishName withCount:(NSNumber *) count {
    // Grab the context
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Fetch all the data we wanna delete
    NSFetchRequest *fetchUpdate = [[NSFetchRequest alloc] init];
    fetchUpdate.entity = [NSEntityDescription entityForName:@"SelectedDishes" inManagedObjectContext:context];
    fetchUpdate.predicate = [NSPredicate predicateWithFormat:@"name == %@", dishName];
    NSArray *arrayUpdate = [context executeFetchRequest:fetchUpdate error:nil];
    
    // maybe some check before, to be sure results is not empty
    if ([arrayUpdate count] > 0) {
        NSManagedObject* updateGrabbed = [arrayUpdate objectAtIndex:0];
        [updateGrabbed setValue:count forKey:@"count"];
    }
    
    // Delete
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Error deleting movie, %@", [error userInfo]);
    }
}

// Delete zero dish in Core Data
- (void) deleteZeroDish: (NSString *)dishName {
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do some stuff when the row is selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
