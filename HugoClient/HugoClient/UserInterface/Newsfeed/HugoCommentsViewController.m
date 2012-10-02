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
#import "HQuery.h"
#import "SBJson.h"
#import "UIImageView+AFNetworking.h"
#import "HugoNewsfeedViewController.h"
#import "HugoProfileViewController.h"

@interface HugoCommentsViewController ()

@end

@implementation HugoCommentsViewController
@synthesize profilePicture, spottingDetails, scrollView, toolbar, textInput, barButtonItem, doneButtonItem, commentsView, spotData;

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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, commentsView.frame.origin.y+commentsView.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", spotData);
    
	// Do any additional setup after loading the view.

    [self initializeStyles];
    [self initializeResponders];
    [self initializeNotifications];
    
    [[self navigationItem] setTitle:@"Spot Details"];
    [[[self navigationController] navigationBar] setNeedsDisplay];

    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    float offset = 60.0f;
    
    if ([[spotData objectForKey:@"type"] isEqual:@"photo"])
    {
        int photo_height = [[spotData objectForKey:@"photo_height"] integerValue];
        int photo_width = [[spotData objectForKey:@"photo_width"] integerValue];
        float scale = 320.0f/photo_width;

        UIImageView *imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, offset+10, 320.f, photo_height*scale)];
        imgPhoto.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        imgPhoto.layer.borderColor = [[UIColor whiteColor] CGColor];
        imgPhoto.layer.borderWidth = 3.0f;
        imgPhoto.layer.shadowOpacity = 0.3f;
        imgPhoto.layer.shadowOffset = CGSizeMake(0,0.0);
        imgPhoto.layer.shadowColor = [[UIColor blackColor] CGColor];
        imgPhoto.layer.shadowRadius = 3.0f;
        [imgPhoto setImageWithURL:[NSURL URLWithString:[spotData objectForKey:@"photo_src"]]];
        [self.scrollView addSubview:imgPhoto];
        offset += photo_height*scale + 10;
    }
    
    NSDictionary *locationData = [parser objectWithString:[spotData objectForKey:@"spot_location"]];
    [spottingDetails.textLabel setText:[spotData objectForKey:@"spot_name"]];
    [spottingDetails.detailTextLabel setText:[NSString stringWithFormat:@"%@, %@, %@", [locationData objectForKey:@"street"],[locationData objectForKey:@"city"], [locationData objectForKey:@"state"]]];
    
    [profilePicture setImageWithURL:[NSURL URLWithString:[spotData objectForKey:@"author_image"]]];
    
    NSMutableArray *comments = [[spotData objectForKey:@"comments"] mutableCopy];
        
    if ([spotData objectForKey:@"spot_message"] && [[spotData objectForKey:@"spot_message"] length] > 0)
    {
        [comments insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"comment", @"comment_type", [spotData objectForKey:@"spot_message"],@"comment_message",  nil] atIndex:0];
    }
    
    self.commentsView = [[HugoCommentsView alloc] initWithComments:comments andPadding:10 andWidth:300.0f];
    CGRect frame = commentsView.frame;
    frame.origin.y = offset;
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
    

    [[self navigationItem] setTitle:@"Spot Details"];

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueVenue"])
    {
        NSLog(@"Segue to venue page");
        HugoCommentsViewController *vc = [segue destinationViewController];
        [vc setSpotData:spotData];
    }
    else if ([[segue identifier] isEqualToString:@"segueProfile"])
    {
        NSLog(@"Segue to venue page");
        HugoProfileViewController *vc = [segue destinationViewController];
        
        if ([spotData objectForKey:@"author_hugo_id"])
        {
            [vc setSource:@"hugo"];
            [vc setProfileId:[NSString stringWithFormat:@"%@",[spotData objectForKey:@"author_uid"]]];
            [vc setHugoId:[spotData objectForKey:@"author_hugo_id"]];
        }
        else
        {
            [vc setSource:@"facebook"];
            [vc setProfileId:[NSString stringWithFormat:@"%@",[spotData objectForKey:@"author_uid"]]];
        }
    }
}

- (void)tapProfile:(id)sender
{
    [self performSegueWithIdentifier:@"segueProfile" sender:@"profile"];
}

- (void)tapVenue:(id)sender
{
    [self performSegueWithIdentifier:@"segueVenue" sender:@"venue"];
}

- (IBAction)comment:(id)sender
{
    
    if ([[textInput text] length] > 0)
    {
        [commentsView addComment:[textInput text]];
        HQuery *hQuery = [[HQuery alloc] init];
        [hQuery postComment:[spotData objectForKey:@"id"] withType:@"chat" andMessage:[textInput text] withCallback:^(id JSON, NSError *error) {
            if (error == nil)
            {
                NSLog(@"Received comments:");
                NSLog(@"%@", JSON);
                
                // Generalize this to other classes
                int count = [self.navigationController.viewControllers count];
                HugoNewsfeedViewController* prevController = [self.navigationController.viewControllers objectAtIndex:count-2];
                
                
                [prevController refresh];

            }
        }];
        
        
        
        
        
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
