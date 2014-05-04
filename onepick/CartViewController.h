//
//  CartViewController.h
//  onepick
//
//  Created by yiqin on 4/28/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SelectedDishes.h"

#import "OrderTableViewController.h"
#import "NewAddressViewController.h"
#import "HistoryAddressTableViewController.h"

@interface CartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) NSArray *previousCart;
@property (strong, nonatomic) NSMutableArray *cartArray;

@property (strong, nonatomic) IBOutlet UITableView *cartTableView;

@property (assign, nonatomic) float totalDishesFloat;
@property (strong, nonatomic) IBOutlet UILabel *totalDishes;

@property (strong, nonatomic) IBOutlet UILabel *deliveryFee;


@end
