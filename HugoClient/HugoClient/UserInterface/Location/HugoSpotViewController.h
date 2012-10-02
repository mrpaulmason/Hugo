//
//  HugoSpotViewController.h
//  HugoClient
//
//  Created by Ryan Waliany on 10/1/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HugoSpotViewController : UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIScrollView *scrollView;
    NSMutableDictionary *spotData;
    int _offset;
}


@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController* imagePicker;
@property (strong, nonatomic) UIImage* selectedPhoto;

@property (nonatomic, retain) NSString *placeId;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *spotData;
@end
