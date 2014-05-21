//
//  OrderDetailViewController.m
//  onepick
//
//  Created by yiqin on 5/21/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

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
    self.orderSummary.lineBreakMode = NSLineBreakByWordWrapping;
    self.orderSummary.numberOfLines = 0;
    [self loadOrderDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadOrderDetails {
    PFQuery *query = [PFQuery queryWithClassName:@"Order"];
    [query getObjectInBackgroundWithId:self.orderObjectId block:^(PFObject *object, NSError *error) {
        if ([object objectForKey:@"summary"] != nil) {
            [self.orderSummary setText:[object objectForKey:@"summary"]];
        }
    }];
    
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
