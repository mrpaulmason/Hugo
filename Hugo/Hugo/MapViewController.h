//
//  MapViewController.h
//  Hugo
//
//  Created by Ryan Waliany on 8/7/12.
//  Copyright (c) 2012 Hugo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
{
    MKMapView *mapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;



@end
