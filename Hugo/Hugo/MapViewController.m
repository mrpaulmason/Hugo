//
//  MapViewController.m
//  Hugo
//
//  Created by Ryan Waliany on 8/7/12.
//  Copyright (c) 2012 Hugo. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "MKMapView+ZoomLevel.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // This is where the post happens
    [appDelegate setCurrentLocation:newLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Hugo";
    self.navigationController.navigationBar.tintColor = [UIColor
                                                         colorWithRed:40.0/255
                                                         green:100.0/255
                                                         blue:200.0/255
                                                         alpha:1];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationDidChange:)
                                                 name:kHUGOLocationChangeNotification
                                               object:nil];
    
    [mapView setShowsUserLocation:YES];

}

- (void)locationDidChange:(NSNotification *)note {
    // Update the table with the new points
    CLLocation *location = [[note userInfo] objectForKey:@"location"];
    
    [mapView setCenterCoordinate:location.coordinate zoomLevel:13 animated:YES];
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);

}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kHUGOLocationChangeNotification
                                                  object:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
