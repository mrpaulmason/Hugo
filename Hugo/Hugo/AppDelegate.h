//
//  AppDelegate.h
//  Hugo
//
//  Created by Ryan Waliany on 8/6/12.
//  Copyright (c) 2012 Hugo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class MainViewController;


#define kHUGOLocationChangeNotification @"kHUGOLocationChangeNotification"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setCurrentLocation:(CLLocation *)aCurrentLocation;

@property (strong, nonatomic) MainViewController *mainViewController;

@end
