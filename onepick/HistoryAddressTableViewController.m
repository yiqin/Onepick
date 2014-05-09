//
//  HistoryAddressTableViewController.m
//  onepick
//
//  Created by yiqin on 4/30/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "HistoryAddressTableViewController.h"

@interface HistoryAddressTableViewController ()

@end

@implementation HistoryAddressTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Core Data
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"Welcome to Cart.");
    // Grab the context
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Addresses"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    // Return a fetch array.
    self.historyAddress = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"History Address";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocalyticsSession shared] tagScreen:@"History Address"];
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
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.historyAddress count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"historyAddressCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    int historyAddreeCount = [self.historyAddress count];
    
    Addresses *address = [self.historyAddress objectAtIndex: historyAddreeCount-indexPath.row-1];
    
    UILabel *streetLabel = (UILabel *) [cell viewWithTag:400];
    streetLabel.text = address.street;
    NSLog(@"Title: %@", address.street);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Add MBProgressHUD as indicator
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view.superview addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Calculating the distance.";
    [HUD show:YES];
    
    int historyAddreeCount = [self.historyAddress count];
    Addresses *address = [self.historyAddress objectAtIndex: historyAddreeCount-indexPath.row-1];
    
    NSMutableString *inputAddressStreet = [[NSMutableString alloc] initWithString:address.street];
    [inputAddressStreet appendString:@", United States"];
    
    self.selectedAddress = [[NSString alloc] initWithString:address.street];
    
    // Ichiban 40.417421, -86.893315
    CLLocation *ichibanLocation = [[CLLocation alloc] initWithLatitude:40.417421 longitude:-86.893315];
    // User's address -> Machine address (readable)
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString: inputAddressStreet
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     CLPlacemark* aPlacemark = [placemarks objectAtIndex:0];
                     NSNumber *distance = [[NSNumber alloc] initWithFloat:[aPlacemark.location distanceFromLocation:ichibanLocation]];
                     [HUD hide:YES];
                     UIAlertView *alertAddress = [[UIAlertView alloc] initWithTitle:@"Distance"
                                                                            message:[distance stringValue]
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Cancel"
                                                                  otherButtonTitles:@"Save",nil];
                     [alertAddress show];
                     
                 }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel button clicked");
            break;
        case 1:
            NSLog(@"OK button clicked");
            // Here is the way to move back
            [[LocalyticsSession shared] tagEvent:@"Update History Address"];
            
            [self updateCurrentAddress];
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

- (void) updateCurrentAddress {
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Get address
    // Construct a fetch request
    NSFetchRequest *fetchRequestAccount = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityAccount = [NSEntityDescription entityForName:@"Account"
                                                     inManagedObjectContext:context];
    [fetchRequestAccount setEntity:entityAccount];
    NSError *errorAccount = nil;
    // Return a fetch array.
    NSArray *fetchAccountArray = [[NSArray alloc] init];
    fetchAccountArray = [context executeFetchRequest:fetchRequestAccount error:&errorAccount];

    if ([fetchAccountArray count] > 0) {
        Account *fetchAddress = [fetchAccountArray objectAtIndex:0];
        fetchAddress.address = self.selectedAddress;
    }
    
    // Save everything
    // include save to History Address
    NSError *errorCoreData = nil;
    if (![context save:&errorCoreData])
    {
        NSLog(@"Error deleting movie, %@", [errorCoreData userInfo]);
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
