//
//  MoreViewController.m
//  onepick
//
//  Created by yiqin on 5/7/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Errors too.

}

- (void)viewDidLoad
{
    NSLog(@"Welcome to More.");
    [super viewDidLoad];
    
    [self.feedbackButton setBackgroundColor:[UIColor waveColor]];
    
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocalyticsSession shared] tagScreen:@"More"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeRestaurant:(id)sender {
    NSLog(@"change restaurant.");
    UIAlertView *changeRestaurantAlert = [[UIAlertView alloc] initWithTitle:@"Change Restaurant"
                                                                    message:@"Pick the one near you."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Madison"
                                                          otherButtonTitles:@"West Lafayette", nil];
    [changeRestaurantAlert setTag:1];
    [changeRestaurantAlert show];
    // update distance in Core data
}


- (IBAction)changePhone:(id)sender {
    NSLog(@"change phone.");
    UIAlertView *changePhoneAlert = [[UIAlertView alloc] initWithTitle:@"Update Phone"
                                                               message:@"Enter your phone number in 10 digits."
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:@"Save",nil];
    
    [changePhoneAlert setTag:2];
    changePhoneAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [changePhoneAlert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"7650001111";
    [changePhoneAlert show];
    
}


#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"IN");
                [[NSUserDefaults standardUserDefaults] setObject:@"IN" forKey:@"locationIndicator"];
                break;
            case 1:
                NSLog(@"WI");
                [[NSUserDefaults standardUserDefaults] setObject:@"WI" forKey:@"locationIndicator"];
                break;
            default:
                break;
        }
    }
    else if (alertView.tag == 2) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Confirm");
                // Update phone number in Core Data.
                [self updatePhoneCoreData: [[alertView textFieldAtIndex:0] text]];

                break;
            default:
                break;
        }
    }
}




// Core Data
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) updatePhoneCoreData: (NSString *) phoneToBeSaved {
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
    NSLog(@"%i",[fetchAccountArray count]);
    
    if ([fetchAccountArray count] > 0) {
        Account *fetchAddress = [fetchAccountArray objectAtIndex:0];
        fetchAddress.phone = phoneToBeSaved;
        // Save everything
        // include save to History Address
        NSError *errorCoreData = nil;
        if (![context save:&errorCoreData])
        {
            NSLog(@"Error deleting movie, %@", [errorCoreData userInfo]);
        }
    }
    else {
        // Grab the Label entity
        Account *saveAccount = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
        [saveAccount setPhone:phoneToBeSaved];
        // Save everything
        // include save to History Address
        NSError *errorCoreData = nil;
        if (![context save:&errorCoreData])
        {
            NSLog(@"Error deleting movie, %@", [errorCoreData userInfo]);
        }
    }
    
}

- (IBAction)sendFeedbackInEmail:(id)sender {
    // The user can give feedback here...
    // Email Subject
    NSString *emailTitle = @"Hi Ichiban iOS team";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"yiqin.mems@gmail.com"];
    
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Change UIBarButtonItem color
    [[mc navigationBar] setTintColor:[UIColor whiteColor]];
    
    // Set the UIApplication statusBarStyle in the completion block
    [self presentViewController:mc animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
