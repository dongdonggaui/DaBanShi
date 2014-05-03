//
//  DBEmailSignupViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <MMProgressHUD.h>

#import "DBEmailSignupViewController.h"

#import "DBAclManager.h"

#import "NSString+InputCheck.h"

@interface DBEmailSignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DBEmailSignupViewController

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
    [self.submitButton addTarget:self action:@selector(submitButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // 去掉多余行
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private
- (void)submitButtonDidTapped:(UIButton *)sender
{
    if ([self.emailTextField.text HLY_isNull] || [self.passwordTextField.text HLY_isNull]) {
        return;
    }
    
    if (![self.emailTextField.text HLY_isValidateEmail]) {
        return;
    }
    
    if (![self.passwordTextField.text HLY_isValidateInput]) {
        return;
    }
    
    __weak DBEmailSignupViewController *safeSelf = self;
    [MMProgressHUD showWithStatus:@"请稍候..."];
    [[DBAclManager sharedInstance] signupWithAccount:self.emailTextField.text password:self.passwordTextField.text userType:[self.passValue integerValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MMProgressHUD dismissWithSuccess:@"注册成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [safeSelf dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"注册失败"];
        DLog("error --> %@", operation.responseString);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
