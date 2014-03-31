//
//  HLYSignatureSettingViewController.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-23.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import <MMProgressHUD.h>
#import "HLYSignatureSettingViewController.h"

#import "DBUser.h"

#import "NSString+InputCheck.h"

@interface HLYSignatureSettingViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation HLYSignatureSettingViewController

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
    self.title = @"个性签名";
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 130)];
    if (self.passValue != nil && [self.passValue isKindOfClass:[DBUser class]]) {
        self.user = self.passValue;
        _textView.text = self.user.signature;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override
- (void)dbsRightItemDidTapped:(id)sender
{
    if ([self.textView.text HLY_isNull] || ![self.textView.text HLY_isValidateInput]) {
        [MMProgressHUD showWithStatus:nil];
        [MMProgressHUD dismissWithError:@"输入不合法"];
        return;
    }
    self.user.signature = self.textView.text;
    [self updateUserInfo];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"signatureCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.contentView addSubview:self.textView];
    
    return cell;
}

@end
