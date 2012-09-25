//
//  HugoSocialView.h
//  HugoClient
//
//  Created by Ryan Waliany on 9/19/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoSocialView : UIView
{
    BOOL expanded;
    UIImageView *expandedBar;
    UIButton *closedBar;
}

@property (atomic) BOOL expanded;
@property (nonatomic, retain) UIImageView *expandedBar;
@property (nonatomic, retain) UIButton *closedBar;

@end
