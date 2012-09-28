//
//  HQuery.m
//  HugoClient
//
//  Created by Ryan Waliany on 8/28/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HQuery.h"

@implementation HQuery

// curl -G -d "fb_post_id=820088508928" http://localhost:8888/comments
// curl -d "fb_auth_key=BAAGqkpC1J78BAIVJZAZBrx0n4X3tlxcLZCqyZBB370n6xpoSk1mLQgZA4vHes6xuhwwxkxklHfaeqx5FNrDMMNLOfgZAmXhfDcP2DfChVIDsLSGJsA271TtXqyAKedd30yqtuFo51RwZDZD&fb_expires=future&comment_type=chat&comment_message=this%20is%20a%20test&fb_post_id=820088508928" http://localhost:8888/comments

- (void)postComment:(id)post_id withType:(NSString*)type andMessage:(NSString*)message withCallback:(void (^)(id, NSError*))callback
{
    _completionHandler = [callback copy];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults objectForKey:@"fb_auth_key"];
    NSNumber *date = [defaults objectForKey:@"fb_expires"];
    NSURL *url = [NSURL URLWithString:@"http://hurricane.gethugo.com/comments"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = [NSString stringWithFormat:@"fb_auth_key=%@&fb_expires=%@&fb_post_id=%@&comment_type=%@&comment_message=%@",access_token, date, post_id, type, message];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[parameters UTF8String] length:strlen([parameters UTF8String])]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // Call completion handler.        
        NSLog(@"HURRICANE: %@", JSON);
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

- (void)queryComments:(id)post_id withCallback:(void (^)(id, NSError*))callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hurricane.gethugo.com/comments?fb_post_id=%@",post_id]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    _completionHandler = [callback copy];

    [request setHTTPMethod:@"GET"];
    
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

    
    [operation start];
}

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

- (void)queryResults:(CLLocationCoordinate2D)location andCategory:(NSString*)category andPlace:(NSString*)place withCallback:(void (^)(id, NSError*))callback
{
    [self queryResults:location andCategory:category andPrecision:6 andPlace:place withCallback:callback];
}

- (void)queryResults:(CLLocationCoordinate2D)location andCategory:(NSString*)category andPrecision:(int)precision andPlace:(NSString*)place withCallback:(void (^)(id, NSError*))callback
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    _completionHandler = [callback copy];
    
    NSURL *url = [NSURL URLWithString:@"http://hurricane.gethugo.com/places"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters;
    
    if (place == nil)
        parameters = [NSString stringWithFormat:@"lat=%f&long=%f&hugo_id=%@&category=%@&precision=%d", location.latitude, location.longitude, [defaults objectForKey:@"hugo_id"], category, precision];
    else
        parameters = [NSString stringWithFormat:@"lat=%f&long=%f&hugo_id=%@&category=%@&fb_place_id=%@&precision=%d", location.latitude, location.longitude, [defaults objectForKey:@"hugo_id"], category, place, precision];
    
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
