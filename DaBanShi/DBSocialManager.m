//
//  DBSocialManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-3.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <MMProgressHUD.h>
#import <WeiboSDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "DBViewController.h"
#import "DBSocialManager.h"
#import "DBAclManager.h"
#import "DBUser.h"
#import "NSDate+HLYDate.h"

#define kUMengAppKey        @"5342997a56240b5a2e1dfe36"

#define kWeChatAppID        @"wx8c67f6e9cdbcd4cb"
#define kWeChatAppSecret    @"e5399ad3a1310e674f8103ca390897cd"

#define kQQAppID            @"101051023"
#define kQQAppSecret        @"bba0ed716b4c3ef9e35ee3c199f3f426"

#define kSinaAppID          @"118076031"
#define kSinaRedirectURI    @"http://www.hiwedo.com"


static const NSString *kNotificationSocialUserCancel = @"kNotificationSocialUserCancel";

const NSString *kNotificationDidLoginNotification = @"kNotificationDidLoginNotification";

@interface HLYSocialAuthViewController : DBViewController <UIWebViewDelegate>

@property (nonatomic, strong, readonly) UIWebView *webView;

- (void)loadRequest:(NSURLRequest *)request;

@end


@implementation HLYSocialAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = item;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HLYViewHeight)];
    _webView.delegate = self;
    self.view = _webView;
}

- (void)loadRequest:(NSURLRequest *)request
{
    [self.webView loadRequest:request];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DLog(@"request --> %@", request);
    NSString *absoluteString = request.URL.absoluteString;
    if (absoluteString && [absoluteString rangeOfString:@"usercancel"].length > 0) {
        NSRange userCancelRage = [absoluteString rangeOfString:@"usercancel"];
        NSString *userCancelString = [absoluteString substringWithRange:NSMakeRange(userCancelRage.location + userCancelRage.length + 1, 1)];
        BOOL userCancel = userCancelString.boolValue;
        DLog(@"usercancel string --> %@", userCancelString);
        if (userCancel) {
            [self dismissViewControllerAnimated:YES completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showWithStatus:nil];
                    [MMProgressHUD dismissWithError:@"用户取消授权"];
                });
            }];
        }
    } else if ([absoluteString rangeOfString:@"vdata"].length > 0) {
        NSRange vdataRange = [absoluteString rangeOfString:@"vdata"];
        NSString *vdataString = [absoluteString substringFromIndex:vdataRange.location + vdataRange.length + 1];
        
    }
    return YES;
}

@end


@interface DBSocialManager () <WeiboSDKDelegate, WBHttpRequestDelegate, TencentSessionDelegate>

@property (nonatomic, strong) NSString *sinaAccessToken;

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation DBSocialManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString *)kNotificationSocialUserCancel object:nil];
}

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSocialUserCancelNotification:) name:(NSString *)kNotificationSocialUserCancel object:nil];
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static DBSocialManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[DBSocialManager alloc] init];
        }
    });
    
    return sharedManager;
}


