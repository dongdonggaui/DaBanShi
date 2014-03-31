//
//  DBNetworkManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <MMProgressHUD.h>
#import <MBProgressHUD.h>
#import <OpenUDID.h>

#import "DBNetworkManager.h"
#import "DBAppDelegate.h"
#import "NSString+InputCheck.h"

static const NSString *kAPIBasePath = @"http://localhost/dabanshi/api";
static const NSString *kUserDefaultsKeyUDID = @"kUserDefaultsKeyUDID";

@interface DBNetworkManager ()

@property (nonatomic) BOOL showStatusChangeNotification;

@end

@implementation DBNetworkManager

@synthesize deviceUDID = _deviceUDID;

#pragma mark - Singleton Methods

+ (instancetype)sharedInstance
{
    static DBNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:(NSString *)kAPIBasePath]];
        }
    });
    
    return sharedManager;
}


#pragma mark - override

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(!self)
        return nil;
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    return self;
}

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [super getPath:path parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        } else {
            [self handleErrorResponse:operation error:error];
        }
    }];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [super postPath:path parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        } else {
            [self handleErrorResponse:operation error:error];
        }
    }];
}

- (void)putPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [super putPath:path parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        } else {
            [self handleErrorResponse:operation error:error];
        }
    }];
}

- (void)deletePath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [super deletePath:path parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        } else {
            [self handleErrorResponse:operation error:error];
        }
    }];
}


#pragma mark - public
- (void)setup
{
    // network
    __weak DBNetworkManager *safeSelf = self;
    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *networkStatus = nil;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = @"无网络连接";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = @"已连接wifi";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = @"通过2G/3G连接";
                break;
                
            default:
                networkStatus = @"网络状态未知";
                break;
        }
        
        if (!safeSelf.showStatusChangeNotification && status != AFNetworkReachabilityStatusNotReachable) {
            safeSelf.showStatusChangeNotification = YES;
            return;
        }
        safeSelf.showStatusChangeNotification = YES;
        
        DBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:appDelegate.window];
        hud.mode = MBProgressHUDModeText;
        hud.animationType = MBProgressHUDAnimationFade;
        hud.labelText = networkStatus;
        hud.removeFromSuperViewOnHide = YES;
        [appDelegate.window addSubview:hud];
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
        DLog(@"status --> %@, window --> %@", networkStatus, hud);
    }];
}

- (void)setUsername:(NSString *)username andPassword:(NSString *)password
{
    [self clearAuthorizationHeader];
    [self setAuthorizationHeaderWithUsername:username password:password];
}

- (void)setAccessToken:(NSString *)token
{
    [self clearAuthorizationHeader];
    [self setAuthorizationHeaderWithToken:token];
}

- (void)submitFeedback:(NSString *)feedback
                userId:(NSString *)userId
                 email:(NSString *)email
                  udid:(NSString *)udid
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSAssert(![feedback HLY_isNull], @"feedback couldn't be nil");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    if (feedback) {
        [params setObject:feedback forKey:@"content"];
    }
    if (userId) {
        [params setObject:userId forKey:@"user_id"];
    }
    if (email) {
        [params setObject:email forKey:@"email"];
    }
    if (udid) {
        [params setObject:udid forKey:@"udid"];
    }
    [self postPath:@"feedback" parameters:params success:successBlock failure:failureBlock];
}

- (void)fetchLatestAppVersionSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    [self getPath:@"appversion/iOS" parameters:nil success:successBlock failure:failureBlock];
}

