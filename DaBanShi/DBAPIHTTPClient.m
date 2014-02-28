//
//  DBAPIHTTPClient.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBAPIHTTPClient.h"

static NSString *kAPIBasePath = @"http://localhost/dabanshiserver/api";

@implementation DBAPIHTTPClient

+ (instancetype)sharedInstance
{
    static DBAPIHTTPClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedClient == nil) {
            NSURL *baseUrl = [NSURL URLWithString:kAPIBasePath];
            sharedClient = [DBAPIHTTPClient clientWithBaseURL:baseUrl];
        }
    });
    
    return sharedClient;
}

@end
