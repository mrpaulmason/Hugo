//
//  HugoLocationViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/28/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HugoLocationViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate>
{
    NSArray *results;
    UITableView *tableView;
    NSString *currentText;
    CLLocation *desiredLocation;
    NSArray *searchResults;
}

@property (nonatomic, retain) CLLocation *desiredLocation;

@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray* searchResults;


@end
