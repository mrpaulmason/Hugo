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
#import "HugoSocialView.h"
#import "UIImage+fixOrientation.h"
#import "HQuery.h"
#import "Flurry.h"

@interface HugoSpotViewController ()

@end

@implementation HugoSpotViewController
@synthesize scrollView, spotData, textView, socialView, refreshSpinner;

@synthesize imagePicker = _imagePicker;
@synthesize selectedPhoto = _selectedPhoto;
@synthesize imageView = _imageView;


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
        NSString *requestPath = [NSString stringWithFormat:@"%@?fields=id,location,picture,name,category", [spotData objectForKey:@"fb_place_id"]];
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

- (void) refresh
{
    
}

- (void)postPhotoThenOpenGraphAction
{
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(150,100, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    [self.view addSubview:refreshSpinner];
    self.scrollView.layer.opacity = 0.40;
    [scrollView setUserInteractionEnabled:NO];
    [refreshSpinner startAnimating];
    
    if (self.selectedPhoto == nil)
    {
        HQuery *hQuery = [[HQuery alloc] init];
        [hQuery postSpot:[spotData objectForKey:@"id"] withType:[socialView currentStatus] andMessage:[textView text] andPhoto:nil andWidth:0 andHeight:0 withCallback:^(id JSON, NSError *error) {
            if (error == nil)
            {
                NSLog(@"Received post:");
                NSLog(@"%@", JSON);
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Success"
                                      message: @"Your spot update has been posted!"
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [self postOpenGraphActionWithPhotoURL:nil];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]
                                     initWithTitle: @"Error!"
                                     message: @"Unable to post update."
                                     delegate: nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
                [alert show];
            }
            [refreshSpinner stopAnimating];
            self.scrollView.layer.opacity = 1.00;
        }];
        return;
    }
    
    PF_FBRequestConnection *connection = [[PF_FBRequestConnection alloc] init];
    
    // First request uploads the photo.
    PF_FBRequest *request1 = [PF_FBRequest
                           requestForUploadPhoto:[self.selectedPhoto fixOrientation]];
    [connection addRequest:request1
         completionHandler:
     ^(PF_FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
         }
     }
            batchEntryName:@"photopost"
     ];
    
    // Second request retrieves photo information for just-created
    // photo so we can grab its source.
    PF_FBRequest *request2 = [PF_FBRequest
                           requestForGraphPath:@"{result=photopost:$.id}"];
    
    [connection addRequest:request2
         completionHandler:
     ^(PF_FBRequestConnection *connection, id result, NSError *error) {
         if (!error &&
             result) {
             NSLog(@"%@", result);
             NSString *source = [result objectForKey:@"source"];
             NSLog(@"%@", source);
             [self postOpenGraphActionWithPhotoURL:source];
             HQuery *hQuery = [[HQuery alloc] init];
             [hQuery postSpot:[spotData objectForKey:@"id"] withType:[socialView currentStatus] andMessage:[textView text] andPhoto:source andWidth:[[result objectForKey:@"width"] intValue] andHeight:[[result objectForKey:@"height"] intValue] withCallback:^(id JSON, NSError *error) {
                 if (error == nil)
                 {
                     NSLog(@"Received post:");
                     NSLog(@"%@", JSON);                     
                     UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle: @"Success"
                                           message: @"Your spot update has been posted!"
                                           delegate: nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                     [alert show];
                 }
                 else{
                     UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle: @"Error!"
                                           message: @"Unable to post update."
                                           delegate: nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                     [alert show];
                 }
                 [refreshSpinner stopAnimating];
                 self.scrollView.layer.opacity = 1.00;
             }];

             
         }
     }
     ];
    
    [connection start];
}

