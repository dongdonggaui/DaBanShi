//
//  HLYSettingDetailViewController.h
//  Haoweidao
//
//  Created by huangluyang on 14-3-23.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import "DBViewController.h"

@class DBUser;
@interface HLYSettingDetailViewController : DBViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) DBUser *user;

- (void)updateUserInfo;

@end
