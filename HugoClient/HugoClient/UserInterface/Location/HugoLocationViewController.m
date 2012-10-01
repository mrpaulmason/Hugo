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
#import "SBJson.h"

@interface HugoLocationViewController ()

@end

@implementation HugoLocationViewController
@synthesize results, tableView, searchResults, desiredLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)refresh
{
    NSString *requestPath = [NSString stringWithFormat:@"search?q=*&type=place&center=%f,%f&distance=1000&fields=location,picture,name", desiredLocation.coordinate.latitude, desiredLocation.coordinate.longitude];
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

}

- (void)viewDidLoad
{

    NSMutableArray *tmp = [NSMutableArray array];
    [tmp insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Current Location", @"formatted_address", nil] atIndex:0];
    self.searchResults = tmp;

    if (desiredLocation  == nil)
    {
        id appDelegate = [[UIApplication sharedApplication] delegate];
        desiredLocation = [appDelegate lastLocation];
        currentText = @"Current Location";
    }
    
    [self updateSearchColor];
    
    for (UIView *searchBarSubview in [self.searchDisplayController.searchBar subviews]) {
        
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            
            @try {
                
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
                [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
            }
            @catch (NSException * e) {
                
                // ignore exception
            }
        }
    }
    
    [self refresh];
    
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

- (NSInteger)tableView:(UITableView *)sTableView numberOfRowsInSection:(NSInteger)section
{
    if (sTableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [results count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)sTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if (sTableView == self.searchDisplayController.searchResultsTableView) {
        static NSString *CellIdentifier = @"LocationCell";
        cell = [sTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"];
        
        if ([cell.textLabel.text isEqualToString:@"Current Location"])
            cell.textLabel.textColor = [UIColor blueColor];
        
    } else {
        static NSString *CellIdentifier = @"LocationListCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
        nameLabel.text = [[results objectAtIndex:indexPath.row] objectForKey:@"name"];
        UILabel *gameLabel = (UILabel *)[cell viewWithTag:101];
        gameLabel.text = [[[results objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"street"];
        
        
        UIImageView * img1 = (UIImageView *) [cell viewWithTag:200];
        [img1 setImageWithURL:[NSURL URLWithString:[[[[results objectAtIndex:indexPath.row] objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]];
    }    
    
    return cell;
}

#pragma mark - Google Geocoding API

- (void) searchCoordinatesForAddress:(NSString *)inAddress
{
    //Build the string to Query Google Maps.
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",inAddress];
    
    //Replace Spaces with a '+' character.
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    //Create NSURL string from a formate URL string.
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Setup and start an async download.
    //Note that we should test for reachability!.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //The string received from google's servers
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    //JSON Framework magic to obtain a dictionary from the jsonString.
    NSDictionary *results = [parser objectWithString:jsonString];
    
    //Now we need to obtain our coordinate
    
    NSMutableArray *placemark  = [[results objectForKey:@"results"] mutableCopy];
    
    if (placemark == nil)
    {
        placemark = [NSMutableArray array];
    }
    
    [placemark insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Current Location", @"formatted_address", nil] atIndex:0];
    
    self.searchResults = placemark;
    
    //    NSLog(@"%@", jsonString);
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    //    NSArray *coordinates = [[placemark objectAtIndex:0] valueForKeyPath:@"Point.coordinates"];
    
    //I put my coordinates in my array.
    //    double longitude = [[coordinates objectAtIndex:0] doubleValue];
    //  double latitude = [[coordinates objectAtIndex:1] doubleValue];
    
    //Debug.
    //NSLog(@"Latitude - Longitude: %f %f", latitude, longitude);
    
    //I zoom my map to the area in question.
}

#pragma mark - Search

- (void)updateSearchColor
{
    if (self.searchDisplayController.isActive){
        if ([self.searchDisplayController.searchBar.text isEqualToString:@"Current Location"])
        {
            UITextField *searchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
            searchField.textColor = [UIColor blueColor]; //You can put any color here.
        }
        else
        {
            UITextField *searchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
            searchField.textColor = [UIColor blackColor]; //You can put any color here.
        }
    }
    else
    {
        if ([currentText isEqualToString:@"Current Location"])
        {
            UITextField *searchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
            searchField.textColor = [UIColor blueColor]; //You can put any color here.
        }
        else
        {
            UITextField *searchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
            searchField.textColor = [UIColor blackColor]; //You can put any color here.
        }
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    [self.searchDisplayController setActive:NO animated:YES];
    self.searchDisplayController.searchBar.text = currentText;
    
    [self updateSearchColor];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:NO animated:YES];
    self.searchDisplayController.searchBar.text = currentText;
    [self updateSearchColor];
    
}



- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView:(UITableView *)_tableView
{
    NSLog(@"did load search display controller");
    [self.searchDisplayController setActive:YES animated:YES];
    self.searchDisplayController.searchBar.text = currentText;
    self.searchDisplayController.searchBar.placeholder = @"Search or Address";
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self searchCoordinatesForAddress:searchText];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    if(!controller.isActive){
        controller.searchResultsTableView.hidden = YES;
        return NO;
    }
    
    controller.searchResultsTableView.hidden = NO;
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    [self updateSearchColor];
    
    return YES;
}

#pragma mark - Table Select
- (void)tableView:(UITableView *)sTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if (sTableView == self.searchDisplayController.searchResultsTableView) {
        [self.searchDisplayController setActive:NO animated:YES];
        self.searchDisplayController.searchBar.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"];
        
        currentText = self.searchDisplayController.searchBar.text;
        
        
        @try {
            NSDictionary *latlng = [[[searchResults objectAtIndex:indexPath.row] objectForKey:@"geometry"] objectForKey:@"location"];
            NSLog(@"%@", latlng);
            if ([[[searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"] isEqualToString:@"Current Location"])
            {
                id appDelegate = [[UIApplication sharedApplication] delegate];
                self.desiredLocation = [appDelegate lastLocation];
            }
            else
            {
                CLLocation *cl = [[CLLocation alloc] initWithLatitude:[[latlng objectForKey:@"lat"] doubleValue] longitude:[[latlng objectForKey:@"lng"] doubleValue]];
                self.desiredLocation = cl;
            }
            NSLog(@"desired location updated %@", desiredLocation);
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
            id appDelegate = [[UIApplication sharedApplication] delegate];
            self.desiredLocation = [appDelegate lastLocation];
            currentText = @"Current Location";
            NSLog(@"desired location updated [exception] %@", desiredLocation);
        }
        @finally {
            [self refresh];
            [self updateSearchColor];
        }
        
    } else {
//        [self performSegueWithIdentifier:@"HResults" sender:[categories objectAtIndex:indexPath.row]];
    }
    
}


@end
