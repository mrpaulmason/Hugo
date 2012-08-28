//
//  HugoViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoViewController.h"

@interface HugoViewController ()

@end

@implementation HugoViewController

- (void)viewDidLoad
{
            
    UIImage *selectedImage0 = [UIImage imageNamed:@"homeB.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"homeA.png"];
    
    UIImage *selectedImage1 = [UIImage imageNamed:@"searchB.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"searchA.png"];
    
    UIImage *selectedImage2 = [UIImage imageNamed:@"locationB.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"locationA.png"];
    
    UIImage *selectedImage3 = [UIImage imageNamed:@"profileB.png"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"profileA.png"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;

    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
