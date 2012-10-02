//
//  HugoSpotViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 10/1/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoSpotViewController : UIViewController <UITextViewDelegate>
{
    UIScrollView *scrollView;
    NSMutableDictionary *spotData;
    int _offset;
}

@property (nonatomic, retain) NSString *placeId;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *spotData;
@end
