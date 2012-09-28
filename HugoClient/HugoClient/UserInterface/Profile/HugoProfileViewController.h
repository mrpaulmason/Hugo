//
//  HugoProfileViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 9/18/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoProfileViewController : UIViewController
{
    NSArray *results;
    UITableView *tableView;
    UIImageView *profile;
    UIView *header;
    NSString *profileId;
    NSString *source;
}

@property (nonatomic, retain) NSString *profileId;
@property (nonatomic, retain) NSString *source;

@property (nonatomic, retain) IBOutlet UIImageView *profile;
@property (nonatomic, retain) IBOutlet UIView *header;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
