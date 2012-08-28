//
//  HugoNavigationBar.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoNavigationBar.h"

@implementation HugoNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = CGSizeMake(self.frame.size.width,40);
    return newSize;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage *image = [UIImage imageNamed:@"hugo.png"];
    [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
}


@end
