//
//  HugoResultsListViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoProfileViewController.h"
#import "AppDelegate.h"
#import "HQuery.h"
#import "SBJson.h"
#import "HugoCommentsView.h"
#import <QuartzCore/QuartzCore.h>
#import "HugoCommentsViewController.h"
#import "HugoSocialView.h"
#import "Flurry.h"

@interface HugoProfileViewController ()

@end

@implementation HugoProfileViewController
@synthesize results, tableView, header, profile, source, profileId, label1, label2, label3, labelFriends, friendPickerController, hugoId;

@synthesize searchBar = _searchBar;
@synthesize searchText = _searchText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)inviteFriends
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Check out this awesome app for finding places to go through your friends.",  @"message",
                                   nil];
    
    // Initiate a Facebook instance
    PF_FBSession *session = [PFFacebookUtils session];
    
    PF_Facebook *facebook = [[PF_Facebook alloc]
                             initWithAppId:@"469021446449087"
                             andDelegate:nil];
    
    // Store the Facebook session information
    facebook.accessToken =  session.accessToken;
    facebook.expirationDate = session.expirationDate;
    
    [facebook dialog:@"apprequests" andParams:params andDelegate:nil];
    return;
    
    // Old Code
    
    if (!self.friendPickerController) {
        
        self.friendPickerController = [[PF_FBFriendPickerViewController alloc]
                                       init];
        self.friendPickerController.title = @"Invite friends";
        self.friendPickerController.delegate = self;
        NSSet *fields = [NSSet setWithObjects:@"installed",@"devices", nil];
        self.friendPickerController.fieldsForRequest = fields;
        
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    [self presentViewController:self.friendPickerController
                       animated:YES
                     completion:^(void){
                         [self addSearchBarToFriendPickerView];
                     }
     ];
}

- (void) handlePickerDone
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Logout");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"fb_auth_key"];
        [defaults removeObjectForKey:@"fb_expires"];
        [defaults removeObjectForKey:@"hugo_id"];
        [defaults removeObjectForKey:@"name"];
        [defaults synchronize];
        [PFUser logOut];
        [self.navigationController dismissModalViewControllerAnimated:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"Support");
        NSString* launchUrl = @"mailto://support@gethugo.com";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
    }
    NSLog(@"button press: %d", buttonIndex);
}

