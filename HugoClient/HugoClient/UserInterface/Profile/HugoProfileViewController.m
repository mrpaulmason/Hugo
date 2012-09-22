//
//  HugoResultsListViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoProfileViewController.h"
#import "AppDelegate.h"
#import "HQuery.h"
#import "SBJson.h"
#import <QuartzCore/QuartzCore.h>

@interface HugoProfileViewController ()

@end

@implementation HugoProfileViewController
@synthesize results, tableView, header, profile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    header.layer.shadowColor = [UIColor blackColor].CGColor;
    header.layer.shadowRadius = 1.0;
    header.layer.shadowOffset = CGSizeMake(0, 1.0);
    header.layer.shadowOpacity = 0.3;
    
    HQuery *hQuery = [[HQuery alloc] init];
    [hQuery queryNewsfeed:@"user" withCallback:^(id JSON, NSError *error) {
        if (error == nil)
        {
            NSLog(@"Profile Received results!");
            self.results = JSON;
            [tableView reloadData];
        }
    }];
    
    [[self navigationItem] setTitle:@"Serena Wu"];

    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc]
                                   initWithCustomView:[self buttonFromImage:@"assets/profile/options.png" withHighlight:@"assets/profile/optionsB.png" selector:nil andFrame:CGRectMake(0, 0, 40, 30)]];
    self.navigationItem.leftBarButtonItem = optionsButton;

    UIBarButtonItem *addFriend = [[UIBarButtonItem alloc]
                                      initWithCustomView:[self buttonFromImage:@"assets/profile/addFriend.png" withHighlight:@"assets/profile/addFriendB.png" selector:nil andFrame:CGRectMake(0, 0, 40, 30)]];
    self.navigationItem.rightBarButtonItem = addFriend;
    
    profile.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    profile.layer.borderWidth = 1.0f;
    profile.layer.cornerRadius = 5.0f;
    profile.layer.masksToBounds = YES;

    
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
    NSLog(@"profile uh %d", [results count]);
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)sTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProfileCell";
    id appDelegate = [[UIApplication sharedApplication] delegate];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewStylePlain
                             reuseIdentifier:CellIdentifier];
    
    
    int photo_width = 0;
    int photo_height = 0;
    float scale = 0;
    
        
    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"photo"])
    {
        photo_height = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_height"] integerValue];
        photo_width = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_width"] integerValue];
        scale = 320.0f/photo_width;
        
        
        NSLog(@"photo! %f %f", photo_height*scale, photo_width*scale);
        
    }
    
    
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(10.0f, 10.0f, 300.0f, 95.f+photo_height*scale)];
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor colorWithWhite:0.85f alpha:1.0].CGColor;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1.0f;
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100, 100)];
    [view addSubview:button];
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 70.f+scale*photo_height, 300.0f, 25.f)];
    bottomBar.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    [view addSubview:bottomBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,10.f,200.0f,13.f)];
    NSString *name = [[results objectAtIndex:indexPath.row] objectForKey:@"author_name"];
    NSArray *names = [name componentsSeparatedByString:@" "];
    [label setText:[names objectAtIndex:0]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
    [label setTextColor:[UIColor colorWithWhite:0.2f alpha:1.0]];
    [label sizeToFit];
    [view addSubview:label];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f+[label frame].size.width,10.f,200.0f,13.f)];
    [label2 setText:@" has been to"];
    [label2 setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [label2 setTextColor:[UIColor colorWithWhite:0.53f alpha:1.0]];
    [label2 sizeToFit];
    [view addSubview:label2];
    
    UILabel *labelVenue = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,29.f,200.0f,13.f)];
    [labelVenue setText:[[results objectAtIndex:indexPath.row] objectForKey:@"spot_name"]];
    [labelVenue setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
    [labelVenue setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0]];
    [labelVenue sizeToFit];
    [view addSubview:labelVenue];
    
    UILabel *labelStreet = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,48.f,200.0f,13.f)];
    NSDictionary *locationData = [parser objectWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"spot_location"]];
    [labelStreet setText:[locationData objectForKey:@"street"]];
    [labelStreet setFont:[UIFont fontWithName:@"Helvetica" size:11.f]];
    [labelStreet setTextColor:[UIColor colorWithWhite:0.6f alpha:1.0]];
    [labelStreet sizeToFit];
    [view addSubview:labelStreet];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[locationData objectForKey:@"latitude"] doubleValue] longitude:[[locationData objectForKey:@"longitude"] doubleValue]];
    CLLocationCoordinate2D coord = [[appDelegate lastLocation] coordinate];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    double miles = distance * 0.000621371;
    double currentTime = [[NSDate date] timeIntervalSince1970];
    int minutesAgo = (currentTime - [[[results objectAtIndex:indexPath.row] objectForKey:@"timestamp"] integerValue])/60;
    int hoursAgo = minutesAgo/60;
    int daysAgo = hoursAgo/24;
    int monthsAgo = daysAgo/30;
    int yearsAgo = daysAgo/365;
    
    UILabel *milesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f,75.f+scale*photo_height,200.0f,25.f)];
    
    if (yearsAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"%d year%@ ago, %0.1f miles",yearsAgo,yearsAgo==1?@"":@"s", miles]];
    else if (monthsAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"%d month%@ ago, %0.1f miles",monthsAgo,monthsAgo==1?@"":@"s", miles]];
    else if (daysAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"%d day%@ ago, %0.1f miles",daysAgo,daysAgo==1?@"":@"s", miles]];
    else if (hoursAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"%d hour%@ ago, %0.1f miles",hoursAgo,hoursAgo==1?@"":@"s", miles]];
    else
        [milesLabel setText:[NSString stringWithFormat:@"%d minute%@ ago, %0.1f miles",minutesAgo,minutesAgo==1?@"":@"s", miles]];
    
    [milesLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.f]];
    [milesLabel setTextColor:[UIColor colorWithWhite:0.53f alpha:1.0]];
    [milesLabel setBackgroundColor:[UIColor clearColor]];
    [milesLabel sizeToFit];
    [view addSubview:milesLabel];

    
    
    [cell addSubview:view];
    
    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"photo"])
    {
        UIImageView *imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 75.f, 320.f, photo_height*scale)];
        imgPhoto.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        imgPhoto.layer.borderColor = [[UIColor whiteColor] CGColor];
        imgPhoto.layer.borderWidth = 3.0f;
        [imgPhoto setImageWithURL:[NSURL URLWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"photo_src"]]];
        [cell addSubview:imgPhoto];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float sz = 105;
    
    if ([indexPath row] == [results count]-1)
    {
        sz += 10;
    }
    
    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"photo"])
    {
        int photo_height = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_height"] integerValue];
        int photo_width = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_width"] integerValue];
        float scale = 320.0f/photo_width;
        
        sz += scale*photo_height;
    }
    
    
    return sz;
}

@end
