//
//  HugoCommentsViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 9/23/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoCommentsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface HugoCommentsViewController ()

@end

@implementation HugoCommentsViewController
@synthesize comments, profilePicture, spottingDetails, scrollView, toolbar, textInput;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    profilePicture.layer.cornerRadius = 5.0f;
    profilePicture.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    profilePicture.layer.masksToBounds = YES;
    profilePicture.layer.borderWidth = 0.5f;
    
    spottingDetails.layer.cornerRadius = 5.0f;
    spottingDetails.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    spottingDetails.layer.borderWidth = 0.5f;
    
    scrollView.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0];
    
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"comment", @"type", @"Lot's of seating w/ outlets and great music!! This should now support multiline text!!!! This should now support multiline text!!!!This should now support multiline text!!!! This should now support multiline text!!!!This should now support multiline text!!!!",@"message",  nil]];
    
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"chat", @"type", @"Zach Cancio", @"name", @"I'm always there too!",@"message",  nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"want", @"type", @"Ryan Waliany", @"name", @"also wants to come there.",@"message",  nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"like", @"type", @"Audrey Wu", @"name", @"liked your spot update.",@"message",  nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"been", @"type", @"Serena Wu", @"name", @"has been there before.", @"message", nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"here", @"type", @"Ken Elkabany", @"name", @"is here right now.", @"message",  nil]];

    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"chat", @"type", @"Paul Mason", @"name", @"Is their food decent? I've always wanted to try this place. heard their cucumber mint lemonade rocks.", @"message",  nil]];
    
    self.comments = items;
    
    int offset = 65;
    int padding = 5;
    
    for (int i = 0; i < comments.count; i++)
    {
        UIView *bubble = [self getBubbleForContext:[comments objectAtIndex:i]];
        CGRect frame = bubble.frame;
        frame.origin.y = offset;
        bubble.frame = frame;
        
        offset = offset + padding + frame.size.height;
        [self.scrollView addSubview:bubble];
    }
        
        
    NSLog(@"%f %f", self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, offset);
    
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleTap];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsShown = NO;

}

- (UIView*)getBubbleForContext:(NSDictionary*)item
{
    UIView *messageView = [UIView new];
    messageView.layer.cornerRadius = 5.0f;
    
    if ([[item objectForKey:@"type"] isEqual:@"comment"])
    {
        messageView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        messageView.backgroundColor = [UIColor whiteColor];
    }
    
    messageView.layer.masksToBounds = YES;
    
    
    
    
    UILabel *labelView = [UILabel new];
    
    if ([item objectForKey:@"name"])
    {
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(25.0f,7.f,260.0f,30.f)];
        NSString *name = [item objectForKey:@"name"];
        
        if ([[item objectForKey:@"type"] isEqual:@"chat"])
        {
            [labelName setText:[NSString stringWithFormat:@"%@: ",name]];
        }
        else
        {
            [labelName setText:[NSString stringWithFormat:@"%@ ",name]];
        }
        
        labelName.backgroundColor = [UIColor clearColor];
        [labelName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
        [labelName setTextColor:[UIColor colorWithWhite:0.2f alpha:1.0]];
        [labelName sizeToFit];
        [messageView addSubview:labelName];
        
        [labelView setFrame:CGRectMake(25.0f,7, 260.0f, 30.0f)];
        NSString *tmp = @"";
        
        while ([tmp sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0f]].width < [labelName frame].size.width)
        {
            tmp = [tmp stringByAppendingString:@" "];
        }
        
        [labelView setText:[NSString stringWithFormat:@"%@%@", tmp, [item objectForKey:@"message"]]];
    }
    else
    {
        [labelView setFrame:CGRectMake(7.5f,7, 260.0f, 30.0f)];
        [labelView setText:[item objectForKey:@"message"]];
    }
    
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor blackColor];
    labelView.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    labelView.lineBreakMode = UILineBreakModeWordWrap;
    labelView.numberOfLines = 0;
    [labelView sizeToFit];
    [messageView addSubview:labelView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 7.5f, 15.f, 15.f)];
    if ([[item objectForKey:@"type"] isEqual:@"chat"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentBlurb.png"]];
    else if ([[item objectForKey:@"type"] isEqual:@"want"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentGo.png"]];
    else if ([[item objectForKey:@"type"] isEqual:@"like"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentLike.png"]];
    else if ([[item objectForKey:@"type"] isEqual:@"been"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentBeen.png"]];
    else if ([[item objectForKey:@"type"] isEqual:@"here"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentHere.png"]];
    [messageView addSubview:img];

    CGSize sz = [labelView sizeThatFits:CGSizeMake(260.0f, 1024.0f)];
    [messageView setFrame:CGRectMake(10.0f, 0.0f, 300.f, 14.0f+sz.height)];
    
    NSLog(@"%f %f", sz.width, sz.height);
    
    return messageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];    
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height);

    CGRect toolbarFrame = self.toolbar.frame;
    toolbarFrame.origin.y += (keyboardSize.height);

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [toolbar setFrame:toolbarFrame];
    [self.scrollView setFrame:viewFrame];
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [scrollView setContentOffset:bottomOffset];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the UIScrollView if the keyboard is already shown.  This can happen if the user, after fixing editing a UITextField, scrolls the resized UIScrollView to another UITextField and attempts to edit the next UITextField.  If we were to resize the UIScrollView again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height);
        

    CGRect toolbarFrame = self.toolbar.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    NSLog(@"frame %@", NSStringFromCGRect(toolbarFrame));
    toolbarFrame.origin.y -= (keyboardSize.height);
    NSLog(@"frame %@", NSStringFromCGRect(toolbarFrame));
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [toolbar setFrame:toolbarFrame];
    [self.scrollView setFrame:viewFrame];
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [scrollView setContentOffset:bottomOffset];
    [UIView commitAnimations];
    
    keyboardIsShown = YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}



- (void)handleSingleTap:(UIGestureRecognizer *)sender
{
    if (keyboardIsShown)
        [textInput resignFirstResponder];
}


@end
