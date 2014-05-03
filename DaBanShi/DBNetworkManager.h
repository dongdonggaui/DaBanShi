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

/**
 提交用户反馈到服务器
 @param feedback 反馈内容
 @param userId 用户ID
 @param email 用户邮箱
 @param udid 用户唯一标识
 @param successBlock 网络访问成功回调
 @param failureBloc 失败回调
 */
- (void)submitFeedback:(NSString *)feedback
                userId:(NSString *)userId
                 email:(NSString *)email
                  udid:(NSString *)udid
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

/**
 获取应用最新版本信息
 @param successBlock 网络访问成功回调
 @param failureBloc 失败回调
 */
- (void)fetchLatestAppVersionSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

@end
