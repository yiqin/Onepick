//
//  MoreViewController.h
//  onepick
//
//  Created by yiqin on 5/7/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalyticsSession.h"
#import <MessageUI/MessageUI.h>
#import <Colours.h>
#import "SelectRestaurantSignUpViewController.h"

@interface MoreViewController : UIViewController <MFMailComposeViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UIButton *feedbackButton;

@end