#pragma mark - setters & geters
- (NSString *)deviceUDID
{
    _deviceUDID = [[NSUserDefaults standardUserDefaults] stringForKey:(NSString *)kUserDefaultsKeyUDID];
    if (!_deviceUDID) {
        _deviceUDID = [OpenUDID value];
        [[NSUserDefaults standardUserDefaults] setObject:_deviceUDID forKey:(NSString *)kUserDefaultsKeyUDID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return _deviceUDID;
}


#pragma mark - private

- (NSString *)errorMessageWithCode:(NSUInteger)errorCode
{
    NSString *errorMessage = @"服务器错误";
    if (1 == errorCode) {
        errorMessage = @"服务器配置错误";
    } else if (2 == errorCode) {
        errorMessage = @"缺少参数";
    } else if (3 == errorCode) {
        errorMessage = @"参数非法";
    } else if (4 == errorCode) {
        errorMessage = @"需提供文件大小";
    } else if (5 == errorCode) {
        errorMessage = @"文件过大";
    } else if (10 == errorCode) {
        errorMessage = @"无效的用户名";
    } else if (11 == errorCode) {
        errorMessage = @"无效的Email";
    } else if (12 == errorCode) {
        errorMessage = @"无效的电话号码";
    } else if (13 == errorCode) {
        errorMessage = @"无效的密码";
    } else if (14 == errorCode) {
        errorMessage = @"无效的城市名";
    } else if (15 == errorCode) {
        errorMessage = @"无效的用于ID";
    } else if (16 == errorCode) {
        errorMessage = @"用户名已存在";
    } else if (17 == errorCode) {
        errorMessage = @"Email已注册";
    } else if (18 == errorCode) {
        errorMessage = @"电话号码已注册";
    } else if (19 == errorCode) {
        errorMessage = @"此餐厅名已被注册";
    } else if (20 == errorCode) {
        errorMessage = @"此标签名已被注册";
    } else if (21 == errorCode) {
        errorMessage = @"此用户已被删除";
    } else if (22 == errorCode) {
        errorMessage = @"服务器内部错误";
    } else if (23 == errorCode) {
        errorMessage = @"无效的图片";
    } else if (24 == errorCode) {
        errorMessage = @"无效的图片格式";
    } else if (25 == errorCode) {
        errorMessage = @"上传图片高度必须大约720像素";
    } else if (26 == errorCode) {
        errorMessage = @"无效的图片ID";
    } else if (27 == errorCode) {
        errorMessage = @"该图片已被删除";
    } else if (28 == errorCode) {
        errorMessage = @"该连锁店名已存在";
    } else if (29 == errorCode) {
        errorMessage = @"此餐厅已存在";
    } else if (30 == errorCode) {
        errorMessage = @"无效的经纬度";
    } else if (31 == errorCode) {
        errorMessage = @"无效的餐厅ID";
    } else if (32 == errorCode) {
        errorMessage = @"无效的餐厅连锁店ID";
    } else if (33 == errorCode) {
        errorMessage = @"价格类型无效";
    } else if (34 == errorCode) {
        errorMessage = @"价格无效";
    } else if (35 == errorCode) {
        errorMessage = @"无效的菜品ID";
    } else if (36 == errorCode) {
        errorMessage = @"无效的评论";
    } else if (37 == errorCode) {
        errorMessage = @"无效的设备UDID";
    } else if (101 == errorCode) {
        errorMessage = @"无效的ApiKey";
    } else if (102 == errorCode) {
        errorMessage = @"无效的签名";
    } else if (103 == errorCode) {
        errorMessage = @"无效的Token";
    } else if (104 == errorCode) {
        errorMessage = @"ApiKey已失效";
    } else if (105 == errorCode) {
        errorMessage = @"ApiKey丢失";
    } else if (106 == errorCode) {
        errorMessage = @"ApiToken丢失";
    } else if (107 == errorCode) {
        errorMessage = @"用户名或密码错误";
    } else if (108 == errorCode) {
        errorMessage = @"ApiToken验证失败";
    } else if (201 == errorCode) {
        errorMessage = @"上传图片失败";
    }
    
    return errorMessage;
}

- (void)handleErrorResponse:(AFHTTPRequestOperation *)operation error:(NSError *)error
{
    [MMProgressHUD showWithStatus:@""];
    NSData *responseData = operation.responseData;
    if (responseData != nil) {
        NSError *error = nil;
        NSDictionary *resposneDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        if (error != nil) {
            [MMProgressHUD dismissWithError:@"服务器错误，请稍候再试"];
            return;
        }
        NSUInteger errorCode = [[resposneDic objectForKey:@"code"] integerValue];
        if (103 == errorCode) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kNetWorkNotificationInvalidToken object:nil];
            [MMProgressHUD dismiss];
            return;
        } else if (108 == errorCode) {
            [MMProgressHUD dismissWithError:@"登录已失效,请重新登录"];
            return;
        }
        NSString *errorMessage = [self errorMessageWithCode:errorCode];
        [MMProgressHUD dismissWithError:errorMessage];
        DLog(@"errorMessge : %@, userInfo : %@", operation.responseString, error.userInfo);
        return;
    }
    DLog(@"errorMessgate : %@, userInfo : %@", operation.responseString, error.userInfo);
    [MMProgressHUD dismissWithError:error.localizedDescription];
}

@end