#pragma mark - public
- (void)registerSocialComponents
{
    // sina weibo
    BOOL rect = [WeiboSDK registerApp:kSinaAppID];
    [WeiboSDK enableDebugMode:YES];
    DLog(@"weibo sdk register --> %@", rect ? @"YES" : @"NO");
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    [MMProgressHUD showWithStatus:@"请稍候..."];
    NSString *absoluteString = url.absoluteString;
    DLog(@"url --> %@", absoluteString);
    if ([absoluteString hasPrefix:@"wb118076031"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else if ([absoluteString hasPrefix:@"tencent101051023"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else
        return NO;
}


- (void)loginWithType:(DBSocialType)type
{
    if (type == DBSocialTypeSina) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kSinaRedirectURI;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    } else if (type == DBSocialTypeQQ) {
        
//        if ([TencentOAuth iphoneQQInstalled] && [TencentOAuth iphoneQQSupportSSOLogin]) {
        
            [self.tencentOAuth authorize:[NSArray arrayWithObjects:
                                          kOPEN_PERMISSION_GET_USER_INFO,
                                          kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                          kOPEN_PERMISSION_ADD_PIC_T,
                                          kOPEN_PERMISSION_ADD_SHARE,
                                          kOPEN_PERMISSION_GET_INFO,
                                          kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                                          nil]];
//        } else {
//            
//            HLYSocialAuthViewController *vc = [[HLYSocialAuthViewController alloc] init];
//            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
//            NSString *scope = @"get_user_info,list_album,upload_pic,do_like";
//            scope = [scope stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.z.qq.com/moc2/authorize?response_type=token&client_id=101051023&scope=caonima&state=%@&g_ut=1", scope]]];
//            NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://graph.z.qq.com/moc2/authorize"]];
//            mRequest.HTTPMethod = @"GET";
//            NSDictionary *parameters = @{@"response_type": @"token",
//                                         @"client_id": @"101051023",
//                                         @"scope": @"get_user_info,list_album,upload_pic,do_like",
//                                         @"state": @"1",
//                                         @"g_ut": [NSNumber numberWithInteger:1]};
//            NSURL *url = [NSURL URLWithString:[mRequest.URL.absoluteString stringByAppendingFormat:[@"" rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", AFQueryStringFromParametersWithEncoding(parameters, NSUTF8StringEncoding)]];
//            [mRequest setURL:url];
//            
//            __weak HLYSocialAuthViewController *safeVc = vc;
//            [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:nc animated:YES completion:^{
//                [safeVc loadRequest:mRequest];
//            }];
//        }
    }
}

- (void)cancelAuthWithType:(DBSocialType)type
{
    if (type == DBSocialTypeQQ) {
        [self.tencentOAuth logout:self];
    }
}

#pragma mark - private
- (void)didReceiveSocialUserCancelNotification:(NSNotification *)notification
{
    
}

#pragma mark - setters & getters
- (TencentOAuth *)tencentOAuth
{
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppID andDelegate:self];
    }
    
    return _tencentOAuth;
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
    user.type = [NSNumber numberWithInteger:self.actorIdentifier];
    if (0 == self.actorIdentifier) {
        [MMProgressHUD showWithStatus:nil];
        [MMProgressHUD dismissWithError:@"请选择身份"];
        return;
    }
    [[DBAclManager sharedInstance] thirdPartySignupWithUserId:user.userId accessToken:self.sinaAccessToken username:user.username nickname:user.nickname avator:user.avatorUrl description:user.userDescription userType:self.actorIdentifier sourceId:1 success:nil failure:nil];
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
                self.sinaAccessToken = accessToken;
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

#pragma mark - qq
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length]) {
        // 记录登录用户的OpenID、Token以及过期时间
        if ([self.tencentOAuth getUserInfo]) {
            
        } else {
            [MMProgressHUD showWithStatus:nil];
            [MMProgressHUD dismissWithError:@"用户未授权，请重新授权"];
        }
    } else {
        
    }
}

- (void)tencentDidLogout
{
    DLog(@"tencent did logout");
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [MMProgressHUD showWithStatus:nil];
    if (cancelled) {
        [MMProgressHUD dismissWithError:@"用户取消登录"];
    }
    else {
        [MMProgressHUD dismissWithError:@"登录失败"];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    [MMProgressHUD showWithStatus:nil];
    [MMProgressHUD dismissWithError:@"网络不可用"];
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    DLog(@"qq data --> %@", response.jsonResponse);
    NSString *ret = [response.jsonResponse objectForKey:@"ret"];
    if (ret.integerValue != 0) {
        [MMProgressHUD showWithStatus:nil];
        [MMProgressHUD dismissWithError:@"用户未授权,获取信息失败"];
        return;
    }
    DBUser *user = [[DBUser alloc] init];
    user.userId = self.tencentOAuth.openId;
    user.username = self.tencentOAuth.openId;
    user.nickname = [response.jsonResponse objectForKey:@"nickname"];
    user.avatorUrl = [response.jsonResponse objectForKey:@"figureurl_qq_1"];
    user.type = [NSNumber numberWithInteger:self.actorIdentifier];
    user.sourceId = [NSNumber numberWithInteger:2];
    if (0 == self.actorIdentifier) {
        [MMProgressHUD showWithStatus:nil];
        [MMProgressHUD dismissWithError:@"请选择身份"];
        return;
    }
    [[DBAclManager sharedInstance] thirdPartySignupWithUserId:user.userId accessToken:self.tencentOAuth.accessToken username:user.username nickname:user.nickname avator:user.avatorUrl description:user.userDescription userType:self.actorIdentifier sourceId:user.sourceId.integerValue success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MMProgressHUD showWithStatus:nil];
            [MMProgressHUD dismissWithSuccess:@"登录成功" title:nil afterDelay:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kNotificationDidLoginNotification object:nil userInfo:@{@"delay": @"1"}];
            
        });
    } failure:nil];
    
}

@end
