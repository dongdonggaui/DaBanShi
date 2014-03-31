//
//  DBNetworkManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-3-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <AFNetworking.h>

@interface DBNetworkManager : AFHTTPClient

@property (nonatomic, strong, readonly) NSString *deviceUDID;

+ (instancetype)sharedInstance;
- (void)setup;
- (void)setUsername:(NSString *)username andPassword:(NSString *)password;
- (void)setAccessToken:(NSString *)token;

//
- (void)submitFeedback:(NSString *)feedback
                userId:(NSString *)userId
                 email:(NSString *)email
                  udid:(NSString *)udid
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

- (void)fetchLatestAppVersionSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

@end
