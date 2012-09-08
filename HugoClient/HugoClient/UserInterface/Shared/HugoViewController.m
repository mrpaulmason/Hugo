//
//  HugoViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "HugoViewController.h"

@interface HugoViewController ()

@end

@implementation HugoViewController

- (void)viewDidLoad
{
            
    UIImage *selectedImage0 = [UIImage imageNamed:@"assets/generic/menu/homeB.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"assets/generic/menu/homeA.png"];
    
    UIImage *selectedImage1 = [UIImage imageNamed:@"assets/generic/menu/searchB.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"assets/generic/menu/searchA.png"];
    
    UIImage *selectedImage2 = [UIImage imageNamed:@"assets/generic/menu/locationB.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"assets/generic/menu/locationA.png"];
    
    UIImage *selectedImage3 = [UIImage imageNamed:@"assets/generic/menu/profileB.png"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"assets/generic/menu/profileA.png"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;

    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    
    
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];

    tabBar.frame = CGRectMake(tabBar.frame.origin.x,tabBar.frame.origin.y,tabBar.frame.size.width,58);

    id appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate startStandardUpdates];
    
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
