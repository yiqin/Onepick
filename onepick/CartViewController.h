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

@interface CartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *previousCart;
@property (strong, nonatomic) NSMutableArray *cartArray;

@property (strong, nonatomic) IBOutlet UITableView *cartTableView;

@property (strong, nonatomic) IBOutlet UILabel *totalCredit;
@property (assign, nonatomic) float total;

@end
