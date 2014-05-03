//
//  DBAclManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBAclManager.h"

#import "DBUser.h"

static NSString *kUserDefaultsKeyCredential = @"kUserDefaultsKeyCredential";

@implementation DBAclManager

@synthesize loginCredential = _loginCredential;

+ (instancetype)sharedInstance
{
    static DBAclManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[DBAclManager alloc] init];
        }
    });
    
    return sharedManager;
}


#pragma mark - public
#pragma mark - login
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:account, @"username", password, @"password", nil];
    __weak DBAclManager *safeSelf = self;
    [[DBNetworkManager sharedInstance] postPath:@"login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"response --> %@", responseObject);
        
        safeSelf.loginCredential = [DBCredential credentialFromDictionary:responseObject];
        DLog(@"credential = %@", safeSelf.loginCredential);
        
        if (success) {
            success(operation, responseObject);
        }
    } failure:failure];
}

#pragma mark - logout
- (void)logoutWithComplecation:(void (^)(void))complecation
{
    self.loginCredential = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyCredential]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsKeyCredential];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (complecation) {
        complecation();
    }
}


#pragma mark - signup
- (void)signupWithAccount:(NSString *)account
                 password:(NSString *)password
                 userType:(NSInteger)type
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:account, @"username", account, @"email", password, @"password", [NSNumber numberWithInteger:type], @"type", @"0", @"source", nil];
    __weak DBAclManager *safeSelf = self;
    [[DBNetworkManager sharedInstance] postPath:@"register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"response --> %@", responseObject);
        
        safeSelf.loginCredential = [DBCredential credentialFromDictionary:responseObject];
        DLog(@"credential = %@", safeSelf.loginCredential);
        
        if (success) {
            success(operation, responseObject);
        }
    } failure:failure];
}

- (void)thirdPartySignupWithUserId:(NSString *)userId
                       accessToken:(NSString *)accessToken
                          username:(NSString *)username
                          nickname:(NSString *)nickname
                            avator:(NSString *)avator
                       description:(NSString *)description
                          userType:(NSInteger)type
                          sourceId:(NSInteger)sourceId
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:6];
    if (userId) {
        [params setObject:userId forKey:@"user_id"];
    }
    if (accessToken) {
        [params setObject:accessToken forKey:@"access_token"];
    }
    if (username) {
        [params setObject:username forKey:@"username"];
    }
    if (nickname) {
        [params setObject:nickname forKey:@"nickname"];
    }
    if (avator) {
        [params setObject:avator forKey:@"avator"];
    }
    if (description) {
        [params setObject:description forKey:@"description"];
    }
    [params setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [params setObject:[NSNumber numberWithInteger:sourceId] forKey:@"source_id"];
    __weak DBAclManager *safeSelf = self;
    [[DBNetworkManager sharedInstance] postPath:@"register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"response --> %@", responseObject);
        
        safeSelf.loginCredential = [DBCredential credentialFromDictionary:responseObject];
        DLog(@"credential = %@", safeSelf.loginCredential);
        if (success) {
            success(operation, responseObject);
        }
    } failure:failure];
}


#pragma mark - setters & getters
- (DBCredential *)loginCredential
{
    if (!_loginCredential) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyCredential];
        if (data) {
            _loginCredential = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    
    return _loginCredential;
}

- (void)setLoginCredential:(DBCredential *)loginCredential
{
    if (loginCredential && _loginCredential != loginCredential) {
        _loginCredential = loginCredential;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_loginCredential];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsKeyCredential];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (!loginCredential) {
        _loginCredential = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsKeyCredential];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (BOOL)isAuthorized
{
    DLog(@"author = %@", self.loginCredential);
    return self.loginCredential != nil;
}

@end


@implementation DBCredential

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.expire = [aDecoder decodeObjectForKey:@"expire"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.expire forKey:@"expire"];
    [aCoder encodeObject:self.user forKey:@"user"];
}

+ (instancetype)credentialFromDictionary:(NSDictionary *)dictionary
{
    NSAssert(dictionary != nil, @"param dictionary must not be nil");
    DBCredential *credential = [[DBCredential alloc] init];
    credential.token = [dictionary objectForKey:@"token"];
    credential.expire = [dictionary objectForKey:@"expire_in"];
    credential.user = [DBUser userWithProperties:[dictionary objectForKey:@"user"]];
    
    return credential;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nClass: %@\ntoken = %@\nexpire = %@\nuser = %@\n", NSStringFromClass([self class]), self.token, self.expire, self.user];
}

@end
