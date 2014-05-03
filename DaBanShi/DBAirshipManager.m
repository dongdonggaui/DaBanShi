//
//  DBAirshipManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-7.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UAConfig.h>
#import <UAirship.h>
#import <UAPush.h>
#import "DBAirshipManager.h"

@implementation DBAirshipManager

+ (instancetype)sharedInstance
{
    static DBAirshipManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[DBAirshipManager alloc] init];
        }
    });
    
    return sharedManager;
}

#pragma mark - public
- (void)setupWithLaunchOptions:(NSDictionary *)launchOptions
{
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can also programmatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    // [2]:注册APNS
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert |
                                         UIRemoteNotificationTypeNewsstandContentAvailability);
    
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
        
    }
}

- (void)handleRegisterRemoteNotifationError:(NSError *)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    
    
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

@end
