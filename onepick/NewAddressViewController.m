//
//  NewAddressViewController.m
//  onepick
//
//  Created by yiqin on 4/30/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "NewAddressViewController.h"

@interface NewAddressViewController ()

@end

@implementation NewAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"Welcome to New Address.");
    self.navigationItem.title = @"New Address";
    
    [self.addStreet becomeFirstResponder];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocalyticsSession shared] tagScreen:@"New Address"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)submitAddress:(id)sender {
    //NSLog(@"Sumibt Address. %@", self.addStreet.text);
    //NSLog(@"%@", self.addApartment.text);
    
    if ([self.addStreet.text isEqualToString:@""]) {
        UIAlertView *alertStreet = [[UIAlertView alloc] initWithTitle:@"New Address"
                                                        message:@"Please fill the street information."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alertStreet show];
    } else if ([self.addApartment.text isEqualToString:@""]) {
        UIAlertView *alertApartment = [[UIAlertView alloc] initWithTitle:@"New Address"
                                                              message:@"Please fill the apartment number."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [alertApartment show];
    }
    else {
        NSString *locationIndicator = @"IN";
        NSMutableString *inputStreet = [[NSMutableString alloc] initWithString:self.addStreet.text];
        [inputStreet appendString: @" Unit #"];
        [inputStreet appendString: self.addApartment.text];
        // How to get the path distance?
        // Willowbrook 40.448668, -86.939104
        
        UIAlertView *alertAddress = [[UIAlertView alloc] initWithTitle:self.title
                                                               message:@""
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:@"Save",nil];
        
        // Add MBProgressHUD as indicator
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view.superview addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Analyzing...";
        [HUD show:YES];
        
        if ([locationIndicator isEqualToString:@"IN"]) {
            [inputStreet appendString:@" Lafayette, IN, USA"];
            // Ichiban 40.417421, -86.893315
            CLLocation *ichibanLocation = [[CLLocation alloc] initWithLatitude:40.417421 longitude:-86.893315];
            // User's address -> Machine address (readable)
            CLGeocoder* geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString: inputStreet
                         completionHandler:^(NSArray* placemarks, NSError* error){
                             if ([placemarks count] > 0) {
                                 // Need to check whether placemarks is 0 or not.
                                 CLPlacemark* aPlacemark = [placemarks objectAtIndex:0];
                                 if ([aPlacemark.addressDictionary objectForKey:@"Street"] != nil) {
                                     // initialize first
                                     self.formattedAddressLines = [[NSMutableString alloc] init];
                                     [self.formattedAddressLines appendString:[aPlacemark.addressDictionary objectForKey:@"Street"]];
                                     //NSLog(@"%@", aPlacemark.addressDictionary);
                                     [self.formattedAddressLines appendString: @", unit #"];
                                     [self.formattedAddressLines appendString: self.addApartment.text];
                                     [self.formattedAddressLines appendString: @", "];
                                     [self.formattedAddressLines appendString: [aPlacemark.addressDictionary objectForKey:@"City"]];
                                     [self.formattedAddressLines appendString: @", Indiana"];
                                     // [self.formattedAddressLines appendString: [aPlacemark.addressDictionary objectForKey:@"Country"]];
                                     
                                     // Get distance
                                     // Need to consider how to store the value of distance.
                                     self.distance = [[NSNumber alloc] initWithFloat:[aPlacemark.location distanceFromLocation:ichibanLocation]];
                                     
                                     NSMutableString* messageSummaryAddress = [[NSMutableString alloc] initWithString: self.formattedAddressLines];
                                     [messageSummaryAddress appendString: @"\nDistance "];
                                     [messageSummaryAddress appendString: [self.distance stringValue]];
                                     
                                     [HUD hide:YES];
                                     
                                     [alertAddress setMessage:messageSummaryAddress];
                                     [alertAddress show];
                                 }
                                 else {
                                     [HUD hide:YES];
                                     [alertAddress setMessage:@"This is a valid address."];
                                     [alertAddress show];
                                 }

                             }
                        }];
        }
    }
    
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //NSLog(@"Cancel button clicked");
            break;
        case 1:
            //NSLog(@"OK button clicked");
            [self updateCurrentAddress];
            
            [[LocalyticsSession shared] tagEvent:@"New Address"];
            
            // Here is the way to move back
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

- (void) updateCurrentAddress {
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Grab the Label entity
    Addresses *saveAddress = [NSEntityDescription insertNewObjectForEntityForName:@"Addresses" inManagedObjectContext:context];
    [saveAddress setStreet:self.formattedAddressLines];
    
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
    //NSLog(@"%i",[fetchAccountArray count]);
    
    if ([fetchAccountArray count] > 0) {
        Account *fetchAddress = [fetchAccountArray objectAtIndex:0];
        fetchAddress.address = self.formattedAddressLines;
        fetchAddress.distance = self.distance;
        // Save everything
        // include save to History Address
        NSError *errorCoreData = nil;
        if (![context save:&errorCoreData])
        {
            //NSLog(@"Error deleting movie, %@", [errorCoreData userInfo]);
        }
    }
    else {
        // Grab the Label entity
        Account *saveAccount = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
        [saveAccount setAddress:self.formattedAddressLines];
        [saveAccount setDistance:self.distance];
        // Save everything
        // include save to History Address
        NSError *errorCoreData = nil;
        if (![context save:&errorCoreData])
        {
            //NSLog(@"Error deleting movie, %@", [errorCoreData userInfo]);
        }
    }

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
