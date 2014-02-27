//
//  DBAuthManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBUser.h"
#import <AFNetworking.h>

@class DBCredential;
@interface DBAuthManager : NSObject

@property (nonatomic, strong) DBCredential *loginCredential;
@property (nonatomic) BOOL isAuthorized;

+ (instancetype)sharedInstance;

- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)logoutWithComplecation:(void (^)(void))complecation;

- (void)testEnCoding;
- (void)testDeCoding;

@end


@interface DBCredential : NSObject <NSCoding>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *expire;
@property (nonatomic, strong) DBUser *user;

+ (instancetype)credentialFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryForm;

@end