- (void) settings:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Settings" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:@"Support", nil];
    
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)viewDidLoad
{
    header.layer.shadowColor = [UIColor blackColor].CGColor;
    header.layer.shadowRadius = 1.0;
    header.layer.shadowOffset = CGSizeMake(0, 1.0);
    header.layer.shadowOpacity = 0.3;
    

    HQuery *hQuery = [[HQuery alloc] init];

    
    if (!source)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        [Flurry logEvent:@"hugo.view.self.profile"];

        
        [hQuery queryNewsfeed:@"user" withCallback:^(id JSON, NSError *error) {
            if (error == nil)
            {
                NSLog(@"Profile Received results!");
                self.results = JSON;
                [tableView reloadData];
            }
        }];
        
        HQuery *hQueryProfile = [[HQuery alloc] init];
        [hQueryProfile queryProfile:[defaults objectForKey:@"hugo_id"] withCallback:^(id JSON, NSError *error) {
            if (error == nil)
            {
                NSLog(@"1: Received profile information:");
                NSLog(@"%@", JSON);
                [profile setImageWithURL:[NSURL URLWithString:[JSON objectForKey:@"picture"]]];
                [label1 setText:[JSON objectForKey:@"name"]];
                [label3 setText:@"Hugonaut"];
                [self.navigationItem setTitle:[JSON objectForKey:@"name"]];
                [labelFriends setText:[[JSON objectForKey:@"friends"] stringValue]];
//                SBJsonParser *parser = [[SBJsonParser alloc] init];
//                NSDictionary *locationData = [parser objectWithString:[JSON objectForKey:@"current_location"]];

            }
        }];
        
        NSString *urlStr = [NSString stringWithFormat:@"me?fields=%@", @"name,location,picture"];
        PF_FBRequest *request = [PF_FBRequest requestForGraphPath:urlStr];
        [request startWithCompletionHandler:^(PF_FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            NSLog(@"%@",urlStr);
            if (!error) {
                [label2 setText:[[result objectForKey:@"location"] objectForKey:@"name"]];                
            }
        }];
    }
    else if ([source isEqualToString:@"hugo"])
    {
        [Flurry logEvent:@"hugo.view.other.profile"];

        [hQuery queryNewsfeed:@"user" andHugoId:hugoId withCallback:^(id JSON, NSError *error) {
            if (error == nil)
            {
                NSLog(@"Profile Received results! %@", JSON);
                self.results = JSON;
                [tableView reloadData];
            }
        }];
        
        PF_FBRequest *request = [PF_FBRequest requestForGraphPath:[NSString stringWithFormat:@"%@?fields=name,location,picture", profileId]];
        [request startWithCompletionHandler:^(PF_FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (!error) {
                [profile setImageWithURL:[NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]];
                [label1 setText:[result objectForKey:@"name"]];
                [label2 setText:[[result objectForKey:@"location"] objectForKey:@"name"]];
                [label3 setText:@"Hugo and Facebook friend"];
                [self.navigationItem setTitle:[result objectForKey:@"name"]];
                
            }
        }];
        
        HQuery *hQueryProfile = [[HQuery alloc] init];
        [hQueryProfile queryProfile:hugoId withCallback:^(id JSON, NSError *error) {
            if (error == nil)
            {
                NSLog(@"2: Received profile information: %@", JSON);
                [labelFriends setText:[[JSON objectForKey:@"friends"] stringValue]];
            }
        }];

    }
    else // get data from facebook
    {
        [Flurry logEvent:@"hugo.view.other.profile"];

        NSString *urlStr = [NSString stringWithFormat:@"%@?fields=%@", profileId, @"name,location,picture"];
        PF_FBRequest *request = [PF_FBRequest requestForGraphPath:urlStr];
        [request startWithCompletionHandler:^(PF_FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (!error) {
                [profile setImageWithURL:[NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]];
                [label1 setText:[result objectForKey:@"name"]];
                [label2 setText:[[result objectForKey:@"location"] objectForKey:@"name"]];
                [label3 setText:@"Facebook friend not on Hugo"];
                [self.navigationItem setTitle:[result objectForKey:@"name"]];
                [labelFriends setText:@"N/A"];
                [tableView reloadData];
                
            }
        }];
    }
    
    [[self navigationItem] setTitle:@"    "];

    // TODO-HACK: if only 1 viewcontroller, you are viewing your own profile
    if ([[self.navigationController viewControllers] count] == 1)
    {
        UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc]
                                          initWithCustomView:[self buttonFromImage:@"assets/profile/options.png" withHighlight:@"assets/profile/optionsB.png" selector:@selector(settings:) andFrame:CGRectMake(0, 0, 40, 30)]];
        self.navigationItem.leftBarButtonItem = optionsButton;
    }

    UIBarButtonItem *addFriend = [[UIBarButtonItem alloc]
                                      initWithCustomView:[self buttonFromImage:@"assets/profile/addFriend.png" withHighlight:@"assets/profile/addFriendB.png" selector:@selector(inviteFriends) andFrame:CGRectMake(0, 0, 40, 30)]];
    self.navigationItem.rightBarButtonItem = addFriend;
    
    profile.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    profile.layer.borderWidth = 1.0f;
    profile.layer.cornerRadius = 5.0f;
    profile.layer.masksToBounds = YES;

    [tableView setBackgroundColor:[UIColor colorWithWhite:0.89f alpha:1.0f]];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.searchBar = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([results count] == 0)
    {
        return 1;
    }
    // Return the number of rows in the section.
    return [results count];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[NSIndexPath class]])
    {
        HugoCommentsViewController *vc = [segue destinationViewController];
        NSIndexPath *path = (NSIndexPath*)sender;
        [vc setSpotData:[results objectAtIndex:[path row]]];
    }
    else if ([sender isKindOfClass:[UIButton class]])
    {
        HugoCommentsViewController *vc = [segue destinationViewController];
        UIButton *button = (UIButton*)sender;
        [vc setSpotData:[results objectAtIndex:[button tag]]];
    }
    
    //    [vc setCategoryFilter:sender];
}

