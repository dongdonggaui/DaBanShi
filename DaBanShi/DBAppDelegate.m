//
//  DBAppDelegate.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UMengAnalytics/MobClick.h>
#import <MMProgressHUD.h>
#import "DBAppDelegate.h"

#import "DBSocialManager.h"
#import "DBNetworkManager.h"
#import "DBAclManager.h"
//#import "DBAPNsManager.h"
#import "DBAirshipManager.h"
//#import "DBBaiduPushManager.h"

#import "DBUser.h"

#import "UIColor+DaBanShi.h"
#import "NSDate+HLYDate.h"

@interface DBAppDelegate ()


@end

@implementation DBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // network
    [[DBNetworkManager sharedInstance] setup];
    
    // HUD style
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    
    // social
    [[DBSocialManager sharedInstance] registerSocialComponents];
    
    // analytics
    [MobClick startWithAppkey:@"5342997a56240b5a2e1dfe36" reportPolicy:SEND_ON_EXIT channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    // Override point for customization after application launch.
    if (DBSystemVersion >= 7) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor softBlack]];
        [[UITabBar appearance] setBarTintColor:[UIColor softBlack]];
    } else {
        [[UINavigationBar appearance] setTintColor:[UIColor softGray]];
        [[UITabBar appearance] setTintColor:[UIColor softGray]];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    UIImage *backButtonImage = [[UIImage imageNamed:@"nav_item_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 1)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -backButtonImage.size.height*3) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]} forState:UIControlStateNormal];
    
    if (![[DBAclManager sharedInstance] isAuthorized]) {
        [self.window makeKeyAndVisible];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Authorization" bundle:nil];
        UIViewController *vc = [sb instantiateInitialViewController];
        [self.window.rootViewController presentViewController:vc animated:NO completion:nil];
    }
    
    // apns
//    [[DBAPNsManager sharedInstance] setupWithLaunchOptions:launchOptions];
    [[DBAirshipManager sharedInstance] setupWithLaunchOptions:launchOptions];
//    [[DBBaiduPushManager sharedInstance] setupWithLaunchOptions:launchOptions];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[DBSocialManager sharedInstance] handleOpenURL:url];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 向个推服务器注册deviceToken
//    [[DBAPNsManager sharedInstance] registerDeviceToken:deviceToken];
//    [[DBBaiduPushManager sharedInstance] registerDeviceToken:deviceToken];
    [[DBAirshipManager sharedInstance] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    [[DBAPNsManager sharedInstance] handleRegisterRemoteNotifationError:error];
//    [[DBBaiduPushManager sharedInstance] handleRegisterRemoteNotifationError:error];
    [[DBAirshipManager sharedInstance] handleRegisterRemoteNotifationError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    [[DBAPNsManager sharedInstance] handleDidReceiveRemoteNotification:userInfo];
//    [[DBBaiduPushManager sharedInstance] handleDidReceiveRemoteNotification:userInfo];
    [[DBAirshipManager sharedInstance] handleDidReceiveRemoteNotification:userInfo];
}


#pragma mark - 
- (void)switchToStoryboard:(NSString *)storyboardName
{
    NSAssert(storyboardName != nil, @"param storyboardName must not be nil");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    if (storyboard) {
        self.window.rootViewController = [storyboard instantiateInitialViewController];
    }
}

- (void)switchToAuhorizationView
{
    [self switchToStoryboard:@"Authorization"];
}

- (void)switchToMainView
{
    [self switchToStoryboard:@"Main"];
}



@end
