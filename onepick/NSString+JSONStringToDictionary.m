//
//  NSString+JSONStringToDictionary.m
//  onepick
//
//  Created by yiqin on 4/28/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "NSString+JSONStringToDictionary.h"

@implementation NSString (JSONStringToDictionary)

-(NSDictionary *) JSONStringToDictionay
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return dictionary;
}

@end
