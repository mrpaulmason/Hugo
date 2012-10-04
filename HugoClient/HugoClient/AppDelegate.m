//
//  AppDelegate.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Flurry.h"
#import "TestFlight.h"

@implementation AppDelegate

@synthesize locationManager, lastLocation;

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [Parse setApplicationId:@"1Vc1VUGNYKnxMv9sTqAaCI4VTuDdQ5DlgMQLvCh7"
                  clientKey:@"CsU23rZMEWSx0f0dH0G6ggbitZlH2MuJ4D6gxvWr"];
    
    [PFFacebookUtils initializeWithApplicationId:@"469021446449087"];
    
    [TestFlight takeOff:@"f3546c22df22ac707f487b814315fd87_MTM0OTQwMjAxMi0wOS0yMiAwMzowMTo0NS41NjA4MjU"];
    
    [Flurry startSession:@"TDFXBX9KRC739CFN25M5"];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;

    
    NSLog(@"Application started");

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Facebook
// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

#pragma mark - Location Data
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
        [self setCurrentLocation:newLocation];
    }
    // else skip the event and process the next one.
}

- (void)setCurrentLocation:(CLLocation *)aCurrentLocation
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject: aCurrentLocation
                                                         forKey:@"location"];
    [[NSNotificationCenter defaultCenter] postNotificationName: kHUGOLocationChangeNotification
                                                        object:nil
                                                      userInfo:userInfo];
    [self setLastLocation:aCurrentLocation];
}

- (void)dealloc
{
    self.locationManager.delegate = nil;
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    self.lastLocation = [[CLLocation alloc] initWithLatitude:37.7793 longitude:-122.4192];
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500;
    
    [self.locationManager startUpdatingLocation];
}


@end
