//
//  HugoVenueViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 9/24/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoVenueViewController.h"
#import "HugoSocialView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "SBJson.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "MKMapView+ZoomLevel.h"
#import "AddressAnnotation.h"
#import "HQuery.h"

@interface HugoVenueViewController ()

@end

@implementation HugoVenueViewController
@synthesize scrollView, spotData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _offset = 0;
        
//        self.scrollView.frame = CGRectMake(0, 0, 320.0f, 0);
    }
    return self;
}

- (void) initializeMap
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 100.0f)];
    NSDictionary *locationData = [parser objectWithString:[spotData objectForKey:@"spot_location"]];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[locationData objectForKey:@"latitude"] doubleValue] longitude:[[locationData objectForKey:@"longitude"] doubleValue]];

    CLLocationCoordinate2D coord = [locA coordinate];
    [mapView setCenterCoordinate:coord zoomLevel:12 animated:NO];
    
    [mapView addAnnotation:[[AddressAnnotation alloc] initWithCoordinate:coord withTitle:[spotData objectForKey:@"spot_name"] andSubtitle:[NSString stringWithFormat:@"%@\n%@, %@ %@", [locationData objectForKey:@"street"], [locationData objectForKey:@"city"], [locationData objectForKey:@"state"], [locationData objectForKey:@"zip"]]]];
    
    mapView.clipsToBounds = NO;
    mapView.layer.shadowOpacity = 0.8f;
    mapView.layer.shadowOffset = CGSizeMake(0,0.0);
    mapView.layer.shadowColor = [[UIColor blackColor] CGColor];
    mapView.layer.shadowRadius = 3.0f;
    
    [self.scrollView addSubview:mapView];
    
    _offset += 100.0f;                                                                     

}

- (void)initializeHeader
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(10.0f, 10.0f+_offset, 300.0f, 95.f)];
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    view.layer.borderWidth = 0.5f;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    [self.scrollView addSubview:view];
    
    UILabel *labelVenue = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,10.0f,235.0f,13.f)];
    
    [labelVenue setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
    [labelVenue setTextColor:[UIColor blackColor]];
    NSString *currentString = [spotData objectForKey:@"spot_name"];
    NSArray *firstWords = [currentString componentsSeparatedByString:@" "];
    int numWords = [firstWords count];
    
    do {
        [labelVenue setText:[[firstWords subarrayWithRange:NSMakeRange(0,numWords)] componentsJoinedByString:@" "]];
        [labelVenue sizeToFit];
        numWords--;
    } while (labelVenue.frame.size.width > 235.0f);

    [view addSubview:labelVenue];
    
    UILabel *labelCategories = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,28.0f,235.0f,13.0f)];
    NSArray *categories = [parser objectWithString:[spotData objectForKey:@"spot_categories"]];
    
    NSString *tmpCategories = @"";
    
    for (NSDictionary *item in categories)
    {
        if ([tmpCategories length] + [[item objectForKey:@"name"] length] > 30) continue;
        
        if ([tmpCategories isEqualToString:@""])
            tmpCategories = [tmpCategories stringByAppendingString:[[item objectForKey:@"name"] uppercaseString]];
        else
            tmpCategories = [tmpCategories stringByAppendingFormat:@", %@",[[item objectForKey:@"name"] uppercaseString]];
        
    }
    
    [labelCategories setText:tmpCategories];
    
    [labelCategories setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [labelCategories setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0]];
    [labelCategories sizeToFit];
    [view addSubview:labelCategories];
    
    NSDictionary *locationData = [parser objectWithString:[spotData objectForKey:@"spot_location"]];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[locationData objectForKey:@"latitude"] doubleValue] longitude:[[locationData objectForKey:@"longitude"] doubleValue]];
    CLLocationCoordinate2D coord = [[appDelegate lastLocation] coordinate];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    double miles = distance * 0.000621371;
    
    UILabel *labelMiles = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,46.0f,235.0f,13.f)];
    [labelMiles setText:[NSString stringWithFormat:@"%.1f miles away", miles]];
    
    [labelMiles setFont:[UIFont fontWithName:@"Helvetica" size:13.f]];
    [labelMiles setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0]];
    [labelMiles sizeToFit];
    [view addSubview:labelMiles];
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 70.f, 300.0f, 25.f)];
    bottomBar.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    [view addSubview:bottomBar];

    
    HugoSocialView *socialView = [[HugoSocialView alloc] initWithFrame:CGRectMake(80, 15+_offset, 235, 55) andStatuses:[spotData objectForKey:@"statuses"] andPlace:[spotData objectForKey:@"fb_place_id"] withDelegate:nil];
    [socialView setTag:1];
    [self.scrollView addSubview:socialView];

    _offset = _offset + 105.0f;
}

