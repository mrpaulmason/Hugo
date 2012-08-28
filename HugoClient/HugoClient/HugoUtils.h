//
//  HugoUtils.h
//  Hugo
//
//  Created by Ryan Waliany on 8/21/12.
//  Copyright (c) 2012 Hugo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HugoUtils : NSObject

+ (void)HAuthRequest:(NSString*)access_token andExpiration:(NSDate*)date;

@end
