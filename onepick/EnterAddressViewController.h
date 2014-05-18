//
//  EnterAddressViewController.h
//  onepick
//
//  Created by yiqin on 5/11/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "Addresses.h"
#import "Account.h"

#import "MBProgressHUD.h"

@interface EnterAddressViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>


@property (strong, nonatomic) IBOutlet UITextField *addStreet;
@property (strong, nonatomic) IBOutlet UITextField *addApartment;


@property (strong, nonatomic) NSMutableString *formattedAddressLines;
@property (strong, nonatomic) NSNumber *distance;

@end
