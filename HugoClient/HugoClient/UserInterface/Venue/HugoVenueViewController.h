//
//  HugoVenueViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 9/24/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoVenueViewController : UIViewController
{
    UILabel *lbl1, *lbl2;
    UITableViewCell *cellHeader;
}

@property (nonatomic, retain) IBOutlet UILabel *lbl1, *lbl2;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellHeader;

@end
