//
//  HugoResultsListViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoResultsListViewController : UIViewController
{
    NSArray *results;
    UITableView *tableView;
}

@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
