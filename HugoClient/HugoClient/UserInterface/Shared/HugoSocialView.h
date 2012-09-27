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
    NSMutableArray *statuses;
    NSString *placeId;
}

- (id)initWithFrame:(CGRect)frame andStatuses:(NSArray*)aStatuses andPlace:(NSString*)place;

@property (atomic) BOOL expanded;
@property (nonatomic, retain) NSMutableArray *statuses;
@property (nonatomic, retain) UIImageView *expandedBar;
@property (nonatomic, retain) UIButton *closedBar;
@property (nonatomic, retain) NSString *placeId;

@end
