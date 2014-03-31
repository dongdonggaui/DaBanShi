//
//  DBUserManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBUserManager.h"
#import "DBAclManager.h"

#import "DBUser.h"

#import "NSString+InputCheck.h"

@implementation DBUserManager

+ (instancetype)sharedInstance
{
    static DBUserManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[self alloc] init];
        }
    });
    
    return sharedManager;
}

- (void)fetchUserInfoByUserId:(NSString *)userId
                      success:(void (^)(AFHTTPRequestOperation *operation, id respondObject))success
                       failed:(void (^)(AFHTTPRequestOperation *operation, NSError *))failed
{
    NSString *path = [NSString stringWithFormat:@"user/%@", userId];
    [[DBNetworkManager sharedInstance] getPath:path parameters:nil success:success failure:failed];
}

- (void)updateUserInfoWithUserId:(NSString *)userId
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSAssert(userId != nil, @"user id could not be nil");
    NSString *path = [NSString stringWithFormat:@"user/%@", userId];
    [[DBNetworkManager sharedInstance] putPath:path parameters:[[DBAclManager sharedInstance].loginCredential.user encodedUesr] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"response --> %@", responseObject);
        
        if (successBlock) {
            successBlock(operation, responseObject);
        }
    } failure:failureBlock];
}

- (void)updateUserInfoWithUserId:(NSString *)userId
                        nickname:(NSString *)nickName
                       avatorUrl:(NSString *)avatorUrl
                          gender:(NSNumber *)gender
                       signature:(NSString *)signature
                        birthday:(NSDate *)birthday
                            city:(NSString *)city
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSAssert(userId != nil, @"user id could not be nil");
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    
    if (nickName) {
        [params setObject:nickName forKey:@"nickname"];
    }
    
    if (avatorUrl) {
        [params setObject:avatorUrl forKey:@"avator_url"];
    }
    
    if (gender) {
        [params setObject:gender forKey:@"gender"];
    }
    
    if (signature) {
        [params setObject:signature forKey:@"signature"];
    }
    
    if (birthday) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd";
        [params setObject:[df stringFromDate:birthday] forKey:@"birthday"];
    }
    
    if (city) {
        [params setObject:city forKey:@"city"];
    }
    
    NSString *path = [NSString stringWithFormat:@"user/%@", userId];
    [[DBNetworkManager sharedInstance] putPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"response --> %@", responseObject);
        
        if (successBlock) {
            successBlock(operation, responseObject);
        }
    } failure:failureBlock];
}

- (void)uploadAvatarWithFormat:(NSString *)format
                          data:(NSData *)data
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
       withUploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block
{
    
}

@end
