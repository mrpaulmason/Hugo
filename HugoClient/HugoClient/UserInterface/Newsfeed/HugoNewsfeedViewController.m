//
//  HugoNewsfeedViewController.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/27/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoNewsfeedViewController.h"
#import "HQuery.h"
#import "AppDelegate.h"
#import "HugoSocialView.h"
#import "HugoCommentsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"

@interface HugoNewsfeedViewController ()

@end

@implementation HugoNewsfeedViewController

@synthesize results, tableView;

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
    
    
    NSLog(@"Ran viewDidLoad");
    
    self.navigationController.delegate = self;
    
    [tableView setBackgroundColor:[UIColor colorWithWhite:0.89f alpha:1.0f]];
    
    
    [super viewDidLoad];
        
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"foo");
    NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    NSLog(@"%@", NSStringFromCGRect(self.view.superview.frame));
    
}

- (void)pullAllComments
{
    for (NSMutableDictionary *item in results)
    {
        HQuery *hQuery = [[HQuery alloc] init];
        [hQuery queryComments:[item objectForKey:@"id"] withCallback:^(id JSON, NSError *error) {
            if (error == nil)
            {
                NSLog(@"Received comments:");
                NSLog(@"%@", JSON);
                
                [item setObject:[JSON objectForKey:@"results"] forKey:@"comments"];
                // Maybe check if its in view only
                [tableView reloadData];
            }
        }];
        
    }
    
}
     
- (void)refresh
{    
    HQuery *hQuery = [[HQuery alloc] init];
    [hQuery queryNewsfeed:@"newsfeed" withCallback:^(id JSON, NSError *error) {
        if (error == nil)
        {
            NSLog(@"Received results!");
            
            self.results = [JSON mutableCopy];
//            [self pullAllComments];
            [tableView reloadData];
        }
        [self stopLoading];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (NSInteger)tableView:(UITableView *)sTableView numberOfRowsInSection:(NSInteger)section
{
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
    
//    [vc setCategoryFilter:sender];
}

- (void)comment:(id) sender
{
//    [self performSegueWithIdentifier:@"segueComments2" sender:sender];
}

- (void)like:(id) sender
{
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    NSString *post_id = [btn titleForState:UIControlStateDisabled];
    NSMutableDictionary *itemMatch = nil;
    
    for (NSMutableDictionary *item in results)
    {
        if ([[[item objectForKey:@"id"] stringValue] isEqualToString:post_id])
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
            }
        }];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)sTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    id appDelegate = [[UIApplication sharedApplication] delegate];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    UITableViewCell *cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewStylePlain
                reuseIdentifier:CellIdentifier];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSLog(@"%@", [results objectAtIndex:indexPath.row]);
    
    int photo_width = 0;
    int photo_height = 0;
    float scale = 0;
    float offset = 0;
    
    
    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"photo"])
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

    if (daysAgo > 30)
        [label2 setText:@" has been to"];
    else
        [label2 setText:@" was spotted at"];
        
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
        [milesLabel setText:[NSString stringWithFormat:@"%d year%@ ago, %0.1f miles away",yearsAgo,yearsAgo==1?@"":@"s", miles]];
    else if (monthsAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"%d month%@ ago, %0.1f miles away",monthsAgo,monthsAgo==1?@"":@"s", miles]];
    else if (daysAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"%d day%@ ago, %0.1f miles away",daysAgo,daysAgo==1?@"":@"s", miles]];
    else if (hoursAgo > 0)
        [milesLabel setText:[NSString stringWithFormat:@"%d hour%@ ago, %0.1f miles away",hoursAgo,hoursAgo==1?@"":@"s", miles]];
    else
        [milesLabel setText:[NSString stringWithFormat:@"%d minute%@ ago, %0.1f miles away",minutesAgo,minutesAgo==1?@"":@"s", miles]];
    
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
    
    if ([[results objectAtIndex:indexPath.row] objectForKey:@"spot_message"])
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

    
    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"photo"])
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
    
    HugoSocialView *socialView = [[HugoSocialView alloc] initWithFrame:CGRectMake(80, 15, 235, 55) andStatuses:[[results objectAtIndex:indexPath.row] objectForKey:@"statuses"] andPlace:[[results objectAtIndex:indexPath.row] objectForKey:@"fb_place_id"]];
    [socialView setTag:1];
    [cell addSubview:socialView];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float sz = 105;
        
    if ([[[results objectAtIndex:indexPath.row] objectForKey:@"type"] isEqual:@"photo"])
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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

@end
