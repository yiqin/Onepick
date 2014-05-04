//
//  HistoryAddressTableViewController.h
//  onepick
//
//  Created by yiqin on 4/30/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Addresses.h"
#import "MBProgressHUD.h"

@interface HistoryAddressTableViewController : UITableViewController <UIAlertViewDelegate, MBProgressHUDDelegate>

@property(strong, nonatomic) NSArray *historyAddress;

@end
