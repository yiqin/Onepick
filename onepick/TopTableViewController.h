//
//  TopTableViewController.h
//  onepick
//
//  Created by yiqin on 5/7/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "SelectedDishes.h"
#import "NSString+JSONStringToDictionary.h"

#import "SelectRestaurantSignUpViewController.h"


@interface TopTableViewController : PFQueryTableViewController <UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *previousCart;

@end
