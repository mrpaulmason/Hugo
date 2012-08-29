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

@interface HugoResultsListViewController ()

@end

@implementation HugoResultsListViewController
@synthesize results, tableView;

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
    
    HQuery *hQuery = [[HQuery alloc] init];
    [hQuery queryResults:coord withCallback:^(id JSON, NSError *error) {
        if (error == nil)
        {
            NSLog(@"Received results!");
            self.results = JSON;
            [tableView reloadData];
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
    
    NSLog(@"cellFor: %@", [results objectAtIndex:indexPath.row]);

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
    nameLabel.text = [[results objectAtIndex:indexPath.row] objectForKey:@"spot_name"];
    
    NSString *location = [[results objectAtIndex:indexPath.row] objectForKey:@"spot_location"];
    NSDictionary *location_dict = [parser objectWithString:location error:nil];
    
    UILabel *gameLabel = (UILabel *)[cell viewWithTag:201];
    gameLabel.text = [location_dict objectForKey:@"street"];
    
    
    UIImageView * img1 = (UIImageView *) [cell viewWithTag:100];
    [img1 setImageWithURL:[NSURL URLWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"person_pic_small"]]];
    
    
        
    return cell;
}

@end
