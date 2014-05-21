//
//  OrderDetailViewController.h
//  onepick
//
//  Created by yiqin on 5/21/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface OrderDetailViewController : UIViewController

@property (strong, nonatomic) NSString *orderObjectId;
@property (strong, nonatomic) IBOutlet UILabel *orderSummary;

@end
