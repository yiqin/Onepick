//
//  Cart.h
//  onepick
//
//  Created by yiqin on 4/28/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart : NSObject

@property (copy) NSDictionary *information;

- (void) add:(NSString *)dishName;
- (void) minus:(NSString *)dishName;


@end
