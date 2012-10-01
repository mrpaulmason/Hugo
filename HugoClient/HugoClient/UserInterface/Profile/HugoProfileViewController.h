//
//  HugoProfileViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 9/18/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HugoProfileViewController : UIViewController
{
    NSArray *results;
    UITableView *tableView;
    UIImageView *profile;
    UIView *header;
    NSString *profileId;
    NSString *hugoId;
    NSString *source;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *labelFriends;
    PF_FBFriendPickerViewController *friendPicker;
    
}

@property (strong, nonatomic) PF_FBFriendPickerViewController *friendPickerController;

@property (nonatomic, retain) NSString *profileId;
@property (nonatomic, retain) NSString *hugoId;
@property (nonatomic, retain) NSString *source;

@property (nonatomic, retain) IBOutlet UIImageView *profile;
@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UILabel *label3;
@property (nonatomic, retain) IBOutlet UILabel *labelFriends;

@property (nonatomic, retain) IBOutlet UIView *header;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
