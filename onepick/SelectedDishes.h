//
//  SelectedDishes.h
//  onepick
//
//  Created by yiqin on 4/29/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SelectedDishes : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameChinese;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSString * parseObjectID;

@end