- (void)postOpenGraphActionWithPhotoURL:(NSString*)photoURL
{
    NSMutableDictionary<PF_FBGraphObject> *action = [PF_FBGraphObject graphObject];
    
    [action setObject:[NSString stringWithFormat:@"http://hurricane.gethugo.com/place/%@/%@", [spotData objectForKey:@"id"],[[spotData objectForKey:@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"_"]] forKey:@"photo"];

    [action setObject:[spotData objectForKey:@"id"] forKey:@"place"];
    
    [action setObject:[textView text] forKey:@"message"];

    if (photoURL) {
        NSMutableDictionary *image = [[NSMutableDictionary alloc] init];
        [image setObject:photoURL forKey:@"url"];
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        [images addObject:image];
        
        [action setObject:images forKey:@"image"];
    }
    
    // Create the request and post the action to the
    // "me/<YOUR_APP_NAMESPACE>:eat" path.
    [PF_FBRequestConnection startForPostWithGraphPath:@"me/hugo-app:add"
                                       graphObject:action
                                 completionHandler:
     ^(PF_FBRequestConnection *connection, id result, NSError *error) {
         NSString *alertText;
         if (!error) {
             alertText = [NSString stringWithFormat:
                          @"Posted Open Graph action, id: %@",
                          [result objectForKey:@"id"]];
         } else {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         }
         NSLog(@"result %@", error);
/*         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:nil
                           cancelButtonTitle:@"Thanks!"
                           otherButtonTitles:nil]
          show];*/
     }
     ];
}

- (void)savePost:(UIBarButtonItem*)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    [self postPhotoThenOpenGraphAction];
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
    
    self.socialView = [[HugoSocialView alloc] initWithFrame:CGRectMake(80, 15+_offset, 235, 55) andStatuses:nil andPlace:[spotData objectForKey:@"fb_place_id"] withDelegate:self];
    [socialView setTag:1];
    [self.scrollView addSubview:socialView];

    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 70.f, 280.0f, 95.0f)];
    
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
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        
        // In a real app, we would probably let the user
        // either pick an image or take one using the camera.
        // For sample purposes in the simulator, the camera is not available.
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentModalViewController:self.imagePicker
                                animated:true];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    self.selectedPhoto = image;
    
    [self dismissModalViewControllerAnimated:true];
    
    [self updatePhoto];
}

- (void)updatePhoto
{
    NSLog(@"has photo! %@", NSStringFromCGSize( self.selectedPhoto.size));
    
    if (self.imageView == nil)
    {
        self.imageView = [[UIImageView alloc] initWithImage:self.selectedPhoto];

        self.imageView.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.imageView.layer.borderWidth = 3.0f;
        self.imageView.layer.shadowOpacity = 0.3f;
        self.imageView.layer.shadowOffset = CGSizeMake(0,0.0);
        self.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.imageView.layer.shadowRadius = 3.0f;

        
        float scale = 320/self.selectedPhoto.size.width;
        UIButton *addPicture =  (UIButton*)[self.scrollView viewWithTag:100];
        [self.imageView setFrame:CGRectMake(0, addPicture.frame.origin.y, 320.0f, scale*self.selectedPhoto.size.height)];
        
        for (UIView *view in self.scrollView.subviews)
        {
            if (view.frame.origin.y >= self.imageView.frame.origin.y)
            {
                CGRect frame = view.frame;
                frame.origin.y += scale*self.selectedPhoto.size.height+10;
                [view setFrame:frame];
            }
        }
        _offset +=  scale*self.selectedPhoto.size.height+10;
        
        [self.scrollView addSubview:self.imageView];

        CGRect frame = self.scrollView.frame;
        frame.size.height = _offset+10;
        [self.scrollView setContentSize:frame.size];
    }
    else
    {
        [self.imageView setImage:self.selectedPhoto];
    }
    
    
    
    
}

- (void)toggleFB:(UIButton*)sender
{
    [sender setSelected:![sender isSelected]];
}



- (void)initButtons
{
    UIButton *btnAddPicture = [self buttonFromImage:@"assets/post/addPhoto.png" withHighlight:@"assets/post/addPhotoB.png" selector:@selector(addPhoto:) andFrame:CGRectMake(10.0f, _offset+10, 300.0f, 41.f)];
    btnAddPicture.tag = 100;
    
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
    
    [Flurry logEvent:@"hugo.view.spot"];

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
