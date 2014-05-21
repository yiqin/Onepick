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
    //NSLog(@"Welcome to More.");
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
    [[LocalyticsSession shared] tagEvent:@"Update Account Information."];
    SelectRestaurantSignUpViewController *selectRestaurantSignUpViewController = (SelectRestaurantSignUpViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SelectRestaurantSignUpViewController"];
    [selectRestaurantSignUpViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:selectRestaurantSignUpViewController animated:YES];
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
            ////NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            ////NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            ////NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            ////NSLog(@"Mail sent failure: %@", [error localizedDescription]);
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
