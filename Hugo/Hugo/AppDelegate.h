//
//  AppDelegate.h
//  Hugo
//
//  Created by Ryan Waliany on 8/6/12.
//  Copyright (c) 2012 Hugo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) MainViewController *mainViewController;

@end
