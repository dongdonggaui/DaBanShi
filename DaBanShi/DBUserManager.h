//
//  DBUserManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-3-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBBusinessManager.h"

@interface DBUserManager : DBBusinessManager

+ (instancetype)sharedInstance;

- (void)fetchUserInfoByUserId:(NSString *)userId
                      success:(void (^)(AFHTTPRequestOperation *operation, id respondObject))success
                       failed:(void (^)(AFHTTPRequestOperation *operation, NSError *))failed;

- (void)updateUserInfoWithUserId:(NSString *)userId
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

- (void)updateUserInfoWithUserId:(NSString *)userId
                        nickname:(NSString *)nickName
                       avatorUrl:(NSString *)avatorUrl
                          gender:(NSNumber *)gender
                       signature:(NSString *)signature
                        birthday:(NSDate *)birthday
                            city:(NSString *)city
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

- (void)uploadAvatarWithFormat:(NSString *)format
                          data:(NSData *)data
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
       withUploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block;

@end