- (void)initializeFriends
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *locationData = [parser objectWithString:[spotData objectForKey:@"spot_location"]];
    
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(10.0f, 10.0f+_offset, 300.0f, 70.0f)];
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    view.layer.borderWidth = 0.5f;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    [self.scrollView addSubview:view];
    
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,10.0f,235.0f,13.f)];
    [labelTitle setText:@"Friends who have been here"];
    
    [labelTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
    [labelTitle setTextColor:[UIColor blackColor]];
    [labelTitle sizeToFit];
    [view addSubview:labelTitle];

    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[locationData objectForKey:@"latitude"] doubleValue] longitude:[[locationData objectForKey:@"longitude"] doubleValue]];
    
    CLLocationCoordinate2D coord = [locA coordinate];
    HQuery *hQuery = [[HQuery alloc] init];
    [hQuery queryResults:coord andCategory:@"" andPlace:[spotData objectForKey:@"fb_place_id"] withCallback:^(id JSON, NSError *error) {
        if (error == nil)
        {
            NSLog(@"Received results! %@", JSON);
            NSDictionary *result = [JSON objectAtIndex:0];
            NSSet *imageSet = [NSSet setWithArray:[result objectForKey:@"pics"]];

            int i = 0;
            for(NSString *imgURL in imageSet)
            {
                if (i > 7) break;

                UIImageView * img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f+i*35, 33.f, 25, 25)];
                img1.layer.cornerRadius = 5.0;
                img1.layer.masksToBounds = YES;
                img1.hidden = NO;
                
                [img1 setImageWithURL:[NSURL URLWithString:imgURL]];
                [view addSubview:img1];
                i++;
                
            }

            
        }
    }];
    
    [self.scrollView addSubview:view];
    
    
    _offset = _offset + 80.0f;
}


- (void)initializeAddress
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(10.0f, 10.0f+_offset, 300.0f, 70.0f)];
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    view.layer.borderWidth = 0.5f;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    [self.scrollView addSubview:view];
    
    NSDictionary *locationData = [parser objectWithString:[spotData objectForKey:@"spot_location"]];

    UILabel *labelStreet = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,10.0f,235.0f,13.f)];
    [labelStreet setText:[locationData objectForKey:@"street"]];
    
    [labelStreet setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [labelStreet setTextColor:[UIColor blackColor]];
    [labelStreet sizeToFit];
    [view addSubview:labelStreet];
    

    UILabel *labelAddress2 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,28.0f,235.0f,13.0f)];
    [labelAddress2 setText:[NSString stringWithFormat:@"%@, %@", [locationData objectForKey:@"city"], [locationData objectForKey:@"state"]]];
    [labelAddress2 setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [labelAddress2 setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0]];
    [labelAddress2 sizeToFit];
    [view addSubview:labelAddress2];
    
    
    UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,46.0f,235.0f,13.f)];
    [labelPhone setText:[spotData objectForKey:@"spot_phone"]];
    
    [labelPhone setFont:[UIFont fontWithName:@"Helvetica" size:13.f]];
    [labelPhone setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0]];
    [labelPhone sizeToFit];
    [view addSubview:labelPhone];
    
    HugoSocialView *socialView = [[HugoSocialView alloc] initWithFrame:CGRectMake(80, 15+_offset, 235, 55) andStatuses:[spotData objectForKey:@"statuses"] andPlace:[spotData objectForKey:@"fb_place_id"] withDelegate:nil];
    [socialView setTag:1];
    [self.scrollView addSubview:socialView];
    
    _offset = _offset + 80.0f;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"Venue Details"];
    
    [self initializeMap];
    [self initializeHeader];
    [self initializeFriends];
    [self initializeAddress];

    
    CGRect frame = self.scrollView.frame;
    frame.size.height = _offset+10;
    [self.scrollView setContentSize:frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
