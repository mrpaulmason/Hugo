//
//  AddressAnnotation.m
//  Hugo
//
//  Created by Ryan Waliany on 8/7/12.
//  Copyright (c) 2012 Hugo. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation

@synthesize coordinate, mSubTitle, mTitle;

- (NSString *)subtitle{
    return mSubTitle;
}

- (NSString *)title{
    return mTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c withTitle:(NSString*)title andSubtitle:(NSString*)subTitle
{
    self.mTitle = title;
    self.mSubTitle = subTitle;
    coordinate=c;
    NSLog(@"%f,%f",c.latitude,c.longitude);
    return self;
}
@end
