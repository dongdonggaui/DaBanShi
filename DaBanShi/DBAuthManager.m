//
//  DBAuthManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBAuthManager.h"
#import "DBAPIHTTPClient.h"

static NSString *kUserDefaultsKeyCredential = @"kUserDefaultsKeyCredential";

@implementation DBAuthManager

+ (instancetype)sharedInstance
{
    static DBAuthManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedManager == nil) {
            sharedManager = [[DBAuthManager alloc] init];
        }
    });
    
    return sharedManager;
}

- (DBCredential *)loginCredential
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyCredential];
    if (data) {
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _loginCredential = [DBCredential credentialFromDictionary:dic];
    }
    
    return _loginCredential;
}

- (BOOL)isAuthorized
{
    DLog(@"author = %@", self.loginCredential);
    return self.loginCredential != nil;
}

- (void)saveCredential
{
    if (self.loginCredential) {
        NSDictionary *dic = [self.loginCredential dictionaryForm];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsKeyCredential];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)password success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:account, @"username", password, @"password", nil];
    __weak DBAuthManager *safeSelf = self;
    [[DBAPIHTTPClient sharedInstance] postPath:@"login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DLog(@"login response = %@", response);
        safeSelf.loginCredential = [DBCredential credentialFromDictionary:response];
        [safeSelf saveCredential];
        DLog(@"credential = %@", safeSelf.loginCredential);
        
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

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

- (void)testEnCoding
{
    DBUser *user = [[DBUser alloc] init];
    user.userId = @"test";
    user.username = @"username";
    user.avator = @"avator";
    user.userDescription = @"userDescription";
    user.nickname = @"nickname";
    
    DBCredential *cre = [[DBCredential alloc] init];
    cre.token = @"token";
    cre.expire = @"expire";
    cre.user = user;
    
    NSDictionary *dic = [cre dictionaryForm];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"testData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testDeCoding
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"testData"];
    DBCredential *cre = [DBCredential credentialFromDictionary:dic];
    NSLog(@"credential = %@", cre);
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
    [aCoder encodeObject:self.user forKey:@"uesr"];
}

+ (instancetype)credentialFromDictionary:(NSDictionary *)dictionary
{
    NSAssert(dictionary != nil, @"param dictionary must not be nil");
    DBCredential *credential = [[DBCredential alloc] init];
    credential.token = [dictionary objectForKey:@"token"];
    credential.expire = [dictionary objectForKey:@"expire_in"];
    
    NSDictionary *userDic = [dictionary objectForKey:@"user"];
    DBUser *user = [[DBUser alloc] init];
    user.userId = [userDic objectForKey:@"user_id"];
    user.username = [userDic objectForKey:@"username"];
    user.nickname = [userDic objectForKey:@"nickname"];
    user.avator = [userDic objectForKey:@"avator"];
    user.userDescription = [userDic objectForKey:@"description"];
    
    credential.user = user;
    
    return credential;
}

- (NSDictionary *)dictionaryForm
{
    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.user.userId, @"user_id",
                             self.user.username, @"username",
                             self.user.nickname, @"nickname",
                             self.user.avator, @"avator",
                             self.user.userDescription, @"description", nil];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.token, @"token",
            self.expire, @"expire",
            userDic, @"user", nil];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nClass: %@\ntoken = %@\nexpire = %@\nuser = %@\n", NSStringFromClass([self class]), self.token, self.expire, self.user];
}

@end
