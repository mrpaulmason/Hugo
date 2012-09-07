//
//  HugoLoginViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/28/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoLoginViewController.h"
#import "HugoUtils.h"
#import <Parse/Parse.h> 

@interface HugoLoginViewController ()

@end

@implementation HugoLoginViewController

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

#pragma mark Buttons
- (IBAction)loginButtonTouchHandler:(id)sender
{
    // The permissions requested from the user
    NSArray *permissionsArray = [NSArray arrayWithObjects:
                                 @"user_about_me", @"friends_about_me", @"friends_hometown", @"user_hometown",
                                 @"user_relationships",@"user_birthday",@"user_location", @"friends_location", @"email", @"publish_checkins", @"offline_access", @"friends_status", @"user_status", @"user_photos", @"friends_photos", nil];
    
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

                                            [HugoUtils HAuthRequest:[[PFFacebookUtils session] accessToken] andExpiration:[[PFFacebookUtils session] expirationDate]];

                                            [self performSegueWithIdentifier:@"UserLoginSuccess" sender:self];
                                        } else { // Success - an existing user logged in
                                            NSLog(@"User with facebook logged in!");

                                            [HugoUtils HAuthRequest:[[PFFacebookUtils session] accessToken] andExpiration:[[PFFacebookUtils session] expirationDate]];
                                            
                                            [self performSegueWithIdentifier:@"UserLoginSuccess" sender:self];
                                        }
                                    }];
}

@end
