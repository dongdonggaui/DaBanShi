//
//  DBAPNsManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-7.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    APNsSdkStatusStoped,
    APNsSdkStatusStarting,
    APNsSdkStatusStarted
} APNsSdkStatus;

@interface DBAPNsManager : NSObject

+ (instancetype)sharedInstance;
- (void)setupWithLaunchOptions:(NSDictionary *)launchOptions;
- (void)registerDeviceToken:(NSData *)deviceToken;
- (void)handleRegisterRemoteNotifationError:(NSError *)error;
- (void)handleDidReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
