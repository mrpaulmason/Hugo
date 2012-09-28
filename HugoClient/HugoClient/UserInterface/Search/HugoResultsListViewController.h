//
//  HugoResultsListViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HugoResultsListViewController : UIViewController
{
    NSArray *results;
    UITableView *tableView;
    MKMapView *mapView;
    NSString *categoryFilter;
    CLLocation *desiredLocation;
    int precision;
}

- (void) setDesiredPrecision:(int)_precision;

@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) NSString *categoryFilter;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocation *desiredLocation;

@end
