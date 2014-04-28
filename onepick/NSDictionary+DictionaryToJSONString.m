//
//  NSDictionary+DictionaryToJSONString.m
//  onepick
//
//  Created by yiqin on 4/28/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "NSDictionary+DictionaryToJSONString.h"

@implementation NSDictionary (DictionaryToJSONString)

- (NSString *)DictionaryToJSONString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
