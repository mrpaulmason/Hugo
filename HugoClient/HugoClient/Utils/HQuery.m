//
//  HQuery.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/28/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HQuery.h"

@implementation HQuery

- (void)queryNewsfeed:(NSString*)prefix withCallback:(void (^)(id, NSError*))callback
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _completionHandler = [callback copy];
    
    NSURL *url = [NSURL URLWithString:@"http://hurricane.gethugo.com/news"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = [NSString stringWithFormat:@"hugo_id=%@&prefix=%@", [defaults objectForKey:@"hugo_id"], prefix];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[parameters UTF8String] length:strlen([parameters UTF8String])]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // Call completion handler.
        _completionHandler(JSON, nil);
        
        // Clean up.
        _completionHandler = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"HURRICANE: FAILURE");
        // Call completion handler.
        _completionHandler(JSON, error);
        
        // Clean up.
        _completionHandler = nil;
        
        
        NSLog(@"HURRICANE: %@", error);
    }];
    
    NSLog(@"Starting POST to hurricane! %@", parameters);
    [operation start];
    
}

- (void)queryCategories:(CLLocationCoordinate2D)location withCallback:(void (^)(id, NSError*))callback
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _completionHandler = [callback copy];
    
    NSURL *url = [NSURL URLWithString:@"http://hurricane.gethugo.com/places/categories"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = [NSString stringWithFormat:@"lat=%f&long=%f&hugo_id=%@", location.latitude, location.longitude, [defaults objectForKey:@"hugo_id"]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[parameters UTF8String] length:strlen([parameters UTF8String])]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // Call completion handler.
        _completionHandler(JSON, nil);
        
        // Clean up.
        _completionHandler = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"HURRICANE: FAILURE");
        // Call completion handler.
        _completionHandler(JSON, error);
        
        // Clean up.
        _completionHandler = nil;
        
        
        NSLog(@"HURRICANE: %@", error);
    }];
    
    NSLog(@"Starting POST to hurricane! %@", parameters);
    [operation start];
    
}

- (void)queryResults:(CLLocationCoordinate2D)location andCategory:(NSString*)category withCallback:(void (^)(id, NSError*))callback
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    _completionHandler = [callback copy];
    
    NSURL *url = [NSURL URLWithString:@"http://hurricane.gethugo.com/places"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = [NSString stringWithFormat:@"lat=%f&long=%f&hugo_id=%@&category=%@", location.latitude, location.longitude, [defaults objectForKey:@"hugo_id"], category];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[parameters UTF8String] length:strlen([parameters UTF8String])]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // Call completion handler.
        _completionHandler(JSON, nil);
        
        // Clean up.
        _completionHandler = nil;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"HURRICANE: FAILURE");
        // Call completion handler.
        _completionHandler(JSON, error);
        
        // Clean up.
        _completionHandler = nil;
        

        NSLog(@"HURRICANE: %@", error);
    }];
    
    NSLog(@"Starting POST to hurricane! %@", parameters);
    [operation start];
    
}

@end