- (void)comment:(id) sender
{
    [self performSegueWithIdentifier:@"segueComments2" sender:sender];
}

- (void)like:(id) sender
{
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    NSString *post_id = [btn titleForState:UIControlStateDisabled];
    NSMutableDictionary *itemMatch = nil;
    
    for (NSMutableDictionary *item in results)
    {
        if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"id"]] isEqualToString:post_id])
            itemMatch = item;
    }
    
    
    if (btn.selected)
    {
        HQuery *hQuery = [[HQuery alloc] init];
        [hQuery postComment:post_id withType:@"like" andMessage:@"" withCallback:^(id JSON, NSError *error) {
            if (error == nil)
            {
                NSLog(@"Received comments:");
                NSLog(@"%@", JSON);
                
                [itemMatch setObject:[JSON objectForKey:@"results"] forKey:@"comments"];
                [tableView reloadData];
            }
        }];
        
    }
    else
    {
        HQuery *hQuery = [[HQuery alloc] init];
        [hQuery postComment:post_id withType:@"unlike" andMessage:@"" withCallback:^(id JSON, NSError *error) {
            if (error == nil)
            {
                NSLog(@"Received comments:");
                NSLog(@"%@", JSON);
                
                [itemMatch setObject:[JSON objectForKey:@"results"] forKey:@"comments"];
                [tableView reloadData];
            }
        }];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)sTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([results count] == 0)
    {
        static NSString *CellIdentifier = @"NewsCell";
        UITableViewCell *cell = [[UITableViewCell alloc]
                                 initWithStyle:UITableViewStylePlain
                                 reuseIdentifier:CellIdentifier];

        if ([source isEqualToString:@"facebook"])
        {
            UIButton *buttonInvite = [self buttonFromImage:@"assets/profile/invite.png" withHighlight:@"assets/profile/inviteB.png" selector:@selector(inviteFriends) andFrame:CGRectMake(9, 10, 302, 32)];
            [buttonInvite setTitle:[NSString stringWithFormat:@"Invite %@ to Hugo", [[[label1 text] componentsSeparatedByString:@" "] objectAtIndex:0]] forState:UIControlStateNormal];
            [buttonInvite setTitleColor:[UIColor colorWithWhite:0.30 alpha:1.0f] forState:UIControlStateNormal];
            [cell addSubview:buttonInvite];
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9, 10, 302, 32)];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:12.f]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setText:@"No checkins on Facebook, add your spots on Hugo!"];
            [cell addSubview:label];
    
        }
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"ProfileCell";
    id appDelegate = [[UIApplication sharedApplication] delegate];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewStylePlain
                             reuseIdentifier:CellIdentifier];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    int photo_width = 0;
    int photo_height = 0;
    float scale = 0;
    float offset = 0;
    
    
    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"photo_src"] length] > 8)
    {
        photo_height = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_height"] integerValue];
        photo_width = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_width"] integerValue];
        scale = 320.0f/photo_width;
        
        
    }
    
    
    
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(10.0f, 10.0f, 300.0f, 95.f+photo_height*scale)];
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor colorWithWhite:0.70f alpha:1.0].CGColor;
    view.layer.borderWidth = 0.5f;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    [cell addSubview:view];
    
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 70.f+scale*photo_height, 300.0f, 25.f)];
    bottomBar.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    [view addSubview:bottomBar];
    
    UIButton *buttonComment = [self buttonFromImage:@"assets/newsfeed/comment.png" withHighlight:@"assets/newsfeed/commentB.png" selector:@selector(comment:) andFrame:CGRectMake(200, 0, 50, 25)];
    buttonComment.tag = indexPath.row;
    [bottomBar addSubview:buttonComment];
    
    UIButton *buttonLike = [self buttonFromImage:@"assets/newsfeed/like.png" withHighlight:@"assets/newsfeed/likeB.png" withSelected:@"assets/newsfeed/likeC.png" selector:@selector(like:) andFrame:CGRectMake(250, 0, 50, 25)];
    [buttonLike setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:indexPath.row] objectForKey:@"id"]] forState:UIControlStateDisabled];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *hugo_id = [defaults objectForKey:@"hugo_id"];
    
    for (NSDictionary *comments in [[results objectAtIndex:indexPath.row] objectForKey:@"comments"])
    {
        if ([[comments objectForKey:@"comment_type"] isEqualToString:@"like"] && [[comments objectForKey:@"user_id"] isEqualToNumber:hugo_id])
        {
            [buttonLike setSelected:YES];
        }
    }
    
    [bottomBar addSubview:buttonLike];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70.0f,11.f,200.0f,13.f)];
    NSString *name = [[results objectAtIndex:indexPath.row] objectForKey:@"author_name"];
    NSArray *names = [name componentsSeparatedByString:@" "];
    [label setText:[names objectAtIndex:0]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
    [label setTextColor:[UIColor colorWithWhite:0.2f alpha:1.0]];
    [label sizeToFit];
    [view addSubview:label];
    
    double currentTime = [[NSDate date] timeIntervalSince1970];
    int minutesAgo = (currentTime - [[[results objectAtIndex:indexPath.row] objectForKey:@"timestamp"] integerValue])/60;
    int hoursAgo = minutesAgo/60;
    int daysAgo = hoursAgo/24;
    int monthsAgo = daysAgo/30;
    int yearsAgo = daysAgo/365;
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(70.0f+[label frame].size.width,11.f,200.0f,13.f)];

    if ([[results objectAtIndex:indexPath.row] objectForKey:@"spot_type"] && [[[results objectAtIndex:indexPath.row] objectForKey:@"spot_type"] isEqualToString:@"go"])
    {
        [label2 setText:@" wants to go here"];
        
    }
    else if ([[results objectAtIndex:indexPath.row] objectForKey:@"spot_type"] && [[[results objectAtIndex:indexPath.row] objectForKey:@"spot_type"] isEqualToString:@"been"])
    {
        [label2 setText:@" has been here"];
    }
    else
    {
        if (hoursAgo < 24)
            [label2 setText:@" is here now"];
        else if (daysAgo > 1 && daysAgo < 42)
            [label2 setText:@" was recently here"];
        else
            [label2 setText:@" has been here"];
    }

        
    [label2 setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [label2 setTextColor:[UIColor colorWithWhite:0.53f alpha:1.0]];
    [label2 sizeToFit];
    [view addSubview:label2];
    
    UILabel *labelVenue = [[UILabel alloc] initWithFrame:CGRectMake(70.0f,29.f,200.0f,13.f)];
    [labelVenue setText:[[results objectAtIndex:indexPath.row] objectForKey:@"spot_name"]];
    
    if ([[labelVenue text] length] > 25)
    {
        [labelVenue setText:[NSString stringWithFormat:@"%@...",[[labelVenue text] substringToIndex:25]]];
    }
    
    [labelVenue setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
    [labelVenue setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0]];
    [labelVenue sizeToFit];
    [view addSubview:labelVenue];
    
    UILabel *labelStreet = [[UILabel alloc] initWithFrame:CGRectMake(70.0f,47.f,200.0f,13.f)];
    NSDictionary *locationData = [parser objectWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"spot_location"]];
    [labelStreet setText:[locationData objectForKey:@"street"]];
    
    if ([[labelStreet text] length] > 30)
    {
        [labelStreet setText:[NSString stringWithFormat:@"%@...",[[labelStreet text] substringToIndex:30]]];
    }
    
    [labelStreet setFont:[UIFont fontWithName:@"Helvetica" size:11.f]];
    [labelStreet setTextColor:[UIColor colorWithWhite:0.6f alpha:1.0]];
    [labelStreet sizeToFit];
    [view addSubview:labelStreet];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[locationData objectForKey:@"latitude"] doubleValue] longitude:[[locationData objectForKey:@"longitude"] doubleValue]];
    CLLocationCoordinate2D coord = [[appDelegate lastLocation] coordinate];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    double miles = distance * 0.000621371;
    
    UILabel *milesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f,5.0f,200.0f,25.f)];
    
    if (yearsAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"year%@ ago, %0.1f miles away",yearsAgo==1?@"":@"s", miles]];
    else if (monthsAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"month%@ ago, %0.1f miles away",monthsAgo==1?@"":@"s", miles]];
    else if (daysAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"day%@ ago, %0.1f miles away",daysAgo==1?@"":@"s", miles]];
    else if (hoursAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"hour%@ ago, %0.1f miles away",hoursAgo==1?@"":@"s", miles]];
    else
        [milesLabel setText:[NSString stringWithFormat:@"minute%@ ago, %0.1f miles away",minutesAgo==1?@"":@"s", miles]];
    
    NSLog(@"miles: %@, %@ %@", name, [milesLabel text], NSStringFromCGRect(milesLabel.frame));
    
    [milesLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.f]];
    [milesLabel setTextColor:[UIColor colorWithWhite:0.53f alpha:1.0]];
    [milesLabel setBackgroundColor:[UIColor clearColor]];
    [milesLabel sizeToFit];
    [bottomBar addSubview:milesLabel];
    
    
    
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 10.f, 50.f, 50.f)];
    img.layer.cornerRadius = 5.0;
    img.layer.masksToBounds = YES;
    [img setImageWithURL:[NSURL URLWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"author_image"]]];
    [view addSubview:img];
    
    
    NSMutableArray *comments = [[[results objectAtIndex:indexPath.row] objectForKey:@"comments"] mutableCopy];
    
    if ([[results objectAtIndex:indexPath.row] objectForKey:@"spot_message"] && [[[results objectAtIndex:indexPath.row] objectForKey:@"spot_message"] length] > 0)
    {
        [comments insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"comment", @"comment_type", [[results objectAtIndex:indexPath.row] objectForKey:@"spot_message"],@"comment_message",  nil] atIndex:0];
    }
    
    if ([comments count] > 4)
    {
        [comments insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"center", @"comment_type", [NSString stringWithFormat:@"%d more comments", [comments count]-4],@"comment_message",  nil] atIndex:4];
    }
    
    NSArray *halfArray;
    NSRange theRange;
    
    theRange.location = 0;
    theRange.length = [comments count] > 5 ? 5 : [comments count];
    
    halfArray = [comments subarrayWithRange:theRange];
    
    HugoCommentsView *commentsView = [[HugoCommentsView alloc] initWithComments:halfArray andPadding:0 andWidth:280.0f];
    CGRect frame = commentsView.frame;
    frame.origin.y = 70.f+photo_height*scale;
    commentsView.frame = frame;
    [view addSubview:commentsView];
    
    offset = frame.origin.y + frame.size.height;
    
    
    CGRect bFrame = bottomBar.frame;
    bFrame.origin.y = offset;
    bottomBar.frame = bFrame;
    
    offset += 25;
    
    CGRect vFrame = view.frame;
    vFrame.size.height = offset;
    [view setFrame:vFrame];
    
    
    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"photo_src"] length] > 8)
    {
        UIImageView *imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 75.f, 320.f, photo_height*scale)];
        imgPhoto.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        imgPhoto.layer.borderColor = [[UIColor whiteColor] CGColor];
        imgPhoto.layer.borderWidth = 3.0f;
        imgPhoto.layer.shadowOpacity = 0.3f;
        imgPhoto.layer.shadowOffset = CGSizeMake(0,0.0);
        imgPhoto.layer.shadowColor = [[UIColor blackColor] CGColor];
        imgPhoto.layer.shadowRadius = 3.0f;
        [imgPhoto setImageWithURL:[NSURL URLWithString:[[results objectAtIndex:indexPath.row] objectForKey:@"photo_src"]]];
        [cell addSubview:imgPhoto];
    }
    
    HugoSocialView *socialView = [[HugoSocialView alloc] initWithFrame:CGRectMake(80, 15, 235, 55) andStatuses:[[results objectAtIndex:indexPath.row] objectForKey:@"statuses"] andPlace:[[results objectAtIndex:indexPath.row] objectForKey:@"fb_place_id"] withDelegate:nil];
    [socialView setTag:1];
    [cell addSubview:socialView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float sz = 105;
    
    if ([results count] == 0) return sz;
    
    if (indexPath.row == [results count]-1)
        sz += 10;

    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"photo_src"] length] > 8)
    {
        int photo_height = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_height"] integerValue];
        int photo_width = [[[results objectAtIndex:indexPath.row] objectForKey:@"photo_width"] integerValue];
        float scale = 320.0f/photo_width;
        
        sz += scale*photo_height;
    }
    
    
    NSMutableArray *comments = [[[results objectAtIndex:indexPath.row] objectForKey:@"comments"] mutableCopy];
    
    if ([[results objectAtIndex:indexPath.row] objectForKey:@"spot_message"] && [[[results objectAtIndex:indexPath.row] objectForKey:@"spot_message"] length] > 0)
    {
        [comments insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"comment", @"comment_type", [[results objectAtIndex:indexPath.row] objectForKey:@"spot_message"],@"comment_message",  nil] atIndex:0];
    }
    
    if ([comments count] > 4)
    {
        [comments insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"center", @"comment_type", [NSString stringWithFormat:@"%d more comments", [comments count]-4],@"comment_message",  nil] atIndex:4];
    }
    
    NSArray *halfArray;
    NSRange theRange;
    
    theRange.location = 0;
    theRange.length = [comments count] > 5 ? 5 : [comments count];
    
    halfArray = [comments subarrayWithRange:theRange];
    
    HugoCommentsView *commentsView = [[HugoCommentsView alloc] initWithComments:halfArray andPadding:0 andWidth:280.0f];
    sz += commentsView.frame.size.height;
    
    return sz;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)sTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [self performSegueWithIdentifier:@"segueComments2" sender:indexPath];
    
}

