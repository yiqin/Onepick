//
//  NewAddressViewController.h
//  onepick
//
//  Created by yiqin on 4/30/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "Addresses.h"
#import "MBProgressHUD.h"

// Do I need UITextFieldDelegate here?
@interface NewAddressViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *addTitle;
@property (strong, nonatomic) IBOutlet UITextField *addStreet;
@property (strong, nonatomic) IBOutlet UITextField *addApartment;

@property (strong, nonatomic) NSMutableString *formattedAddressLines;
@property (strong, nonatomic) NSNumber *distance;

@end
