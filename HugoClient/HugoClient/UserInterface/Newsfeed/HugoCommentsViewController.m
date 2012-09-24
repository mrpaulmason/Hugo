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
#import "HugoCommentsView.h"

@interface HugoCommentsViewController ()

@end

@implementation HugoCommentsViewController
@synthesize profilePicture, spottingDetails, scrollView, toolbar, textInput, barButtonItem, doneButtonItem, commentsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (NSArray*) staticComments
{
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"comment", @"type", @"Lot's of seating w/ outlets and great music!! ",@"message",  nil]];
    
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"chat", @"type", @"Zach Cancio", @"name", @"I'm always there too!",@"message",  nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"want", @"type", @"Ryan Waliany", @"name", @"also wants to come there.",@"message",  nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"like", @"type", @"Audrey Wu", @"name", @"liked your spot update.",@"message",  nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"been", @"type", @"Serena Wu", @"name", @"has been there before.", @"message", nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"here", @"type", @"Ken Elkabany", @"name", @"is here right now.", @"message",  nil]];
    
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"chat", @"type", @"Paul Mason", @"name", @"Is their food decent? I've always wanted to try this place. heard their cucumber mint lemonade rocks.", @"message",  nil]];
    
    return items;
}

- (void)initializeStyles
{
    profilePicture.layer.cornerRadius = 5.0f;
    profilePicture.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    profilePicture.layer.masksToBounds = YES;
    profilePicture.layer.borderWidth = 0.5f;
    
    spottingDetails.layer.cornerRadius = 5.0f;
    spottingDetails.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    spottingDetails.layer.borderWidth = 0.5f;
    
    scrollView.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0];
}

- (void)initializeResponders
{
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleTap];

    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapVenue:)];
    singleTap.numberOfTapsRequired = 1;
    [spottingDetails addGestureRecognizer:singleTap];

    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(tapProfile:)];
    singleTap.numberOfTapsRequired = 1;
    [profilePicture addGestureRecognizer:singleTap];

    [barButtonItem setAction:@selector(comment:)];
    [doneButtonItem setAction:@selector(closeModal:)];
}

- (void)initializeNotifications
{
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

- (void)updateSize
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 60+commentsView.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self initializeStyles];
    [self initializeResponders];
    [self initializeNotifications];
    
    [[self navigationItem] setTitle:@"Spot Update"];
    [[[self navigationController] navigationBar] setNeedsDisplay];

    self.commentsView = [[HugoCommentsView alloc] initWithComments:[HugoCommentsViewController staticComments]];
    CGRect frame = commentsView.frame;
    frame.origin.y = 60;
    commentsView.frame = frame;
    [self.scrollView addSubview:commentsView];
    
    [self updateSize];
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
    

    [[self navigationItem] setTitle:@"Spot Update"];

    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height-50);

    CGRect toolbarFrame = self.toolbar.frame;
    toolbarFrame.origin.y += (keyboardSize.height-50);

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [toolbar setFrame:toolbarFrame];
    [self.scrollView setFrame:viewFrame];
    float offset = scrollView.contentSize.height - self.scrollView.bounds.size.height;
    CGPoint bottomOffset = CGPointMake(0, offset > 0 ? offset : 0);
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
    
    [[self navigationItem] setTitle:@"Comment"];
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height-50);
        

    CGRect toolbarFrame = self.toolbar.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    NSLog(@"frame %@", NSStringFromCGRect(toolbarFrame));
    toolbarFrame.origin.y -= (keyboardSize.height-50);
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

- (void)tapProfile:(id)sender
{
    [self performSegueWithIdentifier:@"segueProfile" sender:self];    
}

- (void)tapVenue:(id)sender
{
    [self performSegueWithIdentifier:@"segueVenue" sender:self];
}

- (IBAction)comment:(id)sender
{
    
    if ([[textInput text] length] > 0)
    {
        [commentsView addComment:[textInput text]];
        [self updateSize];
    }

    if (keyboardIsShown)
        [textInput resignFirstResponder];
    
    [textInput setText:@""];

    NSLog(@"comment sent");
    
}

- (IBAction)closeModal:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
