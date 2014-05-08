//
//  MoreViewController.h
//  onepick
//
//  Created by yiqin on 5/7/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Account.h"

#import <Namo/Namo.h>

@interface MoreViewController : UIViewController <UIActionSheetDelegate>

@property(strong, nonatomic) NAMOAdView *adView;

@end
