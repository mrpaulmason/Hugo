//
//  HugoSpottingViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 9/20/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoSpottingViewController : UIViewController
{
    UIImageView *profilePicture;
    UITableViewCell *spottingDetails;
    NSArray *comments;
    UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UIImageView *profilePicture;
@property (nonatomic, retain) IBOutlet UITableViewCell *spottingDetails;
@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
