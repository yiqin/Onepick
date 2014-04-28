//
//  Cart.m
//  onepick
//
//  Created by yiqin on 4/28/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "Cart.h"

@implementation Cart

@synthesize information = _information;    // Optional for Xcode 4.4+

- (void) add:(NSString *)dishName {
    NSLog(@"add");
}

- (void) minus:(NSString *)dishName {
    NSLog(@"minus");
}


@end