#pragma mark - FB Friend Picker View Controller Delegate
- (void)addSearchBarToFriendPickerView
{
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.placeholder = @"Search for a user";

        
        for (UIView *searchBarSubview in [self.searchBar subviews]) {
            
            if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
                
                @try {
                    
                    [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
                    [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
                }
                @catch (NSException * e) {
                    
                    // ignore exception
                }
            }
        }
        
        [self.friendPickerController.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.friendPickerController.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.friendPickerController.tableView.frame = newFrame;
    }
}

- (void) handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.friendPickerController updateView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{    
    self.searchText = searchBar.text;
    [self.friendPickerController updateView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchText = nil;
    [searchBar resignFirstResponder];
}

// show friends who are not on Hugo
-(BOOL)friendPickerViewController:(PF_FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<PF_FBGraphUser>)user{
    BOOL installed = [user objectForKey:@"installed"] != nil;
    BOOL iPhoneUser = false;
    NSArray *devices = [user objectForKey:@"devices"];
    
    for (NSDictionary *entry in devices)
    {
        if ([[entry objectForKey:@"os"] isEqualToString:@"iOS"])
        {
            iPhoneUser = true;
        }
    }
    
    BOOL condition = YES;//!installed && iPhoneUser;

    
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            return condition;
        } else {
            return NO;
        }
    } else {
        return condition;
    }
    return condition;
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self handlePickerDone];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    for (id<PF_FBGraphUser> user in self.friendPickerController.selection) {
        
        NSLog(@"Friend selected: %@", user.name);
    }
    [self handlePickerDone];
}

@end
