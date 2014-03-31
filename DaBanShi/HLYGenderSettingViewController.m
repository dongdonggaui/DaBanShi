//
//  HLYGenderSettingViewController.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-23.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import "HLYGenderSettingViewController.h"
#import "DBUser.h"

@interface HLYGenderSettingViewController ()

@end

@implementation HLYGenderSettingViewController

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
    self.title = @"性别";
    if (self.passValue != nil && [self.passValue isKindOfClass:[DBUser class]]) {
        self.user = self.passValue;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override
- (void)dbsRightItemDidTapped:(id)sender
{
    [self updateUserInfo];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"nickCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (self.user != nil && self.user.gender.integerValue == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (0 == indexPath.row) {
        cell.textLabel.text = @"男";
    } else {
        cell.textLabel.text = @"女";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < 2; i++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    self.user.gender = [NSNumber numberWithInteger:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
