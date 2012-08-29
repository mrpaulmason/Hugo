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

@interface HugoResultsListViewController ()

@end

@implementation HugoResultsListViewController
@synthesize results, tableView, mapView;

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
    [mapView setCenterCoordinate:coord zoomLevel:11 animated:YES];
    
    HQuery *hQuery = [[HQuery alloc] init];
    [hQuery queryResults:coord withCallback:^(id JSON, NSError *error) {
        if (error == nil)
        {
            NSLog(@"Received results!");
            self.results = JSON;
            [tableView reloadData];
            SBJsonParser *parser = [[SBJsonParser alloc] init];

            for (NSDictionary *item in self.results)
            {
                NSString *locationS = [[item objectForKey:@"spot_location"] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
                NSError *error = [[NSError alloc] init];

                NSDictionary *locationData = [parser objectWithString:locationS error:&error];
                
                
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[locationData objectForKey:@"latitude"] floatValue], [[locationData objectForKey:@"longitude"] floatValue]);
                
                [mapView addAnnotation:[[AddressAnnotation alloc] initWithCoordinate:location withTitle:[item objectForKey:@"spot_name"] andSubtitle:[NSString stringWithFormat:@"%@\n%@, %@ %@", [locationData objectForKey:@"street"], [locationData objectForKey:@"city"], [locationData objectForKey:@"state"], [locationData objectForKey:@"zip"]]]];
                
            }


        
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
    
//    NSLog(@"cellFor: %@", [results objectAtIndex:indexPath.row]);

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
    nameLabel.text = [[results objectAtIndex:indexPath.row] objectForKey:@"spot_name"];
    
    NSString *locationS = [[[results objectAtIndex:indexPath.row] objectForKey:@"spot_location"] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    
    NSDictionary *location_dict = [parser objectWithString:locationS error:nil];
    
    UILabel *gameLabel = (UILabel *)[cell viewWithTag:201];
    gameLabel.text = [location_dict objectForKey:@"street"];
    
    
    UIImageView * img1 = (UIImageView *) [cell viewWithTag:100];
    [img1 setImageWithURL:[NSURL URLWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"person_pic_small"]]];
    
    
        
    return cell;
}

@end
