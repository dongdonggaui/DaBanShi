//
//  DBAPNsManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-7.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBAPNsManager.h"
#import "include/GexinSdk.h"

// development
#define kGetuiAppID @"qUdvcfzHzW7MS5O0710gD"
#define kGetuiAppKey @"svFWEwwAjmAcjzkULYxTu5"
#define kGetuiAppSecret @"LsxLfMAHmRA9oxeXrdU4K6"
#define kGetuiMasterSecret @"D70mRk365qAKCdZWuteLR1"

const NSString *kNotificationAPNsSDKError = @"kNotificationAPNsSDKError";

@interface DBAPNsManager () <GexinSdkDelegate>

@property (strong, nonatomic) GexinSdk *gexinPusher;
@property (assign, nonatomic) APNsSdkStatus sdkStatus;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *appSecret;
@property (strong, nonatomic) NSString *appID;
@property (strong, nonatomic) NSString *clientId;

@property (assign, nonatomic) int lastPayloadIndex;
@property (strong, nonatomic) NSString *payloadId;

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)testSdkFunction;
- (void)testSendMessage;

@end

@implementation DBAPNsManager

+ (instancetype)sharedInstance
{
    static DBAPNsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[DBAPNsManager alloc] init];
        }
    });
    
    return sharedManager;
}

#pragma mark - public
- (void)setupWithLaunchOptions:(NSDictionary *)launchOptions
{
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kGetuiAppID appKey:kGetuiAppKey appSecret:kGetuiAppSecret];
    [self.gexinPusher setTags:@[@"iOS"]];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    // [2-EXT]: 获取启动时收到的APN
    if (launchOptions) {
        NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (message) {
            NSString *payloadMsg = [message objectForKey:@"payload"];
            NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
            DLog(@"%@", record);
        }
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)registerDeviceToken:(NSData *)deviceToken
{
    if (deviceToken) {
        NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        DLog(@"deviceToken --> %@", token);
        [self.gexinPusher registerDeviceToken:token];
    }
}

- (void)handleRegisterRemoteNotifationError:(NSError *)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    if (self.gexinPusher) {
        [self.gexinPusher registerDeviceToken:@""];
    }
    
    DLog(@"register remote error --> %@", error.localizedDescription);
}

- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    DLog(@"did receive msg --> %@", record);
}

#pragma mark - private
- (void)registerRemoteNotification
{
	UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = APNsSdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:appID
                                             appKey:appKey
                                          appSecret:appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {
            [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kNotificationAPNsSDKError object:self userInfo:err.userInfo];
        } else {
            _sdkStatus = APNsSdkStatusStarting;
        }
    }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        
        _sdkStatus = APNsSdkStatusStoped;
        
        _clientId = nil;
    }
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];

        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [_gexinPusher registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [_gexinPusher setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [_gexinPusher sendMessage:body error:error];
}

- (void)testSdkFunction
{
    
}

- (void)testSendMessage
{
    
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = APNsSdkStatusStarted;
    _clientId = clientId;
    DLog(@"已注册 --> %@", clientId);
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    _payloadId = payloadId;
    
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPayloadIndex, [NSDate date], payloadMsg];
    DLog(@"did receive payload --> %@", record);
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    DLog(@"did send message --> %@", record);
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    DLog(@"apns error --> %@", [NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}


@end
