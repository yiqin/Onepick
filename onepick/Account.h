//
//  Account.h
//  onepick
//
//  Created by yiqin on 5/9/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * distance;

@end
