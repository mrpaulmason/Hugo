//
//  AppDelegate.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define kHUGOLocationChangeNotification @"kHUGOLocationChangeNotification"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *lastLocation;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *lastLocation;

- (void)setCurrentLocation:(CLLocation *)aCurrentLocation;
- (void)startStandardUpdates;

@end
