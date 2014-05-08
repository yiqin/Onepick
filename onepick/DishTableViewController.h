//
//  DishTableViewController.h
//  onepick
//
//  Created by yiqin on 4/22/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "SelectedDishes.h"
#import "NSString+JSONStringToDictionary.h"
// #import <iAd/iAd.h>

@interface DishTableViewController : PFQueryTableViewController <UITableViewDelegate>
// UIScrollViewDelegate, ADBannerViewDelegate
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSArray *previousCart;

// @property (nonatomic, strong) ADBannerView *bannerView;

@end
