//
//  HugoCommentsViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 9/23/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HugoCommentsView.h"

@interface HugoCommentsViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIImageView *profilePicture;
    UITableViewCell *spottingDetails;
    UIScrollView *scrollView;
    UIToolbar *toolbar;
    UITextField *textInput;
    UIBarButtonItem *barButtonItem;
    UIBarButtonItem *doneButtonItem;
    NSMutableDictionary *spotData;
    HugoCommentsView *commentsView;
    BOOL keyboardIsShown;
}

- (IBAction)comment:(id)sender;
- (IBAction)closeModal:(id)sender;

@property (nonatomic, retain) NSMutableDictionary *spotData;
@property (nonatomic, retain) HugoCommentsView *commentsView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonItem;
@property (nonatomic, retain) IBOutlet UITextField *textInput;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *profilePicture;
@property (nonatomic, retain) IBOutlet UITableViewCell *spottingDetails;

#define kTabBarHeight 44
#define kKeyboardAnimationDuration 0.25


@end
