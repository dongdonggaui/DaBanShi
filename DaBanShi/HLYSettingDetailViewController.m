//
//  HLYSettingDetailViewController.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-23.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import "HLYSettingDetailViewController.h"

#import "DBUserManager.h"
#import "DBAclManager.h"

#import "DBUser.h"

@interface HLYSettingDetailViewController ()

@end

@implementation HLYSettingDetailViewController

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
    self.navigationItem.leftBarButtonItem = self.dbsLeftBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.dbsRightBarButtonItem;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HLYViewHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    
    self.user = [DBAclManager sharedInstance].loginCredential.user;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DLog(@"current user --> %@", [DBAclManager sharedInstance].loginCredential.user);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - public
- (void)updateUserInfo
{
    [[DBUserManager sharedInstance] updateUserInfoWithUserId:self.user.userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:nil];
    
}


#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
