//
//  DBFirmManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-30.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBFirmManager.h"

@implementation DBFirmManager

+ (instancetype)sharedInstance
{
    static DBFirmManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[self alloc] init];
        }
    });
    
    return sharedManager;
}


#pragma mark - public
- (void)fetchAllFirmsAtPage:(NSInteger)page
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self prepareHeaders];
    NSDictionary *params = @{@"page": [NSNumber numberWithInteger:page]};
    [[DBNetworkManager sharedInstance] getPath:@"firm/list" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"response --> %@", responseObject);
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error --> %@, userinfo --> %@", operation.responseString, error.localizedDescription);
    }];
}


#pragma mark - private
- (void)prepareHeaders
{
    [[DBNetworkManager sharedInstance] setAccessToken:@"123"];
}

@end
