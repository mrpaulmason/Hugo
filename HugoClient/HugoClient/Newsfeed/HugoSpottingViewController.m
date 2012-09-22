//
//  HugoSpottingViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 9/20/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoSpottingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HugoSpottingViewController ()

@end

@implementation HugoSpottingViewController
@synthesize profilePicture, spottingDetails, comments, tableView;


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
    profilePicture.layer.cornerRadius = 5.0f;
    profilePicture.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    profilePicture.layer.masksToBounds = YES;
    profilePicture.layer.borderWidth = 0.5f;

    spottingDetails.layer.cornerRadius = 5.0f;
    spottingDetails.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    spottingDetails.layer.borderWidth = 0.5f;

    NSMutableArray *items = [NSMutableArray array];

    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"comment", @"type", @"Lot's of seating w/ outlets and great music!!",@"message",  nil]];
    
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"chat", @"type", @"Zach Cancio", @"name", @"I'm always there too!",@"message",  nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"want", @"type", @"Ryan Waliany", @"name", @"also wants to come there.",@"message",  nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"like", @"type", @"Audrey Wu", @"name", @"liked your spot update.",@"message",  nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"been", @"type", @"Serena Wu", @"name", @"has been there before.", @"message", nil]];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"here", @"type", @"Ken Elkabany", @"name", @"is here right now.", @"message",  nil]];
    
    self.comments = items;
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.layer.cornerRadius = 5.0f;
    tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tableView.layer.borderWidth = 1.0f;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)sTableView numberOfRowsInSection:(NSInteger)section
{
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)sTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewStylePlain
                             reuseIdentifier:CellIdentifier];
    
    NSLog(@"%@", comments);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *messageView = [UIView new];
    [messageView setFrame:CGRectMake(10.0f, 10.0f, 280.f, 30.0f)];
    messageView.layer.cornerRadius = 5.0f;
    messageView.backgroundColor = [UIColor colorWithRed:238/255.0 green:246/255.0 blue:250/255.0 alpha:1.0];
    messageView.layer.masksToBounds = YES;
    
    
    
    
    UILabel *labelView = [UILabel new];
    
    if ([[comments objectAtIndex:indexPath.row] objectForKey:@"name"])
    {
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(25.0f,7.f,260.0f,30.f)];
        NSString *name = [[comments objectAtIndex:indexPath.row] objectForKey:@"name"];
        [labelName setText:[NSString stringWithFormat:@"%@: ",name]];
        labelName.backgroundColor = [UIColor clearColor];
        [labelName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
        [labelName setTextColor:[UIColor colorWithWhite:0.2f alpha:1.0]];
        [labelName sizeToFit];
        [messageView addSubview:labelName];

        [labelView setFrame:CGRectMake(25.0f+[labelName frame].size.width,0, 260.0f, 30.0f)];
    }
    else
    {
        [labelView setFrame:CGRectMake(25.0f,0, 260.0f, 30.0f)];
    }

    [labelView setText:[[comments objectAtIndex:indexPath.row] objectForKey:@"message"]];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor blackColor];
    labelView.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    [messageView addSubview:labelView];
        
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 7.5f, 15.f, 15.f)];
    if ([[[comments objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"chat"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentBlurb.png"]];
    else if ([[[comments objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"want"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentGo.png"]];
    else if ([[[comments objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"like"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentLike.png"]];
    else if ([[[comments objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"been"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentBeen.png"]];
    else if ([[[comments objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"here"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentHere.png"]];
    [messageView addSubview:img];
    
    [cell addSubview:messageView];
    
    return cell;
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
