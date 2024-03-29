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
    CGSize newSize = CGSizeMake(self.frame.size.width,45);
    return newSize;
}

- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated
{
    [self setNeedsDisplay];
    return [super popNavigationItemAnimated:animated];
}

- (void)pushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated
{
    [super pushNavigationItem:item animated:animated];
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage *image = [UIImage imageNamed:@"assets/generic/header.png"];
    [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];

    if ([[[self topItem] title] length] == 0)
    {
        UIImage *imageLogo = [UIImage imageNamed:@"assets/generic/logo.png"];
        [imageLogo drawInRect:CGRectMake(128, 7, imageLogo.size.width, imageLogo.size.height)];
        NSLog(@"not sure what is happening");
    }

}


@end
