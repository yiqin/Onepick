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
    NAMOTargeting *targeting = [[NAMOTargeting alloc] init];
    [targeting setGender:NAMOGenderMale];
    
    [self.adView requestAdWithTargeting:targeting];
    // Errors too.

}

- (void)viewDidLoad
{
    NSLog(@"Welcome to More.");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.adView = [[NAMOAdView alloc] initWithFrame:CGRectMake(
                                                                     10, 200, 80, 80)];
    [self.adView registerAdFormat:NAMOAdFormatSample1.class];
    [self.view addSubview:self.adView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeRestaurant:(id)sender {
    
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
