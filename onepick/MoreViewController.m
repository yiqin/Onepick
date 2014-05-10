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
    
}


- (IBAction)changePhone:(id)sender {
    NSLog(@"change phone.");
    
    // Update phone number in Core Data.
    [self updatePhoneCoreData];
}

// Core Data
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) updatePhoneCoreData {
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
        fetchAddress.phone = @"7654041448";
        fetchAddress.name = @"Yi Qin";
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
        [saveAccount setPhone:@"7654041448"];
        [saveAccount setName:@"Yi Qin"];
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
