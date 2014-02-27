//
//  DBUserManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBUserManager.h"
#import "DBAPIHTTPClient.h"

@interface DBUserManager ()

@end

@implementation DBUserManager

+ (instancetype)sharedInstance
{
    static DBUserManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedManager == nil) {
            sharedManager = [[DBUserManager alloc] init];
        }
    });
    
    return sharedManager;
}

- (void)fetchAllDaBanShiOnSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [[DBAPIHTTPClient sharedInstance] getPath:@"user" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

@end
