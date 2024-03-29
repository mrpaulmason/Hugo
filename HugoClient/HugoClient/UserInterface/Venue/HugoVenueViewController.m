//
//  HugoVenueViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 9/24/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoVenueViewController.h"
#import "HugoSocialView.h"
#import "HugoSpotViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "SBJson.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "MKMapView+ZoomLevel.h"
#import "AddressAnnotation.h"
#import "HQuery.h"
#import "Flurry.h"
#import "HugoProfileViewController.h"

@interface HugoVenueViewController ()

@end

@implementation HugoVenueViewController
@synthesize scrollView, spotData, result;

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
    
    NSObject<MKAnnotation> *annotation = [[AddressAnnotation alloc] initWithCoordinate:coord withTitle:[spotData objectForKey:@"spot_name"] andSubtitle:[NSString stringWithFormat:@"%@\n%@, %@ %@", [locationData objectForKey:@"street"], [locationData objectForKey:@"city"], [locationData objectForKey:@"state"], [locationData objectForKey:@"zip"]]];
    
    [mapView addAnnotation:annotation];

    MKAnnotationView *annView = [mapView viewForAnnotation:annotation];
    
    NSArray *user_statuses = [spotData objectForKey:@"statuses"];
    
    NSString *comment = nil;
    int maxTime = 0;
    
    NSArray *authors_hugo = [spotData objectForKey:@"authors_hugo"];
    
    for( NSArray *author_bundle in authors_hugo)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[NSString stringWithFormat:@"%@",[author_bundle objectAtIndex:1]] isEqualToString:[NSString stringWithFormat:@"%@",[defaults objectForKey:@"hugo_id"]]])
        {
            maxTime = [[spotData objectForKey:@"timestamp"] intValue];
            comment = @"been";
        }
    }
    
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
        NSString *author_id = [NSString stringWithFormat:@"%@",[[spotData objectForKey:@"authors"] objectAtIndex:0]];
        NSDictionary *spot_statuses = [spotData objectForKey:@"spot_statuses"];
        
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
    
    annView.canShowCallout = NO;

    
    mapView.clipsToBounds = YES;
    mapView.layer.shadowOpacity = 0.8f;
    mapView.layer.shadowOffset = CGSizeMake(0,0.0);
    mapView.layer.shadowColor = [[UIColor blackColor] CGColor];
    mapView.layer.shadowRadius = 3.0f;
    
    [self.scrollView addSubview:mapView];
    
    [scrollView setUserInteractionEnabled:YES];
    
    _offset += 100.0f;

}

- (UIButton*) buttonFromImage:(NSString*)imgA withHighlight:(NSString*)imgB selector:(SEL) sel andFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    UIImage *buttonImageNormal = [UIImage imageNamed:imgA];
    UIImage *buttonImageDown = [UIImage imageNamed:imgB];
    [button setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    
    [button addTarget:self
               action:sel
     forControlEvents:UIControlEventTouchDown];
    
    button.frame = frame;
    return button;
}

- (void)addSpot:(id)sender
{
    [self performSegueWithIdentifier:@"segueAddSpot" sender:spotData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueAddSpot"])
    {
        HugoSpotViewController *vc = [segue destinationViewController];
        [vc setSpotData:sender];
    }
    else if ([[segue identifier] isEqualToString:@"segueProfile"])
    {
        NSLog(@"Segue to venue page");
        HugoProfileViewController *vc = [segue destinationViewController];
        
        for (NSArray* item in [result objectForKey:@"authors_hugo"])
        {
            if ([[item objectAtIndex:0] isEqualToString:sender])
            {
                [vc setSource:@"hugo"];
                [vc setProfileId:sender];
                [vc setHugoId:[NSString stringWithFormat:@"%@",[item objectAtIndex:1]]];
                return;
            }
        }
        
        [vc setSource:@"facebook"];
        [vc setProfileId:sender];
    }
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
    
    UIButton *addTip = [self buttonFromImage:@"assets/venue/addTip.png" withHighlight:@"assets/venue/addTipB.png" selector:@selector(addSpot:) andFrame:CGRectMake(0, 0, 150, 25)];
    UIButton *addPhoto = [self buttonFromImage:@"assets/venue/addPhoto.png" withHighlight:@"assets/venue/addPhotoB.png" selector:@selector(addSpot:) andFrame:CGRectMake(150, 0, 150, 25)];

    [bottomBar addSubview:addTip];
    [bottomBar addSubview:addPhoto];
    
    HugoSocialView *socialView = [[HugoSocialView alloc] initWithFrame:CGRectMake(80, 15+_offset, 235, 55) andStatuses:[spotData objectForKey:@"statuses"] andPlace:[spotData objectForKey:@"fb_place_id"] withDelegate:nil];
    [socialView setTag:1];
    [self.scrollView addSubview:socialView];

    _offset = _offset + 105.0f;
}

-(void)tapProfile:(UITapGestureRecognizer*)sender
{
    UIView* view = sender.view;
    CGPoint loc = [sender locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    
    NSString *author_id = [NSString stringWithFormat:@"%@",[[result objectForKey:@"authors"] objectAtIndex:subview.tag]];
    NSLog(@"tap! %@",author_id);
    [self performSegueWithIdentifier:@"segueProfile" sender:author_id];
    

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"gesture reocgnizer");
    return YES;
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
    [labelTitle setText:@"Spot Friends"];
    
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
            
            if ([JSON count] > 0)
            {
                self.result = [JSON objectAtIndex:0];
                NSArray *images = [result objectForKey:@"pics"];

                int i = 0;
                for(NSString *imgURL in images)
                {
                    if (i > 7) break;
                    

                    UIImageView * img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f+i*35, 33.f, 30, 30)];
                    img1.layer.cornerRadius = 5.0;
                    img1.layer.masksToBounds = YES;
                    img1.hidden = NO;
                    
                    [img1 setImageWithURL:[NSURL URLWithString:imgURL]];
                    [view addSubview:img1];
                    
                    NSString *author_id = [NSString stringWithFormat:@"%@",[[result objectForKey:@"authors"] objectAtIndex:i]];
                    NSDictionary *spot_statuses = [result objectForKey:@"spot_statuses"];
                    UIImageView * imgStatus = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f+17.5+i*35, 33.f+17.5, 15, 15)];
                    
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(tapProfile:)];
                    singleTap.numberOfTapsRequired = 1;
                    img1.tag = i;
                    [img1 setUserInteractionEnabled:YES];
                    singleTap.delegate = self;
                    [img1 addGestureRecognizer:singleTap];
                    
                    if ([spot_statuses objectForKey:author_id])
                    {
                        NSString *status = [[spot_statuses objectForKey:author_id] objectAtIndex:1];
                        
                        NSLog(@"%@ %d %@ %@", author_id, i, spot_statuses, imgURL);
                        
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
    
//    HugoSocialView *socialView = [[HugoSocialView alloc] initWithFrame:CGRectMake(80, 15+_offset, 235, 55) andStatuses:[spotData objectForKey:@"statuses"] andPlace:[spotData objectForKey:@"fb_place_id"] withDelegate:nil];
//    [socialView setTag:1];
  //  [self.scrollView addSubview:socialView];
    
    _offset = _offset + 80.0f;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Flurry logEvent:@"hugo.view.venue"];

    
    [[self navigationItem] setTitle:@"Place Details"];
    
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
