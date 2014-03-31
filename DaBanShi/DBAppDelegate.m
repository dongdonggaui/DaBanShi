//
//  DBAppDelegate.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//
#import <WeiboSDK.h>
#import <MMProgressHUD.h>
#import "DBAppDelegate.h"

#import "DBNetworkManager.h"
#import "DBAclManager.h"

#import "DBUser.h"

#import "UIColor+DaBanShi.h"
#import "NSDate+HLYDate.h"

@interface DBAppDelegate () <WeiboSDKDelegate, WBHttpRequestDelegate>

@property (nonatomic, strong) NSString *accessToken;

@end

@implementation DBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // network
    [[DBNetworkManager sharedInstance] setup];
    
    //
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    
    // Override point for customization after application launch.
    if (DBSystemVersion >= 7) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor softBlack]];
        [[UITabBar appearance] setBarTintColor:[UIColor softBlack]];
    } else {
        [[UINavigationBar appearance] setTintColor:[UIColor softGray]];
        [[UITabBar appearance] setTintColor:[UIColor softGray]];
    }
    UIImage *backButtonImage = [[UIImage imageNamed:@"nav_item_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 1)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -backButtonImage.size.height*3) forBarMetrics:UIBarMetricsDefault];
    
//    if (![[DBAclManager sharedInstance] isAuthorized]) {
        [self.window makeKeyAndVisible];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Authorization" bundle:nil];
        UIViewController *vc = [sb instantiateInitialViewController];
        [self.window.rootViewController presentViewController:vc animated:NO completion:nil];
//    }
    BOOL rect = [WeiboSDK registerApp:@"118076031"];
    [WeiboSDK enableDebugMode:YES];
    DLog(@"weibo sdk register --> %@", rect ? @"YES" : @"NO");
    

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
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark - weibo sdk delegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    DLog(@"did receive sina request --> %@", request);
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        WBAuthorizeResponse *authorizeResponse = (WBAuthorizeResponse *)response;
        
        switch (response.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess: {
                NSString *accessToken = authorizeResponse.accessToken;
                NSString *userId = authorizeResponse.userID;
                NSDate *expire = authorizeResponse.expirationDate;
                self.accessToken = accessToken;
                [WBHttpRequest requestWithAccessToken:accessToken url:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:@{@"uid": userId} delegate:self withTag:@"user_info"];
                DLog(@"sina token = %@, userId = %@, expire = %@", accessToken, userId, [NSDate HLY_displayDate:expire]);
                break;
            }
            case WeiboSDKResponseStatusCodeUserCancel:
                [MMProgressHUD show];
                [MMProgressHUD dismissWithError:@"用户取消授权"];
                break;
            case WeiboSDKResponseStatusCodeAuthDeny:
                [MMProgressHUD show];
                [MMProgressHUD dismissWithError:@"授权失败"];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - weibo request delegate
/**
 接收并处理来自微博sdk对于网络请求接口的调用响应 以及openAPI
 如inviteFriend、logOutWithToken的请求
 */
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    DLog(@"sina response --> %@", response)
}

/**
 收到一个来自微博Http请求失败的响应
 
 @param error 错误信息
 */
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    DLog(@"sina error --> %@", error);
}

/**
 收到一个来自微博Http请求的网络返回
 
 @param result 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    DLog(@"sina result --> %@", request);
}

/**
 收到一个来自微博Http请求的网络返回
 
 @param data 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    DLog(@"sina data --> %@", dic);
    DBUser *user = [[DBUser alloc] init];
    user.userId = [dic objectForKey:@"idstr"];
    user.username = [dic objectForKey:@"domain"];
    user.nickname = [dic objectForKey:@"name"];
    user.avatorUrl = [dic objectForKey:@"profile_image_url"];
    user.userDescription = [dic objectForKey:@"description"];
    [[DBAclManager sharedInstance] thirdPartySignupWithUserId:user.userId accessToken:self.accessToken username:user.username nickname:user.nickname avator:user.avatorUrl description:user.userDescription userType:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"third party register response --> %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"response --> %@, error --> %@", operation.responseString, error);
    }];
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
