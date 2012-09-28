//
//  HugoResultsListViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoResultsListViewController.h"
#import "AppDelegate.h"
#import "HQuery.h"
#import "SBJson.h"
#import "MKMapView+ZoomLevel.h"
#import "AddressAnnotation.h"
#import <QuartzCore/QuartzCore.h>

@interface HugoResultsListViewController ()

@end

@implementation HugoResultsListViewController
@synthesize results, tableView, mapView, categoryFilter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    CLLocationCoordinate2D coord = [[appDelegate lastLocation] coordinate];
    [mapView setCenterCoordinate:coord zoomLevel:11 animated:NO];
    
    [mapView setShowsUserLocation:YES];
    
    HQuery *hQuery = [[HQuery alloc] init];
    [hQuery queryResults:coord andCategory:categoryFilter andPlace:nil withCallback:^(id JSON, NSError *error) {
        if (error == nil)
        {
            NSLog(@"Received results!");
            self.results = JSON;
            
            [tableView reloadData];
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            double minLatitude = coord.latitude, maxLatitude = coord.latitude;
            double minLongitude = coord.longitude, maxLongitude = coord.longitude;
            double sumLatitude = coord.latitude, sumLongitude = coord.longitude;
            int c = 1;
                        

            for (NSDictionary *item in self.results)
            {
                NSError *error = [[NSError alloc] init];

                NSDictionary *locationData = [parser objectWithString:[item objectForKey:@"spot_location"] error:&error];
                
                
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[locationData objectForKey:@"latitude"] floatValue], [[locationData objectForKey:@"longitude"] floatValue]);
                
                sumLatitude += location.latitude;
                sumLongitude += location.longitude;
                c++;
                

                minLatitude = MIN(location.latitude, minLatitude);
                maxLatitude = MAX(location.latitude, maxLatitude);

                minLongitude = MIN(location.longitude, minLongitude);
                maxLongitude = MAX(location.longitude, maxLongitude);

                
                [mapView addAnnotation:[[AddressAnnotation alloc] initWithCoordinate:location withTitle:[item objectForKey:@"spot_name"] andSubtitle:[NSString stringWithFormat:@"%@\n%@, %@ %@", [locationData objectForKey:@"street"], [locationData objectForKey:@"city"], [locationData objectForKey:@"state"], [locationData objectForKey:@"zip"]]]];
                
            }
            
            [mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(sumLatitude/c, sumLongitude/c), MKCoordinateSpanMake(2.5*(maxLatitude-minLatitude), 2.5*(maxLongitude-minLongitude)))];
        
        }
    }];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultsListCell";
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
    nameLabel.text = [[results objectAtIndex:indexPath.row] objectForKey:@"spot_name"];
    
    NSDictionary *location_dict = [parser objectWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"spot_location"]  error:nil];
    
    UILabel *gameLabel = (UILabel *)[cell viewWithTag:201];
    gameLabel.text = [location_dict objectForKey:@"street"];
    
    NSArray *pics = [[results objectAtIndex:indexPath.row] objectForKey:@"pics"];
    
    
    for (int i = 0; i <= 6; i++)
    {
        UIImageView * img1 = (UIImageView *) [cell viewWithTag:100+i];
        img1.hidden = YES;
    }
    
    int c = 0;
    NSSet *imageSet = [NSSet setWithArray:pics];

    for(NSString *imgURL in imageSet)
    {
        UIImageView * img1 = (UIImageView *) [cell viewWithTag:100+c];
        img1.layer.cornerRadius = 5.0;
        img1.layer.masksToBounds = YES;
        img1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        img1.layer.borderWidth = 1.0;
        img1.hidden = NO;
        
        [img1 setImageWithURL:[NSURL URLWithString:imgURL]];
        c++;
    }
    
        
    return cell;
}

@end
