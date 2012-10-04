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
#import "HugoSocialView.h"
#import "HugoVenueViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Flurry.h"

@interface HugoResultsListViewController ()

@end

@implementation HugoResultsListViewController
@synthesize results, tableView, mapView, categoryFilter, desiredLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [mapView setHidden:YES];


    return self;
}

- (void)refresh
{
    CLLocationCoordinate2D coord = [desiredLocation coordinate];

    HQuery *hQuery = [[HQuery alloc] init];
    [hQuery queryResults:coord andCategory:categoryFilter andPrecision:precision andPlace:nil withCallback:^(id JSON, NSError *error) {
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
                
                NSObject<MKAnnotation> *annotation = [[AddressAnnotation alloc] initWithCoordinate:location withTitle:[item objectForKey:@"spot_name"] andSubtitle:[NSString stringWithFormat:@"%@\n%@, %@ %@", [locationData objectForKey:@"street"], [locationData objectForKey:@"city"], [locationData objectForKey:@"state"], [locationData objectForKey:@"zip"]]];
                
                [mapView addAnnotation:annotation];
                MKAnnotationView *annView = [mapView viewForAnnotation:annotation];
                
                NSArray *user_statuses = [item objectForKey:@"statuses"];
                
                NSString *comment = nil;
                int maxTime = 0;
                
                for (NSDictionary *status in user_statuses)
                {
                    if ([[status objectForKey:@"timestamp"] intValue] > maxTime)
                    {
                        maxTime = [[status objectForKey:@"timestamp"] intValue];
                        comment = [status objectForKey:@"comment_message"];
                    }
                }
                                
                if (comment)
                {
                    if ([comment isEqualToString:@"here"])
                        annView.image = [UIImage imageNamed:@"assets/map/pinHereU.png"];
                    else if ([comment isEqualToString:@"been"])
                        annView.image = [UIImage imageNamed:@"assets/map/pinBeenU.png"];
                    else if ([comment isEqualToString:@"go"])
                        annView.image = [UIImage imageNamed:@"assets/map/pinGoU.png"];
                    else if ([comment isEqualToString:@"like"])
                        annView.image = [UIImage imageNamed:@"assets/map/pinLikeU.png"];
                    else if ([comment isEqualToString:@"meh"])
                        annView.image = [UIImage imageNamed:@"assets/map/pinMehU.png"];
                    else if ([comment isEqualToString:@"nah"])
                        annView.image = [UIImage imageNamed:@"assets/map/pinNahU.png"];
                    else
                        annView.image = [UIImage imageNamed:@"assets/map/pinBeenU.png"];
                    
                }
                else
                {
                    NSString *author_id = [NSString stringWithFormat:@"%@",[[item objectForKey:@"authors"] objectAtIndex:0]];
                    NSDictionary *spot_statuses = [item objectForKey:@"spot_statuses"];
                    
                    if ([spot_statuses objectForKey:author_id])
                    {
                        NSString *status = [[spot_statuses objectForKey:author_id] objectAtIndex:1];
                        
                        if ([status isEqualToString:@"here"])
                            annView.image = [UIImage imageNamed:@"assets/map/pinHere.png"];
                        else if ([status isEqualToString:@"been"])
                            annView.image = [UIImage imageNamed:@"assets/map/pinBeen.png"];
                        else if ([status isEqualToString:@"go"])
                            annView.image = [UIImage imageNamed:@"assets/map/pinGo.png"];
                        else if ([status isEqualToString:@"like"])
                            annView.image = [UIImage imageNamed:@"assets/map/pinLike.png"];
                        else if ([status isEqualToString:@"meh"])
                            annView.image = [UIImage imageNamed:@"assets/map/pinMeh.png"];
                        else if ([status isEqualToString:@"nah"])
                            annView.image = [UIImage imageNamed:@"assets/map/pinNah.png"];
                        else
                            annView.image = [UIImage imageNamed:@"assets/map/pinBeen.png"];
                        
                    }
                    else
                    {
                        annView.image = [UIImage imageNamed:@"assets/map/pinBeen.png"];
                    }
                }
                
                annView.tag = c-2;
                annView.canShowCallout = YES;
                annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                
                
            }
            
            [mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(sumLatitude/c, sumLongitude/c), MKCoordinateSpanMake(2.5*(maxLatitude-minLatitude), 2.5*(maxLongitude-minLongitude)))];
            
        }
    }];

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"segueVenue" sender:[results objectAtIndex:view.tag]];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{    
}

- (void)toggleMap:(UIBarButtonItem*)sender
{
    NSLog(@"%f", mapView.frame.size.height);
    if (mapView.frame.size.height < 135)
    {
        [mapView setFrame:CGRectMake(0, 0, 320, 400)];
        [sender setTitle:@"Map"];
    }
    else{
        [mapView setFrame:CGRectMake(0, 0, 320, 134)];
        [sender setTitle:@"List"];
    }

}

