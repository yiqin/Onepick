//
//  AppDelegate.h
//  onepick
//
//  Created by yiqin on 4/21/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import <Namo/Namo.h>
#import "LocalyticsSession.h"

#import "SelectedDishes.h"
#import "NSDictionary+DictionaryToJSONString.h"

#import "Account.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
