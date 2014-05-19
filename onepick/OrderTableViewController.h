//
//  OrderTableViewController.h
//  onepick
//
//  Created by yiqin on 4/30/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Namo/Namo.h>


#import "AppDelegate.h"
#import "Account.h"

@interface OrderTableViewController : PFQueryTableViewController <UITableViewDelegate>

@property (strong, nonatomic) NSString *who;

@property(nonatomic, strong) NAMOTableViewAdPlacer *adPlacer;


@end
