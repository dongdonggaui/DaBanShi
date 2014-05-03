//
//  DBAirshipManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-7.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBAirshipManager : NSObject

+ (instancetype)sharedInstance;

/**
 配置推送管理器，在应用启动时调用
 @params launchOptions 应用启动参数
 */
- (void)setupWithLaunchOptions:(NSDictionary *)launchOptions;

/**
 向苹果推送服务器注册设备
 @params deviceToken 苹果服务器返回的设备推送ID
 */
- (void)registerDeviceToken:(NSData *)deviceToken;

/**
 处理向苹果推送服务器注册设备失败回调
 @params error 错误信息实例
 */
- (void)handleRegisterRemoteNotifationError:(NSError *)error;

/**
 处理收到推送消息时的回调
 @params userInfo 收到的推送消息
 */
- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
