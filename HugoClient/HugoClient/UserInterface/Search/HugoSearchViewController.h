//
//  HugoSearchTableViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface HugoSearchViewController : PullRefreshTableViewController
{
    NSMutableArray *categories;
    UITableView *tableView;
}

@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
