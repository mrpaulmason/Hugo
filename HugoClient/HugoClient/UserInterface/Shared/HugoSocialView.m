//
//  HugoSocialView.m
//  HugoClient
//
//  Created by Ryan Waliany on 9/19/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoSocialView.h"

@implementation HugoSocialView
@synthesize expanded;

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
    NSLog(@"button tag %d", [selector tag]);
    UIView *tmp = [[selector superview] viewWithTag:2];
    
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [tmp setFrame:CGRectMake(0, 5, 235, 50)]; //notice this is ON screen!
    button.hidden = YES;
    expanded = YES;
    [UIView commitAnimations];

    
}

- (void)beenThere: (id) sender
{
    NSLog(@"beenThere tab");
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [[sender superview] setFrame:CGRectMake(235, 5, 235, 50)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    UIButton *tmp = (UIButton*)([[[sender superview] superview] viewWithTag:1]);
    UIImage *buttonImageNormal = [UIImage imageNamed:@"assets/newsfeed/been.png"];
    UIImage *buttonImageDown = [UIImage imageNamed:@"assets/newsfeed/beenB.png"];
    [tmp setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [tmp setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    tmp.hidden = NO;
    
}

- (void)hereNow: (id) sender
{
    NSLog(@"hereNow tab");
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [[sender superview] setFrame:CGRectMake(235, 5, 235, 50)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    UIButton *tmp = (UIButton*)([[[sender superview] superview] viewWithTag:1]);
    UIImage *buttonImageNormal = [UIImage imageNamed:@"assets/newsfeed/here.png"];
    UIImage *buttonImageDown = [UIImage imageNamed:@"assets/newsfeed/hereB.png"];
    [tmp setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [tmp setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    tmp.hidden = NO;
    
}

- (void)wanaGo: (id) sender
{
    NSLog(@"wanaGo tab");
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [[sender superview] setFrame:CGRectMake(235, 5, 235, 50)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    UIButton *tmp = (UIButton*)([[[sender superview] superview] viewWithTag:1]);
    UIImage *buttonImageNormal = [UIImage imageNamed:@"assets/newsfeed/go.png"];
    UIImage *buttonImageDown = [UIImage imageNamed:@"assets/newsfeed/goB.png"];
    [tmp setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [tmp setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    tmp.hidden = NO;
    
}

- (void)closeTab: (id) sender
{
    NSLog(@"close tab");
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [[sender superview] setFrame:CGRectMake(235, 5, 235, 50)]; //notice this is ON screen!
    [UIView commitAnimations];

    UIView *tmp = [[[sender superview] superview] viewWithTag:1];
    tmp.hidden = NO;
    expanded = NO;
    
}

- (void)initializeButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"assets/newsfeed/add.png"];
    UIImage *buttonImageDown = [UIImage imageNamed:@"assets/newsfeed/addB.png"];
    [button setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    
    [button addTarget:self
               action:@selector(expandButton:)
     forControlEvents:UIControlEventTouchDown];
    
    button.tag = 1;
    button.frame = CGRectMake(180, 5, 55.0, 50.0);
    [self addSubview:button];
    
    UIImageView *buttonExpanded = [[UIImageView alloc] initWithFrame:CGRectMake(235, 5, 235, 50)];
    [buttonExpanded setImage:[UIImage imageNamed:@"assets/newsfeed/addOptions.png"]];
    [buttonExpanded setTag:2];
    buttonExpanded.userInteractionEnabled = YES;
    [self addSubview:buttonExpanded];
    
    UIButton *buttonBeenThere = [self buttonFromImage:@"assets/newsfeed/optionsBeen.png" withHighlight:@"assets/newsfeed/optionsBeenB.png" selector:@selector(beenThere:) andFrame:CGRectMake(0, 0, 65, 50)];
    [buttonExpanded addSubview:buttonBeenThere];
    
    UIButton *buttonHereNow = [self buttonFromImage:@"assets/newsfeed/optionsHere.png" withHighlight:@"assets/newsfeed/optionsHereB.png" selector:@selector(hereNow:) andFrame:CGRectMake(65, 0, 65, 50)];
    [buttonExpanded addSubview:buttonHereNow];
    
    UIButton *buttonWanaGo = [self buttonFromImage:@"assets/newsfeed/optionsGo.png" withHighlight:@"assets/newsfeed/optionsGoB.png" selector:@selector(wanaGo:) andFrame:CGRectMake(130, 0, 65, 50)];
    [buttonExpanded addSubview:buttonWanaGo];
    
    UIButton *buttonClose = [self buttonFromImage:@"assets/newsfeed/optionsClose.png" withHighlight:@"assets/newsfeed/optionsCloseB.png" selector:@selector(closeTab:) andFrame:CGRectMake(195, 0, 40, 50)];
    [buttonExpanded addSubview:buttonClose];

    UIImageView *corner = [[UIImageView alloc] initWithFrame:CGRectMake(230, 0, 5, 55)];
    [corner setImage:[UIImage imageNamed:@"assets/newsfeed/corner.png"]];
    [self addSubview:corner];

}

@end
