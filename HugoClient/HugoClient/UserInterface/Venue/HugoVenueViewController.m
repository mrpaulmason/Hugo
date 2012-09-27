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
#import "SBJson.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    SBJsonParser *parser = [[SBJsonParser alloc] init];

    UIView *view = [UIView new];
    [view setFrame:CGRectMake(10.0f, 10.0f, 300.0f, 95.f)];
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    view.layer.borderWidth = 0.5f;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    [self.scrollView addSubview:view];
    _offset = _offset + 105.0f;

    HugoSocialView *socialView = [[HugoSocialView alloc] initWithFrame:CGRectMake(80, 15, 235, 55) andStatuses:[spotData objectForKey:@"statuses"] andPlace:[spotData objectForKey:@"fb_place_id"] withDelegate:nil];
    [socialView setTag:1];
    [self.scrollView addSubview:socialView];

    UILabel *labelVenue = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,10.0f,235.0f,18.f)];
    [labelVenue setText:[spotData objectForKey:@"spot_name"]];
        
    [labelVenue setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
    [labelVenue setTextColor:[UIColor blackColor]];
    [labelVenue sizeToFit];
    [view addSubview:labelVenue];
    
    UILabel *labelCategories = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,38.0f,235.0f,13.0f)];
    NSArray *categories = [parser objectWithString:[spotData objectForKey:@"spot_categories"]];
    
    NSString *tmpCategories = @"";
    
    for (NSDictionary *item in categories)
    {
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

    
    CGRect frame = self.scrollView.frame;
    frame.size.height = _offset > frame.size.height ? _offset : frame.size.height;
    self.scrollView.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
