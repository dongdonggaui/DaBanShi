//
//  DBAclManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-3-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBBusinessManager.h"

@class DBCredential;
@class DBUser;
@interface DBAclManager : DBBusinessManager

@property (nonatomic, strong) DBCredential *loginCredential;
@property (nonatomic) BOOL isAuthorized;

+ (instancetype)sharedInstance;

// login
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// logout
- (void)logoutWithComplecation:(void (^)(void))complecation;

// signup
- (void)signupWithAccount:(NSString *)account
                 password:(NSString *)password
                 userType:(NSInteger)type
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
// third party signup
- (void)thirdPartySignupWithUserId:(NSString *)userId
                       accessToken:(NSString *)accessToken
                username:(NSString *)username
                nickname:(NSString *)nickname
                  avator:(NSString *)avator
             description:(NSString *)description
                userType:(NSInteger)type
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end


@interface DBCredential : NSObject <NSCoding>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *expire;
@property (nonatomic, strong) DBUser *user;

+ (instancetype)credentialFromDictionary:(NSDictionary *)dictionary;

@end
