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
    self.cartArray = [[NSMutableArray alloc] initWithCapacity:[self.previousCart count]+1];
    if([self.previousCart count] > 0) {
        for (SelectedDishes *previousDish in self.previousCart) {
            // Why this line never work ?
            // The mutable array doesn't exist at the time this is being called.
            // The mutable array must be initalized first.
            [self.cartArray addObject:previousDish.name];
        }
    }
    else {
        [self.cartArray addObject:@"Your cart is empty."];
    }
    for(NSString *temp in self.cartArray) {
        NSLog(@"Cart Loop: %@", temp);
    }
    
    // Why here I need to add @property (strong, nonatomic) IBOutlet UITableView *cartTableView; to handle reloadData?
    [self.cartTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

    UILabel *nameLabel = (UILabel *) [cell viewWithTag:300];
    nameLabel.text = [self.cartArray objectAtIndex:indexPath.row];
    
    return cell;
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
