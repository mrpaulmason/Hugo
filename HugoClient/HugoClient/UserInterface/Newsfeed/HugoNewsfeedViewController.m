//
//  HugoNewsfeedViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoNewsfeedViewController.h"
#import "HQuery.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"

@interface HugoNewsfeedViewController ()

@end

@implementation HugoNewsfeedViewController

@synthesize results, tableView;

- (void)viewDidLoad
{
    UIImage *selectedImage0 = [UIImage imageNamed:@"assets/generic/menu/homeB.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"assets/generic/menu/homeA.png"];
    
    UIImage *selectedImage1 = [UIImage imageNamed:@"assets/generic/menu/searchB.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"assets/generic/menu/searchA.png"];
    
    UIImage *selectedImage2 = [UIImage imageNamed:@"assets/generic/menu/locationB.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"assets/generic/menu/locationA.png"];
    
    UIImage *selectedImage3 = [UIImage imageNamed:@"assets/generic/menu/profileB.png"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"assets/generic/menu/profileA.png"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    
    
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    
    tabBar.frame = CGRectMake(tabBar.frame.origin.x,tabBar.frame.origin.y,tabBar.frame.size.width,58);
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate startStandardUpdates];
    
    
    NSLog(@"Ran viewDidLoad");
    
    [tableView setBackgroundColor:[UIColor colorWithWhite:0.89f alpha:1.0f]];
    
    [super viewDidLoad];
        
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)refresh
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    
    HQuery *hQuery = [[HQuery alloc] init];
    [hQuery queryNewsfeed:^(id JSON, NSError *error) {
        if (error == nil)
        {
            NSLog(@"Received results!");
            
            self.results = JSON;
            NSLog(@"%@", results);
            [tableView reloadData];
        }
        [self stopLoading];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (NSInteger)tableView:(UITableView *)sTableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", [results count]);
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)sTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
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

    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 70.f+scale*photo_height, 300.0f, 25.f)];
    bottomBar.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    [view addSubview:bottomBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70.0f,11.f,200.0f,13.f)];
    NSString *name = [[results objectAtIndex:indexPath.row] objectForKey:@"author_name"];
    NSArray *names = [name componentsSeparatedByString:@" "];
    [label setText:[names objectAtIndex:0]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
    [label setTextColor:[UIColor colorWithWhite:0.2f alpha:1.0]];
    [label sizeToFit];
    [view addSubview:label];
    

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(70.0f+[label frame].size.width,11.f,200.0f,13.f)];
    [label2 setText:@" has been to"];
    [label2 setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [label2 setTextColor:[UIColor colorWithWhite:0.53f alpha:1.0]];
    [label2 sizeToFit];
    [view addSubview:label2];

    UILabel *labelVenue = [[UILabel alloc] initWithFrame:CGRectMake(70.0f,30.f,200.0f,13.f)];
    [labelVenue setText:[[results objectAtIndex:indexPath.row] objectForKey:@"spot_name"]];
    [labelVenue setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
    [labelVenue setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0]];
    [labelVenue sizeToFit];
    [view addSubview:labelVenue];

    UILabel *labelStreet = [[UILabel alloc] initWithFrame:CGRectMake(70.0f,49.f,200.0f,13.f)];
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
    UILabel *milesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f,75.f+scale*photo_height,200.0f,25.f)];
    [milesLabel setText:[NSString stringWithFormat:@"%0.1f miles",miles]];
    [milesLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.f]];
    [milesLabel setTextColor:[UIColor colorWithWhite:0.53f alpha:1.0]];
    [milesLabel setBackgroundColor:[UIColor clearColor]];
    [milesLabel sizeToFit];
    [view addSubview:milesLabel];
    
    
    
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 10.f, 50.f, 50.f)];
    img.layer.cornerRadius = 5.0;
    img.layer.masksToBounds = YES;
    [img setImageWithURL:[NSURL URLWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"author_image"]]];
    [view addSubview:img];
    
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

    
                        
    /*
     
#     box-shadow: x: -1px y: 0px, blur: 3px #555
     
     
     
     gray footer-y area: 50px tall HD, border: 1px #d7d7d7
     
     
     
     Font for everything: helvetica neue (it's what the new google stock display uses)
     
     
     
     profile icon: 100px x 100px HD, 20px padding (50px, 10px padding SD)
     
     name: 13px bold #333
     
     want to go to: 13px normal #888
     
     venue: 13px bold #555
     
     category: 9px normal #555 uppercase
     
     address: 11px normal #999
     
     timestamp/distancestamp: 10px normal #888
     
*/
    
    
//    cell.textLabel.text = [[results objectAtIndex:indexPath.row] objectForKey:@"spot_name"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float sz = 105;
    
    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"photo"])
    {
        int photo_height = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_height"] integerValue];
        int photo_width = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_width"] integerValue];
        float scale = 320.0f/photo_width;
        
        sz += scale*photo_height;        
    }

    
    return sz;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)sTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
        
}

@end
