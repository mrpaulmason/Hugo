//
//  HugoCommentsViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 9/23/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoCommentsViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIImageView *profilePicture;
    UITableViewCell *spottingDetails;
    NSArray *comments;
    UIScrollView *scrollView;
    UIToolbar *toolbar;
    UITextField *textInput;
    BOOL keyboardIsShown;

}

@property (nonatomic, retain) IBOutlet UITextField *textInput;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *profilePicture;
@property (nonatomic, retain) IBOutlet UITableViewCell *spottingDetails;
@property (nonatomic, retain) NSArray *comments;

#define kTabBarHeight 44
#define kKeyboardAnimationDuration 0.25


@end
