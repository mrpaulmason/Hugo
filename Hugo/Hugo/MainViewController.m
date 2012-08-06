//
//  MainViewController.m
//  Hugo
//
//  Created by Ryan Waliany on 8/6/12.
//  Copyright (c) 2012 Hugo. All rights reserved.
//

#import "MainViewController.h"
#import <Parse/Parse.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Facebook Authentication
- (IBAction)loginButtonTouchHandler:(id)sender
{
    // The permissions requested from the user
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"user_about_me",
                                 @"user_relationships",@"user_birthday",@"user_location",
                                 @"offline_access", nil];
    
    // Log in
    [PFFacebookUtils logInWithPermissions:permissionsArray
                                    block:^(PFUser *user, NSError *error) {
                                        if (!user) {
                                            if (!error) { // The user cancelled the login
                                                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                                            } else { // An error occurred
                                                NSLog(@"Uh oh. An error occurred: %@", error);
                                            }
                                        } else if (user.isNew) { // Success - a new user was created
                                            
                                            NSLog(@"User with facebook signed up and logged in!");
                                            NSString *requestPath = @"me/?fields=name,location,gender,birthday,relationship_status,picture";
                                            
                                            // Send request to facebook
                                            [[PFFacebookUtils facebook] requestWithGraphPath:requestPath
                                                                                 andDelegate:self];
                                        } else { // Success - an existing user logged in
                                            NSLog(@"User with facebook logged in!");
                                            NSString *requestPath = @"me/?fields=name,location,gender,birthday,relationship_status,picture";
                                            
                                            // Send request to facebook
                                            [[PFFacebookUtils facebook] requestWithGraphPath:requestPath
                                                                                 andDelegate:self];
                                        }
                                    }];
}

-(void)request:(PF_FBRequest *)request didLoad:(id)result {
    NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
    
    NSString *name = [userData objectForKey:@"name"];
    NSString *location = [[userData objectForKey:@"location"] objectForKey:@"name"];
    NSString *gender = [userData objectForKey:@"gender"];
    NSString *birthday = [userData objectForKey:@"birthday"];
    NSString *relationship = [userData objectForKey:@"relationship_status"];
    
    // Now add the data to the UI elements
    
    NSLog(@"%@ %@ %@ %@ %@", name ,location, gender, birthday, relationship);
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)dealloc
{
    [_managedObjectContext release];
    [_flipsidePopoverController release];
    [super dealloc];
}

- (IBAction)showInfo:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        FlipsideViewController *controller = [[[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil] autorelease];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
    } else {
        if (!self.flipsidePopoverController) {
            FlipsideViewController *controller = [[[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil] autorelease];
            controller.delegate = self;
            
            self.flipsidePopoverController = [[[UIPopoverController alloc] initWithContentViewController:controller] autorelease];
        }
        if ([self.flipsidePopoverController isPopoverVisible]) {
            [self.flipsidePopoverController dismissPopoverAnimated:YES];
        } else {
            [self.flipsidePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

@end
