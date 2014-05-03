//
//  DBBaiduPushManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-7.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <BPush.h>
#import "DBBaiduPushManager.h"

@interface DBBaiduPushManager () <BPushDelegate>

@end

@implementation DBBaiduPushManager

+ (instancetype)sharedInstance
{
    static DBBaiduPushManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[DBBaiduPushManager alloc] init];
        }
    });
    
    return sharedManager;
}

#pragma mark - public
- (void)setupWithLaunchOptions:(NSDictionary *)launchOptions
{
    [BPush setupChannel:launchOptions]; // 必须
    
    [BPush setDelegate:self]; // 必须。参数对象必须实现onMethod: response:方法，本示例中为self
    
    // [BPush setAccessToken:@"3.ad0c16fa2c6aa378f450f54adb08039.2592000.1367133742.282335-602025"];  // 可选。api key绑定时不需要，也可在其它时机调用
    
    // 注册APNS
    [self registerRemoteNotification];
    
    // 获取启动时收到的APN
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
        [BPush registerDeviceToken:deviceToken]; // 必须
        
        [BPush bindChannel]; // 必须。可以在其它时机调用，只有在该方法返回（通过onMethod:response:回调）绑定成功时，app才能接收到Push消息。一个app绑定成功至少一次即可（如果access token变更请重新绑定）。
    }
}

- (void)handleRegisterRemoteNotifationError:(NSError *)error
{
    
    DLog(@"register remote error --> %@", error.localizedDescription);
}

- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 处理APN
    [BPush handleNotification:userInfo]; // 可选
}

#pragma mark - private
- (void)registerRemoteNotification
{
	UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
}


#pragma mark - baidu push delegate
// 必须，如果正确调用了setDelegate，在bindChannel之后，结果在这个回调中返回。
// 若绑定失败，请进行重新绑定，确保至少绑定成功一次
- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        
        DLog(@"appid --> %@\nuserid --> %@\nchannelid --> %@\nreturnCode --> %d\nrequestid --> %@\n", appid, userid, channelid, returnCode, requestid);
    }
}

@end
