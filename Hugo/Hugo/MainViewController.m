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
