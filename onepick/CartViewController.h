//
//  CartViewController.h
//  onepick
//
//  Created by yiqin on 4/28/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "SelectedDishes.h"
#import "Account.h"

#import "NSDictionary+DictionaryToJSONString.h"

#import "OrderTableViewController.h"
#import "NewAddressViewController.h"
#import "HistoryAddressTableViewController.h"

#import "MBProgressHUD.h"

@interface CartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) NSArray *previousCart;
@property (strong, nonatomic) NSMutableArray *cartArray;

@property (strong, nonatomic) IBOutlet UITableView *cartTableView;

@property (assign, nonatomic) float totalDishesFloat;
@property (strong, nonatomic) IBOutlet UILabel *totalDishes;

@property (assign, nonatomic) float deliveryFeeFloat;
@property (strong, nonatomic) IBOutlet UILabel *deliveryFee;

@property (assign, nonatomic) float taxFloat;
@property (strong, nonatomic) IBOutlet UILabel *tax;

@property (assign, nonatomic) float totalPriceFloat;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;

@property (strong, nonatomic) IBOutlet UILabel *cartDeliveryAddress;



@property (strong, nonatomic) NSString *who;

@property (assign, nonatomic) float distanceFloat;

@property (strong, nonatomic) IBOutlet UILabel *mininumPrice;


@end
