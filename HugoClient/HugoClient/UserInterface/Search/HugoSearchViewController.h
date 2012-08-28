//
//  HugoSearchTableViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoSearchViewController : UIViewController
{
    NSMutableArray *categories;
}

@property (nonatomic, strong) NSMutableArray *categories;

@end
