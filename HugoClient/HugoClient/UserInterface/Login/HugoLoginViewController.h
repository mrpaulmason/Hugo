//
//  HugoLoginViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/28/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoLoginViewController : UIViewController
{
    UIButton *button;
}

@property (nonatomic, retain) IBOutlet UIButton *button;
- (IBAction)helloWorld;
- (IBAction)facebookConnect:(id)sender;

@end
