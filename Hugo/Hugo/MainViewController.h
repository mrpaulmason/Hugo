//
//  MainViewController.h
//  Hugo
//
//  Created by Ryan Waliany on 8/6/12.
//  Copyright (c) 2012 Hugo. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>
#import <Parse/Parse.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, PF_FBRequestDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)showInfo:(id)sender;

@end
