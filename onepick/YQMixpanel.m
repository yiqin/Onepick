//
//  YQMixpanel.m
//  onepick
//
//  Created by yiqin on 7/31/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "YQMixpanel.h"
#import "Mixpanel.h"

@implementation YQMixpanel

+ (void) initUser
{
    [Mixpanel sharedInstanceWithToken:@"52fcb0e29437cbbd3dcf1a571b6483f1"];

    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:mixpanel.distinctId];
}

+ (void) setAccountName:(NSString *)accountName
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel.people set:@{@"Account Name": accountName}];
    
    // All tracking events will have "Account Name" property.
    [mixpanel registerSuperProperties:@{@"Account Name": accountName}];
}

+ (void) enterApp
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Enter App."];
}

@end
