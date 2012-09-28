//
//  HugoSearchTableViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoSearchViewController.h"
#import "HQuery.h"
#import "AppDelegate.h"
#import "HugoResultsListViewController.h"
#import "SBJson.h"

@interface HugoSearchViewController ()

@end

@implementation HugoSearchViewController

@synthesize categories, tableView, desiredLocation, searchResults;

- (void)viewDidLoad
{
//    [self startLoading];

    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Categories"];
    
    NSMutableArray *tmp = [NSMutableArray array];
    [tmp insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Current Location", @"formatted_address", nil] atIndex:0];
    self.searchResults = tmp;

    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)refresh
{
    NSLog(@"desired location before refresh %@", desiredLocation);

    if (desiredLocation  == nil)
    {
        id appDelegate = [[UIApplication sharedApplication] delegate];
        desiredLocation = [appDelegate lastLocation];
        currentText = @"Current Location";
    }

    [self updateSearchColor];
    
    NSLog(@"desired location after refresh %@", desiredLocation);


    HQuery *hQuery = [[HQuery alloc] init];
    [hQuery queryCategories:[desiredLocation coordinate] withCallback:^(id JSON, NSError *error) {
        if (error == nil)
        {
            NSLog(@"Received results!");
            
            self.categories = JSON;
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


- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView:(UITableView *)tableView
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
        return [categories count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)sTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell = [sTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }

    if (sTableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"];
        
        if ([cell.textLabel.text isEqualToString:@"Current Location"])
            cell.textLabel.textColor = [UIColor blueColor];

    } else {
        cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}


#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HugoResultsListViewController *vc = [segue destinationViewController];
    [vc setCategoryFilter:sender];
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
    
    if (sTableView == self.searchDisplayController.searchResultsTableView) {
        [self.searchDisplayController setActive:NO animated:YES];
        self.searchDisplayController.searchBar.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"];
        
        currentText = self.searchDisplayController.searchBar.text;
        
        NSLog(@"why is nothing happening?");
        
        @try {
            NSDictionary *latlng = [[[searchResults objectAtIndex:indexPath.row] objectForKey:@"geometry"] objectForKey:@"location"];
            NSLog(@"%@", latlng);
            CLLocation *cl = [[CLLocation alloc] initWithLatitude:[[latlng objectForKey:@"lat"] doubleValue] longitude:[[latlng objectForKey:@"lng"] doubleValue]];
            self.desiredLocation = cl;
            NSLog(@"desired location updated %@", desiredLocation);
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
            id appDelegate = [[UIApplication sharedApplication] delegate];
            self.desiredLocation = [appDelegate lastLocation];
            NSLog(@"desired location updated [exception] %@", desiredLocation);
        }
        @finally {
            [self refresh];
        }
        
    } else {
        [self performSegueWithIdentifier:@"HResults" sender:[categories objectAtIndex:indexPath.row]];
    }
    
}

@end
