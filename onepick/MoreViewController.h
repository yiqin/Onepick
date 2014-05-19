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
#import <MessageUI/MessageUI.h>
#import <Colours.h>

@interface MoreViewController : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UIButton *feedbackButton;

@end
