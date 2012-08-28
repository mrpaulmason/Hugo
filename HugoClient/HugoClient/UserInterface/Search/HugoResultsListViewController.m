//
//  HugoResultsListViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoResultsListViewController.h"

@interface HugoResultsListViewController ()

@end

@implementation HugoResultsListViewController

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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultsListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	/*
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
	nameLabel.text = @"Nopalito";
	UILabel *gameLabel = (UILabel *)[cell viewWithTag:201];
	gameLabel.text =  @"Nopalito 2";

	UIImageView * img1 = (UIImageView *) [cell viewWithTag:100];
	img1.image = [UIImage imageNamed:@"icon.jpeg"];
	UIImageView * img2 = (UIImageView *) [cell viewWithTag:101];
	img2.image = [UIImage imageNamed:@"icon.jpeg"];
	UIImageView * img3 = (UIImageView *) [cell viewWithTag:102];
	img3.image = [UIImage imageNamed:@"icon.jpeg"];*/
    
        
    return cell;
}

@end
