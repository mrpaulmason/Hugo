//
//  HugoNewsfeedViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface HugoNewsfeedViewController : PullRefreshTableViewController <UINavigationControllerDelegate> 
{
    UITableView *tableView;
    NSMutableArray *results;
}

@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
