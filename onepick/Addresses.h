//
//  Addresses.h
//  onepick
//
//  Created by yiqin on 5/3/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Addresses : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * street;

@end
