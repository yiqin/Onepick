//
//  AppDelegate.m
//  onepick
//
//  Created by yiqin on 4/21/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

// #define barTintColor [UIColor colorWithRed: 0.984 green: 0.471 blue: 0.525 alpha: 1]
//
// Reminder: You can use this calculator and put in what you want the color to be when rendered on screen, it will tell you what to set the color of the barTintColor so when Apple adjusts it, it will show as intended
//
#define barTintColor [UIColor colorWithRed: 226.0/255.0 green: 55.0/255.0 blue: 60.0/255.0 alpha: 1]
#define tintcolor [UIColor whiteColor]

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    // Define color.
    [[UINavigationBar appearance] setBarTintColor:barTintColor];
    [[UITabBar appearance] setTintColor:barTintColor];
    // White or black
    [[UINavigationBar appearance] setTintColor:tintcolor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : tintcolor}];
    // Set status bar style
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    // Parse.com
    [Parse setApplicationId:@"2D6T3tgwBIPoE8HkuninwT3gsUkrHouCfzg0MzDL"
                  clientKey:@"cmvDVWTEIrZO4phyuddppS96diUqckCKazxBEwxH"];
    // Parse Test
    /*
    PFObject *gameScore = [PFObject objectWithClassName:@"GameScore"];
    gameScore[@"score"] = @1337;
    gameScore[@"playerName"] = @"Sean Plott";
    gameScore[@"cheatMode"] = @NO;
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Parse succeed.");
        } else {
            // If it doesn't print Error, please check the wifi connection.
            NSLog(@"Error.");
        }
    }];
    */
    
    
    // Initialize data on Parse.com
    /*
    PFObject *ichibanCategory = [PFObject objectWithClassName:@"ichibanCategoryIN"];
    ichibanCategory[@"category"] = @"Beef";
    [ichibanCategory saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"ichiban category created.");
        } else {
            NSLog(@"ichiban category error.");
        }
    }];
    */
    
    /*
    PFObject *dish = [PFObject objectWithClassName:@"DishesIN"];
    
    NSString *name = [NSString stringWithFormat:@"Pork 1"];
    NSNumber *price = [NSNumber numberWithFloat:12.00];
    NSArray *dishArrayKeys = [NSArray arrayWithObjects:@"name",@"price", nil];
    NSArray *dishArrayObjects = [NSArray arrayWithObjects:name,price, nil];
    
    NSDictionary *dishDictionaryInput = [NSDictionary dictionaryWithObjects:dishArrayObjects forKeys:dishArrayKeys];
    NSString *dishDictionaryInputString = [dishDictionaryInput DictionaryToJSONString];
    
    dish[@"dish"] = dishDictionaryInputString;
    dish[@"category"] = @"Pork";
    dish[@"orderCount"] = @0;
    [dish saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Dish created.");
        } else {
            NSLog(@"Dish error.");
        }
    }];
    */
    
    /*
    // Test Parse cloud code setting
    [PFCloud callFunctionInBackground:@"hello"
                       withParameters:@{}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                        NSLog(@"Parse Cloud Code: %@", result);
                                    }
                                }];
    */
    
    // Namo Media
    [Namo setApplicationId:@"app-test-id"];
    [Namo setTestDevices:@[@"10EB5A48-9FA1-4364-AEC2-78CFADA2712A"] includeSimulator:YES];
    
    // Enable tracing.
    // [[LocalyticsSession shared] setLoggingEnabled:YES];
    
    // Initialize the library with your
    // Mixpanel project token, MIXPANEL_TOKEN
    // Account: yiqin.mems@gmail.com 52fcb0e29437cbbd3dcf1a571b6483f1
    //          sjtu_qy@hotmail.com 9b5647bedd42695430dffd02637d0556
    [Mixpanel sharedInstanceWithToken:@"9b5647bedd42695430dffd02637d0556"];
    

    
    // Core Data
    // Load the minimum
    // This is not the best way to do it.
    // Dispatch Queue
    // https://blog.stackmob.com/2012/12/iphone-database-tutorial-part-3-adding-the-user-interface/
    NSManagedObjectContext *context = [self managedObjectContext];;
    
    // Get address
    // Construct a fetch request
    NSFetchRequest *fetchRequestAccount = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityAccount = [NSEntityDescription entityForName:@"Account"
                                                     inManagedObjectContext:context];
    [fetchRequestAccount setEntity:entityAccount];
    NSError *errorAccount = nil;
    // Return a fetch array.
    NSArray *fetchAccountArray = [[NSArray alloc] init];
    fetchAccountArray = [context executeFetchRequest:fetchRequestAccount error:&errorAccount];
    NSLog(@"%lu",(unsigned long)[fetchAccountArray count]);
    
    if ([fetchAccountArray count] > 0) {
        Account *fetchAddress = [fetchAccountArray objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:fetchAddress.distance forKey:@"distance"];
    }
    else {
        NSNumber *tempDistance = [[NSNumber alloc] initWithFloat:6000.0];
        [[NSUserDefaults standardUserDefaults] setObject:tempDistance forKey:@"distance"];
    }
    
    // Update a string splited by space.
    [PFCloud callFunctionInBackground:@"minimumVersion"
                       withParameters:@{}
                                block:^(NSString *newMinimumVersion, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                        NSLog(@"Parse Cloud Code: %@", newMinimumVersion);
                                        NSString *currentMinimumVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"minimumVersion"];
                                        NSLog(@"%@", currentMinimumVersion);
                                        if (![currentMinimumVersion isEqualToString:newMinimumVersion]) {
                                            NSLog(@"Load new minimum price.");
                                            // Add MBProgressHUD as indicator
                                            UIViewController *c = topMostController();
                                            
                                            MBProgressHUD *minimumVersionHUD = [[MBProgressHUD alloc] initWithView:c.view];
                                            [c.view.superview addSubview:minimumVersionHUD];
                                            minimumVersionHUD.delegate = self;
                                            minimumVersionHUD.labelText = @"Updating System";
                                            [minimumVersionHUD show:YES];
                                            [PFCloud callFunctionInBackground:@"deliveryPriceSystem"
                                                               withParameters:@{}
                                                                        block:^(NSString *result, NSError *error) {
                                                                            if (!error) {
                                                                                // result is @"Hello world!"
                                                                                NSLog(@"Parse Cloud Code: %@", result);
                                                                                
                                                                                [[NSUserDefaults standardUserDefaults] setObject:newMinimumVersion forKey:@"minimumVersion"];
                                                                                [minimumVersionHUD hide:YES];
                                                                                NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"minimumVersion"]);
                                                                            }
                                                                        }];
                                        }
                                    }
                                }];
    
    return YES;
}

// I'm not sure how to update it.
// http://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller
UIViewController *_topMostController(UIViewController *cont) {
    UIViewController *topController = cont;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if ([topController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visible = ((UINavigationController *)topController).visibleViewController;
        if (visible) {
            topController = visible;
        }
    }
    
    return (topController != cont ? topController : nil);
}

UIViewController *topMostController() {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *next = nil;
    
    while ((next = _topMostController(topController)) != nil) {
        topController = next;
    }
    
    return topController;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[LocalyticsSession shared] LocalyticsSession:@"b2df1f3eea280c9fad7d1d5-daadee46-d72c-11e3-9d25-009c5fda0a25"];
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    // Comment this before shipping.
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
    
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    // NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"[same with name of xcdatamodeld]" withExtension:@"momd"];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Cart" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Cart.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
