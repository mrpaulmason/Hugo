//
//  HQuery.h
//  HugoClient
//
//  Created by Ryan Waliany on 8/28/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HQuery : NSObject
{
    void (^_completionHandler)(id, NSError*);
}

- (void)queryResults:(CLLocationCoordinate2D)location withCallback:(void (^)(id JSON, NSError* error))callback;
- (void)queryCategories:(CLLocationCoordinate2D)location withCallback:(void (^)(id, NSError*))callback;

@end
