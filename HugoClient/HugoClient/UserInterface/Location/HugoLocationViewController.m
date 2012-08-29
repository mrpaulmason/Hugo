//
//  HugoLocationViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/28/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoLocationViewController.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"

@interface HugoLocationViewController ()

@end

@implementation HugoLocationViewController
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

//    NSString *requestPath = [NSString stringWithFormat:@"search?q=coffee&type=place&center=%f,%f&distance=1000&fields=location,picture,name", coord.latitude, coord.longitude];
    NSString *requestPath = [NSString stringWithFormat:@"search?q=*&type=place&center=%f,%f&distance=1000&fields=location,picture,name", coord.latitude, coord.longitude];    
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:requestPath];
    [request setSession:[PFFacebookUtils session]];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            NSLog(@"Query succeeded with %@", result);
            self.results = [result objectForKey:@"data"];
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
    static NSString *CellIdentifier = @"LocationListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	
     UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
     nameLabel.text = [[results objectAtIndex:indexPath.row] objectForKey:@"name"];
     UILabel *gameLabel = (UILabel *)[cell viewWithTag:101];
     gameLabel.text = [[[results objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"street"];
     
    
     UIImageView * img1 = (UIImageView *) [cell viewWithTag:200];
    [img1 setImageWithURL:[NSURL URLWithString:[[[[results objectAtIndex:indexPath.row] objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]];

    /*
     UIImageView * img2 = (UIImageView *) [cell viewWithTag:101];
     img2.image = [UIImage imageNamed:@"icon.jpeg"];
     UIImageView * img3 = (UIImageView *) [cell viewWithTag:102];
     img3.image = [UIImage imageNamed:@"icon.jpeg"];*/
    
    
    return cell;
}

@end
