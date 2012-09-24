//
//  HugoVenueViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 9/24/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoVenueViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HugoVenueViewController ()

@end

@implementation HugoVenueViewController
@synthesize lbl1, lbl2, cellHeader;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    lbl1.layer.cornerRadius = 5.0f;
    lbl2.layer.cornerRadius = 5.0f;
    
    cellHeader.layer.cornerRadius = 5.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
