//
//  HugoSearchTableViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import <MapKit/MapKit.h>

@interface HugoSearchViewController : PullRefreshTableViewController
{
    NSMutableArray *categories;
    NSArray *searchResults;
    UITableView *tableView;
    CLLocation *desiredLocation;
    NSString *currentText;
}

@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) CLLocation *desiredLocation;
@property (nonatomic, retain) NSArray* searchResults;


@end
