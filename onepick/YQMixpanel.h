//
//  YQMixpanel.h
//  onepick
//
//  Created by yiqin on 7/31/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQMixpanel : NSObject

+ (void) initUser;
+ (void) setAccountName:(NSString*) accountName;
+ (void) enterApp;
+ (void) revenueTracking:(NSNumber*) revenue;

@end