- (void)viewDidLoad
{
    CLLocationCoordinate2D coord = [desiredLocation coordinate];
    [mapView setShowsUserLocation:YES];
    [mapView setCenterCoordinate:coord zoomLevel:11 animated:NO];
    [mapView setHidden:NO];
    
    [Flurry logEvent:@"hugo.view.results"];

    
//    mapView.clipsToBounds = NO;
    mapView.layer.shadowOpacity = 0.8f;
    mapView.layer.shadowOffset = CGSizeMake(0,0.0);
    mapView.layer.shadowColor = [[UIColor blackColor] CGColor];
    mapView.layer.shadowRadius = 3.0f;

    
    [tableView setBackgroundColor:[UIColor colorWithWhite:0.89f alpha:1.0f]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMap:)];
    
//    [mapView setFrame:CGRectMake(0, 0, 320, 160)];

    NSLog(@"%@ %@", NSStringFromCGRect([tableView frame]), NSStringFromCGRect([mapView frame]));

    [self.navigationItem setTitle:categoryFilter];
    
    [self refresh];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) setDesiredPrecision:(int)_precision
{
    precision = _precision;
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueVenue"])
    {
        NSLog(@"Segue to venue page");
        HugoVenueViewController *vc = [segue destinationViewController];
        [vc setSpotData:sender];
    }
}

- (void)tableView:(UITableView *)sTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [self performSegueWithIdentifier:@"segueVenue" sender:[results objectAtIndex:indexPath.row]];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultsListCell";
    id appDelegate = [[UIApplication sharedApplication] delegate];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewStylePlain
                             reuseIdentifier:CellIdentifier];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *spotData = [results objectAtIndex:indexPath.row];
    
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(10.0f, 10.0f, 300.0f, 90.f)];
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    view.layer.borderWidth = 0.5f;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    [cell addSubview:view];
    
    
    NSArray *pics = [[results objectAtIndex:indexPath.row] objectForKey:@"pics"];
    NSLog(@"%@",results);
    
    int i = 0;
    for(NSString *imgURL in pics)
    {
        if (i > 6) break;
        
        
        UIImageView * img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f+i*35, 10.0f, 30, 30)];
        img1.layer.cornerRadius = 5.0;
        img1.layer.masksToBounds = YES;
        img1.hidden = NO;
        
        [img1 setImageWithURL:[NSURL URLWithString:imgURL]];
        [view addSubview:img1];
        
        NSString *author_id = [NSString stringWithFormat:@"%@",[[spotData objectForKey:@"authors"] objectAtIndex:i]];
        NSDictionary *spot_statuses = [spotData objectForKey:@"spot_statuses"];
        UIImageView * imgStatus = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f+17.5+i*35, 10.0f+17.5, 15, 15)];
        
        if ([spot_statuses objectForKey:author_id])
        {
            NSString *status = [[spot_statuses objectForKey:author_id] objectAtIndex:1];
            
            if ([status isEqualToString:@"here"])
                [imgStatus setImage:[UIImage imageNamed:@"assets/venue/badgeHere.png"]];
            else if ([status isEqualToString:@"been"])
                [imgStatus setImage:[UIImage imageNamed:@"assets/venue/badgeBeen.png"]];
            else if ([status isEqualToString:@"go"])
                [imgStatus setImage:[UIImage imageNamed:@"assets/venue/badgeGo.png"]];
            else if ([status isEqualToString:@"like"])
                [imgStatus setImage:[UIImage imageNamed:@"assets/venue/badgeLike.png"]];
            else if ([status isEqualToString:@"meh"])
                [imgStatus setImage:[UIImage imageNamed:@"assets/venue/badgeMeh.png"]];
            else if ([status isEqualToString:@"nah"])
                [imgStatus setImage:[UIImage imageNamed:@"assets/venue/badgeNah.png"]];
            else
                [imgStatus setImage:[UIImage imageNamed:@"assets/venue/badgeBeen.png"]];
            
        }
        else
        {
            [imgStatus setImage:[UIImage imageNamed:@"assets/venue/badgeBeen.png"]];
        }
        [view addSubview:imgStatus];
        
        i++;
        
    }


    UILabel *labelVenue = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,45.0f,235.0f,13.f)];
    
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
    
    NSDictionary *locationData = [parser objectWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"spot_location"]  error:nil];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[locationData objectForKey:@"latitude"] doubleValue] longitude:[[locationData objectForKey:@"longitude"] doubleValue]];
    CLLocationCoordinate2D coord = [[appDelegate lastLocation] coordinate];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    double miles = distance * 0.000621371;
    
    UILabel *labelStreet = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,63.0f,235.0f,13.f)];
    
    if ([[locationData objectForKey:@"street"] isEqualToString:@""])
    {
        [labelStreet setText:[NSString stringWithFormat:@"%@ (%.1f mi)",[locationData objectForKey:@"city"], miles]];
    }
    else
        [labelStreet setText:[NSString stringWithFormat:@"%@ (%.1f mi)",[locationData objectForKey:@"street"], miles]];
    
    [labelStreet setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [labelStreet setTextColor:[UIColor blackColor]];
    [labelStreet sizeToFit];
    [view addSubview:labelStreet];
    
    
    HugoSocialView *socialView = [[HugoSocialView alloc] initWithFrame:CGRectMake(80, 15, 235, 55) andStatuses:[spotData objectForKey:@"statuses"] andPlace:[spotData objectForKey:@"fb_place_id"] withDelegate:self];
    [socialView setTag:1];
    [cell addSubview:socialView];

    
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float sz = 100.f;
    return sz;
}


@end
