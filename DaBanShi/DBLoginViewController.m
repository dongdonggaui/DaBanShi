//
//  DBLoginViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <MBProgressHUD.h>
#import <WeiboSDK.h>

#import "DBLoginViewController.h"

#import "DBAclManager.h"

#import "NSString+InputCheck.h"

#define kRedirectURI    @"http://www.hiwedo.com"

@interface DBLoginViewController () <UITextFieldDelegate, WBHttpRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *sinaLoginButton;

- (IBAction)forgetPasswordDidTapped:(id)sender;
- (IBAction)registerDidTapped:(id)sender;
- (IBAction)loginButtonDidTapped:(id)sender;

@end

@implementation DBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.accountLabel.delegate = self;
    self.accountLabel.keyboardType = UIKeyboardTypeEmailAddress;
    self.accountLabel.returnKeyType = UIReturnKeyNext;
    self.accountLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordLabel.delegate = self;
    self.passwordLabel.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordLabel.secureTextEntry = YES;
    self.passwordLabel.returnKeyType = UIReturnKeyDone;
    self.passwordLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.sinaLoginButton addTarget:self action:@selector(sinaLoginButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)sinaLoginButtonDidTapped:(UIButton *)sender
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (IBAction)forgetPasswordDidTapped:(id)sender {
    
}

- (IBAction)registerDidTapped:(id)sender {
    
}

- (IBAction)loginButtonDidTapped:(id)sender {
    if ([self.accountLabel.text HLY_isNull] || ![self.accountLabel.text HLY_isValidateInput]) {
        return;
    }
    
    if ([self.passwordLabel.text HLY_isNull] || ![self.passwordLabel.text HLY_isValidateInput]) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak DBLoginViewController *safeSelf = self;
    [[DBAclManager sharedInstance] loginWithAccount:self.accountLabel.text password:self.passwordLabel.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:safeSelf.view animated:YES];

        double delayInSeconds = 0.8;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [safeSelf dismissViewControllerAnimated:YES completion:nil];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"errorCode : %ld, errorMessage : %@", operation.response.statusCode, operation.responseString);
        [MBProgressHUD hideAllHUDsForView:safeSelf.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", operation.responseString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}


#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountLabel) {
        [self.passwordLabel becomeFirstResponder];
    } else {
        [self loginButtonDidTapped:nil];
        [textField resignFirstResponder];
    }
    
    return YES;
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
    DLog(@"sina data --> %@", data);
}

@end
