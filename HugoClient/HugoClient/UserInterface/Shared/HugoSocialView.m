//
//  HugoSocialView.m
//  HugoClient
//
//  Created by Ryan Waliany on 9/19/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoSocialView.h"

@implementation HugoSocialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        [self initializeButtons];

    }
    return self;
}



- (void)expandButton: (id) selector
{
    NSLog(@"button tag %d", [selector tag]);
    UIView *tmp = [[selector superview] viewWithTag:2];
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [tmp setFrame:CGRectMake(0, 5, 236, 56)]; //notice this is ON screen!
    [UIView commitAnimations];
    
}

- (void)initializeButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"assets/newsfeed/here.png"];
    UIImage *buttonImageDown = [UIImage imageNamed:@"assets/newsfeed/hereB.png"];
    [button setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    
    [button addTarget:self
               action:@selector(expandButton:)
     forControlEvents:UIControlEventTouchDown];
    
    button.tag = 1;
    button.frame = CGRectMake(180, 5, 56.0, 51.0);
    [self addSubview:button];
    
    UIImageView *buttonExpanded = [[UIImageView alloc] initWithFrame:CGRectMake(236, 5, 236, 56)];
    [buttonExpanded setImage:[UIImage imageNamed:@"assets/newsfeed/addOptions.png"]];
    [buttonExpanded setTag:2];
    [self addSubview:buttonExpanded];
}

@end
