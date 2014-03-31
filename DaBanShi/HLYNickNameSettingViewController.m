//
//  HLYNickNameSettingViewController.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-23.
//  Copyright (c) 2014年 whu. All rights reserved.
//
#import <MMProgressHUD.h>

#import "HLYNickNameSettingViewController.h"
#import "DBUser.h"

#import "DBUserManager.h"

#import "NSString+InputCheck.h"

@interface HLYNickNameSettingViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation HLYNickNameSettingViewController

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
    self.title = @"昵称";
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 12, 300, 20)];
    _textField.font = [UIFont systemFontOfSize:13];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (self.passValue != nil && [self.passValue isKindOfClass:[DBUser class]]) {
        self.user = self.passValue;
        _textField.text = self.user.nickname;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override
- (void)dbsRightItemDidTapped:(id)sender
{
    if ([self.textField.text HLY_isNull] || ![self.textField.text HLY_isValidateInput]) {
        [MMProgressHUD showWithStatus:nil];
        [MMProgressHUD dismissWithError:@"输入不合法"];
        return;
    }
    self.user.nickname = self.textField.text;
    [self updateUserInfo];
}

- (void)updateUserInfo
{
    [[DBUserManager sharedInstance] updateUserInfoWithUserId:self.user.userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD showWithStatus:@""];
        NSData *responseData = operation.responseData;
        if (responseData != nil) {
            NSError *error = nil;
            NSDictionary *resposneDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            if (error != nil) {
                [MMProgressHUD dismissWithError:@"服务器错误，请稍候再试"];
                return;
            }
            NSUInteger errorCode = [[resposneDic objectForKey:@"error_code"] integerValue];
            if (16 == errorCode) {
                [MMProgressHUD dismissWithError:@"名字已被占用"];
                return;
            }
        }
        DLog(@"errorMessgate : %@, userInfo : %@", operation.responseString, error.userInfo);
        [MMProgressHUD dismissWithError:@"服务器错误，请稍候再试"];
    }];
}


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"nickCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.contentView addSubview:self.textField];
    
    return cell;
}

@end
