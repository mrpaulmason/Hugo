//
//  HugoSocialView.m
//  HugoClient
//
//  Created by Ryan Waliany on 9/19/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoSocialView.h"

@implementation HugoSocialView
@synthesize expanded, closedBar, expandedBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        [self initializeButtons];
        expanded = NO;

    }
    return self;
}

- (UIButton*) buttonFromImage:(NSString*)imgA withHighlight:(NSString*)imgB selector:(SEL) sel andFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    UIImage *buttonImageNormal = [UIImage imageNamed:imgA];
    UIImage *buttonImageDown = [UIImage imageNamed:imgB];
    [button setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    
    [button addTarget:self
                        action:sel
              forControlEvents:UIControlEventTouchDown];
    
    button.frame = frame;
    return button;    
}


- (void)expandButton: (id) selector
{
    UIButton *button = (UIButton*)selector;    
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [self.expandedBar setFrame:CGRectMake(0, 5, 235, 50)]; //notice this is ON screen!
    button.hidden = YES;
    expanded = YES;
    [UIView commitAnimations];

    
}

- (void)beenThere: (id) sender
{
    NSLog(@"beenThere tab");
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [self.expandedBar setFrame:CGRectMake(235, 5, 235, 50)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"assets/newsfeed/been.png"];
    UIImage *buttonImageDown = [UIImage imageNamed:@"assets/newsfeed/beenB.png"];
    [self.closedBar setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [self.closedBar setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    self.closedBar.hidden = NO;
    
}

- (void)hereNow: (id) sender
{
    NSLog(@"hereNow tab");
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [self.expandedBar setFrame:CGRectMake(235, 5, 235, 50)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"assets/newsfeed/here.png"];
    UIImage *buttonImageDown = [UIImage imageNamed:@"assets/newsfeed/hereB.png"];
    [self.closedBar setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [self.closedBar setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    self.closedBar.hidden = NO;
    expanded = NO;
    
}

- (void)wanaGo: (id) sender
{
    NSLog(@"wanaGo tab");
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [self.expandedBar setFrame:CGRectMake(235, 5, 235, 50)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"assets/newsfeed/go.png"];
    UIImage *buttonImageDown = [UIImage imageNamed:@"assets/newsfeed/goB.png"];
    [self.closedBar setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [self.closedBar setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    self.closedBar.hidden = NO;
    expanded = NO;
    
}

- (void)closeTab: (id) sender
{
    NSLog(@"close tab");
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [self.expandedBar setFrame:CGRectMake(235, 5, 235, 50)]; //notice this is ON screen!
    [UIView commitAnimations];

    self.closedBar.hidden = NO;
    expanded = NO;
    
}

- (void)initializeButtons
{
    self.closedBar = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closedBar.backgroundColor = [UIColor clearColor];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"assets/newsfeed/add.png"];
    UIImage *buttonImageDown = [UIImage imageNamed:@"assets/newsfeed/addB.png"];
    [self.closedBar setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [self.closedBar setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    
    [self.closedBar addTarget:self
               action:@selector(expandButton:)
     forControlEvents:UIControlEventTouchDown];
    
    self.closedBar.tag = 1;
    self.closedBar.frame = CGRectMake(180, 5, 55.0, 50.0);
    [self addSubview:self.closedBar];
    
    self.expandedBar = [[UIImageView alloc] initWithFrame:CGRectMake(235, 5, 235, 50)];
    [self.expandedBar setImage:[UIImage imageNamed:@"assets/newsfeed/addOptions.png"]];
    [self.expandedBar setTag:2];
    self.expandedBar.userInteractionEnabled = YES;
    [self addSubview:self.expandedBar];
    
    UIButton *buttonBeenThere = [self buttonFromImage:@"assets/newsfeed/optionsBeen.png" withHighlight:@"assets/newsfeed/optionsBeenB.png" selector:@selector(beenThere:) andFrame:CGRectMake(0, 0, 65, 50)];
    [self.expandedBar addSubview:buttonBeenThere];
    
    UIButton *buttonHereNow = [self buttonFromImage:@"assets/newsfeed/optionsHere.png" withHighlight:@"assets/newsfeed/optionsHereB.png" selector:@selector(hereNow:) andFrame:CGRectMake(65, 0, 65, 50)];
    [self.expandedBar addSubview:buttonHereNow];
    
    UIButton *buttonWanaGo = [self buttonFromImage:@"assets/newsfeed/optionsGo.png" withHighlight:@"assets/newsfeed/optionsGoB.png" selector:@selector(wanaGo:) andFrame:CGRectMake(130, 0, 65, 50)];
    [self.expandedBar addSubview:buttonWanaGo];
    
    UIButton *buttonClose = [self buttonFromImage:@"assets/newsfeed/optionsClose.png" withHighlight:@"assets/newsfeed/optionsCloseB.png" selector:@selector(closeTab:) andFrame:CGRectMake(195, 0, 40, 50)];
    [self.expandedBar addSubview:buttonClose];

    UIImageView *corner = [[UIImageView alloc] initWithFrame:CGRectMake(230, 0, 5, 55)];
    [corner setImage:[UIImage imageNamed:@"assets/newsfeed/corner.png"]];
    [self addSubview:corner];

}

@end
