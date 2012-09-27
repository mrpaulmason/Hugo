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
    UIScrollView *scrollView;
    NSMutableDictionary *spotData;
    int _offset;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *spotData;

@end
