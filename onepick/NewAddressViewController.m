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
    NSLog(@"Welcome to New Address.");
    self.navigationItem.title = @"New Address";
    
    [self.addTitle becomeFirstResponder];
    
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
    NSLog(@"Sumibt Address. %@", self.addStreet.text);
    NSLog(@"%@", self.addApartment.text);
    
    if ([self.addTitle.text isEqualToString:@""]) {
        UIAlertView *alertTitle = [[UIAlertView alloc] initWithTitle:@"New Address"
                                                              message:@"Please fill a title."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [alertTitle show];
    }
    else if ([self.addStreet.text isEqualToString:@""]) {
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
        
        // Add MBProgressHUD as indicator
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view.superview addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Analyzing...😊";
        [HUD show:YES];
        
        if ([locationIndicator isEqualToString:@"IN"]) {
            [inputStreet appendString:@" Lafayette, USA"];
            // Ichiban 40.417421, -86.893315
            CLLocation *ichibanLocation = [[CLLocation alloc] initWithLatitude:40.417421 longitude:-86.893315];
            // User's address -> Machine address (readable)
            CLGeocoder* geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString: inputStreet
                         completionHandler:^(NSArray* placemarks, NSError* error){
                             CLPlacemark* aPlacemark = [placemarks objectAtIndex:0];
                             // initialize first
                             self.formattedAddressLines = [[NSMutableString alloc] init];
                             [self.formattedAddressLines appendString:[aPlacemark.addressDictionary objectForKey:@"Street"]];
                             NSLog(@"%@", aPlacemark.addressDictionary);
                             [self.formattedAddressLines appendString: @", unit #"];
                             [self.formattedAddressLines appendString: self.addApartment.text];
                             [self.formattedAddressLines appendString: @", "];
                             [self.formattedAddressLines appendString: [aPlacemark.addressDictionary objectForKey:@"City"]];
                             [self.formattedAddressLines appendString: @", "];
                             [self.formattedAddressLines appendString: [aPlacemark.addressDictionary objectForKey:@"Country"]];
                             
                             // Core Data
                             // Grab the context
                             NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
                             // Grab the Label entity
                             Addresses *saveAddress = [NSEntityDescription insertNewObjectForEntityForName:@"Addresses" inManagedObjectContext:context];
                             [saveAddress setTitle:self.addTitle.text];
                             [saveAddress setStreet:self.formattedAddressLines];
                             
                             // Save everything
                             NSError *errorCoreData = nil;
                             if (![context save:&errorCoreData])
                             {
                                 NSLog(@"Error deleting movie, %@", [error userInfo]);
                             }
                             
                             // Get distance
                             // Need to consider how to store the value of distance.
                             self.distance = [[NSNumber alloc] initWithFloat:[aPlacemark.location distanceFromLocation:ichibanLocation]];
                             
                             NSMutableString* messageSummaryAddress = [[NSMutableString alloc] initWithString: self.formattedAddressLines];
                             [messageSummaryAddress appendString: @"\nDistance "];
                             [messageSummaryAddress appendString: [self.distance stringValue]];
                             
                             [HUD hide:YES];
                             UIAlertView *alertAddress = [[UIAlertView alloc] initWithTitle:self.title
                                                                                    message:messageSummaryAddress
                                                                                     delegate:self
                                                                            cancelButtonTitle:@"Cancel"
                                                                            otherButtonTitles:@"Save",nil];
                             [alertAddress show];
                         }];
        }
    }
    
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
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
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
