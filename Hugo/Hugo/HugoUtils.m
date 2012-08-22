//
//  HugoUtils.m
//  Hugo
//
//  Created by Ryan Waliany on 8/21/12.
//  Copyright (c) 2012 Hugo. All rights reserved.
//

#import "HugoUtils.h"
#import "AFNetworking.h"

@implementation HugoUtils


+ (void)HAuthRequest:(NSString*)access_token andExpiration:(NSDate*)date
{
    // Query our web server
    NSLog(@"HAuthRequest: %@ %.0f", access_token, [date timeIntervalSince1970]);
    NSURL *url = [NSURL URLWithString:@"http://hurricane.gethugo.com/auth"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = [NSString stringWithFormat:@"fb_auth_key=%@&fb_expires=%.0f", access_token, [date timeIntervalSince1970]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[parameters UTF8String] length:strlen([parameters UTF8String])]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"HURRICANE: SUCCESS");
        NSLog(@"HURRICANE: %@ %@", response, JSON);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[JSON objectForKey:@"fb_auth_key"] forKey:@"fb_auth_key"];
        [defaults setObject:[JSON objectForKey:@"fb_expires"] forKey:@"fb_expires"];
        [defaults setObject:[JSON objectForKey:@"user_id"] forKey:@"hugo_id"];
        [defaults synchronize];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"HURRICANE: FAILURE");
        NSLog(@"HURRICANE: %@ %@ %@", error, response, JSON);
    }];
    
    NSLog(@"Starting POST to hurricane!");
    [operation start];
    
}


@end
