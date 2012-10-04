//
//  HugoVenueViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 9/24/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoVenueViewController : UIViewController <UIGestureRecognizerDelegate>
{
    UIScrollView *scrollView;
    NSMutableDictionary *spotData;
    NSDictionary *result;
    int _offset;
}

@property (nonatomic, retain) NSDictionary *result;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *spotData;

@end
