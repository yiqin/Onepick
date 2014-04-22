//
//  DishTableViewController.h
//  onepick
//
//  Created by yiqin on 4/22/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DishTableViewController : PFQueryTableViewController

@property (strong, nonatomic) NSString *category;

@end
