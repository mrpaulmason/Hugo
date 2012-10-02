//
//  HugoSpotViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 10/1/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoSpotViewController.h"
#import "HugoVenueViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"

@interface HugoSpotViewController ()

@end

@implementation HugoSpotViewController
@synthesize scrollView, spotData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _offset = 0;
    }
    return self;
}

- (void)initHeader
{
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePost:)]];
    
    UITableViewCell *tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"nosuchthing"];
    
    [tableCell setBackgroundColor:[UIColor whiteColor]];
    [tableCell setFrame:CGRectMake(10.0f, 10.0f+_offset, 300.0f, 50.0f)];

    tableCell.layer.cornerRadius = 5.0f;
    tableCell.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    tableCell.layer.borderWidth = 0.5f;
    
    if ([spotData objectForKey:@"fb_place_id"])
    {
        NSString *requestPath = [NSString stringWithFormat:@"%@?fields=location,picture,name,category", [spotData objectForKey:@"fb_place_id"]];
        NSLog(@"%@ response", requestPath);
        PF_FBRequest *request = [PF_FBRequest requestForGraphPath:requestPath];
        [request setSession:[PFFacebookUtils session]];
        [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                self.spotData = result;
                NSLog(@"Query succeeded with %@", spotData);
                [tableCell.textLabel setText:[spotData objectForKey:@"name"]];
                [tableCell.detailTextLabel setText:[spotData objectForKey:@"category"]];
            }
        }];
    }
    else
    {
        [tableCell.textLabel setText:[spotData objectForKey:@"name"]];
        [tableCell.detailTextLabel setText:[spotData objectForKey:@"category"]];
    }
    
    [self.scrollView addSubview:tableCell];
    _offset += 60.0f;

}

- (void)unselectChildrenFromParent:(UIButton*)sender
{
    for (UIButton *btn in [[sender superview] subviews])
    {
        [btn setSelected:NO];
    }
}

- (void)beenThere:(UIButton*)sender
{
    [self unselectChildrenFromParent:sender];
    [sender setSelected:YES];
}

- (void)hereNow:(id)sender
{
    [self unselectChildrenFromParent:sender];
    [sender setSelected:YES];
    
}

- (void)wanaGo:(id)sender
{
    [self unselectChildrenFromParent:sender];
    [sender setSelected:YES];

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

- (UIButton*) buttonFromImage:(NSString*)imgA withHighlight:(NSString*)imgB withSelected:(NSString*)imgC selector:(SEL) sel andFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    UIImage *buttonImageNormal = [UIImage imageNamed:imgA];
    UIImage *buttonImageDown = [UIImage imageNamed:imgB];
    UIImage *buttonImageSelected = [UIImage imageNamed:imgC];
    [button setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageDown forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonImageSelected forState:UIControlStateSelected];
    [button setAdjustsImageWhenHighlighted:NO];
    
    
    [button addTarget:self
               action:sel
     forControlEvents:UIControlEventTouchDown];
    
    button.frame = frame;
    return button;
}

- (void)initCommentBox
{
    UIView *commentBox = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f+_offset, 300.0f, 175.f)];
    
    [commentBox setBackgroundColor:[UIColor whiteColor]];
    commentBox.layer.cornerRadius = 5.0f;
    commentBox.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    commentBox.layer.borderWidth = 0.5f;
    
    [self.scrollView addSubview:commentBox];
    
    NSString *urlStr = [NSString stringWithFormat:@"me?fields=%@", @"picture"];
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:urlStr];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 10.f, 50, 50)];
            NSLog(@"%@", result);
            [img setImageWithURL:[NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]];
            img.layer.cornerRadius = 5.0f;
            img.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
            img.layer.masksToBounds = YES;
            img.layer.borderWidth = 0.5f;
            [commentBox addSubview:img];
        }
    }];
    
    UIImageView *expandedBar = [[UIImageView alloc] initWithFrame:CGRectMake(80, 10, 195, 50)];
    [expandedBar setImage:[UIImage imageNamed:@"assets/newsfeed/addOptions.png"]];
    [expandedBar setTag:2];
    expandedBar.userInteractionEnabled = YES;
    [commentBox addSubview:expandedBar];
    
    UIButton *buttonBeenThere = [self buttonFromImage:@"assets/newsfeed/optionsBeen.png" withHighlight:@"assets/newsfeed/optionsBeenB.png" withSelected:@"assets/newsfeed/optionsBeenB.png" selector:@selector(beenThere:) andFrame:CGRectMake(0, 0, 65, 50)];
    [expandedBar addSubview:buttonBeenThere];
    
    UIButton *buttonHereNow = [self buttonFromImage:@"assets/newsfeed/optionsHere.png" withHighlight:@"assets/newsfeed/optionsHereB.png" withSelected:@"assets/newsfeed/optionsHereB.png" selector:@selector(hereNow:) andFrame:CGRectMake(65, 0, 65, 50)];
    [buttonHereNow setSelected:YES];
    [expandedBar addSubview:buttonHereNow];
    
    UIButton *buttonWanaGo = [self buttonFromImage:@"assets/newsfeed/optionsGo.png" withHighlight:@"assets/newsfeed/optionsGoB.png" withSelected:@"assets/newsfeed/optionsGoB.png" selector:@selector(wanaGo:) andFrame:CGRectMake(130, 0, 65, 50)];
    [expandedBar addSubview:buttonWanaGo];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 70.f, 280.0f, 95.0f)];
    
    textView.layer.borderColor = [[UIColor colorWithWhite:0.90 alpha:1.0] CGColor];
    textView.layer.borderWidth = 1.0f;
    textView.layer.cornerRadius = 5.0;
    textView.layer.masksToBounds = YES;
    [textView setReturnKeyType:UIReturnKeyDone];
    [textView setFont:[UIFont fontWithName:@"Helvetica" size:13.f]];
    textView.delegate = self;
    [commentBox addSubview:textView];
    
    _offset += 185.f;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    return (newLength > 100) ? NO : YES;
}

- (void)addPhoto:(id)sender
{
    
}

- (void)toggleFB:(UIButton*)sender
{
    [sender setSelected:![sender isSelected]];
}

- (void)savePost:(id)sender
{
    
}

- (void)initButtons
{
    UIButton *btnAddPicture = [self buttonFromImage:@"assets/post/addPhoto.png" withHighlight:@"assets/post/addPhotoB.png" selector:@selector(addPhoto:) andFrame:CGRectMake(10.0f, _offset+10, 300.0f, 41.f)];
    
    [self.scrollView addSubview:btnAddPicture];
    _offset += 51;
    
    UIButton *btnFacebook = [self buttonFromImage:@"assets/post/fb.png" withHighlight:@"assets/post/fbB.png" withSelected:@"assets/post/fbB.png" selector:@selector(toggleFB:) andFrame:CGRectMake(284.f, _offset+10, 26.f, 26.f)];
    [btnFacebook setSelected:YES];
    [self.scrollView addSubview:btnFacebook];
    
    _offset += 36.f;

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"Spot Update"];
    [scrollView setBackgroundColor:[UIColor colorWithWhite:0.89f alpha:1.0f]];
    
    [self initHeader];
    [self initCommentBox];
    [self initButtons];
    
    CGRect frame = self.scrollView.frame;
    frame.size.height = _offset+10;
    [self.scrollView setContentSize:frame.size];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
