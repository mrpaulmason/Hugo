//
//  HugoCommentsView.h
//  HugoClient
//
//  Created by Ryan Waliany on 9/23/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoCommentsView : UIView
{
    NSMutableArray *_comments;
    int _padding;
    int _width;
    int _offset;
}

- (id)initWithComments:(NSArray*)comments andPadding:(int)padding andWidth:(int)width;
- (void)addComment:(NSString*)text;

@property(nonatomic, retain) NSMutableArray *_comments;

@end