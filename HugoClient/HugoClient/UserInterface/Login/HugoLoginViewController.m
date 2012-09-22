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
@synthesize button;

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
    NSLog(@"%@", button);
    [button addTarget:self
               action:@selector(facebookConnect:)
     forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults valueForKey:@"fb_expires"] == nil)
    {
        NSLog(@"New FB Auth");
        // no data exists
    }
    else if ([defaults doubleForKey:@"fb_expires"] > [[NSDate date] timeIntervalSince1970]) // Check if user is linked to Facebook and their session hasn't expired
    {
        NSLog(@"Valid FB Auth");
        [self performSegueWithIdentifier:@"UserLoginSuccess" sender:self];
    }
    else if ([defaults doubleForKey:@"fb_expires"] < [[NSDate date] timeIntervalSince1970])
    {
        NSLog(@"Expired FB Auth");
        [self facebookConnect:self];
    }

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
- (IBAction)facebookConnect:(id)sender;
{
    // The permissions requested from the user
    NSArray *permissionsArray = [NSArray arrayWithObjects:
                                 @"user_about_me", @"friends_about_me", @"friends_hometown", @"user_hometown",
                                 @"user_relationships",@"user_birthday",@"user_location", @"friends_location", @"email", @"publish_checkins", @"offline_access", @"friends_status", @"user_status", @"user_photos", @"friends_photos", nil];
    
    NSLog(@"Facebook connect started");
    
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
