//
//  DBSettingsViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <MBProgressHUD.h>

#import "DBAppDelegate.h"
#import "DBSettingsViewController.h"
#import "DBAclManager.h"
#import "DBUser.h"

#import "UIImageView+Network.h"
#import "UIImage+Convenience.h"
#import "UIFont+HLY.h"

@interface DBSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBUser *user;
@property (nonatomic, strong) NSMutableArray *settingsMenu;
- (IBAction)logoutButtonDidTapped:(id)sender;

@end

@implementation DBSettingsViewController

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
    self.title = @"设置";
    self.refreshEnable = NO;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"SettingsProperties" withExtension:@"plist"];
    _settingsMenu = [NSMutableArray arrayWithContentsOfURL:url];
    
    self.user = [DBAclManager sharedInstance].loginCredential.user;
    
    __weak DBSettingsViewController *safeSelf = self;
    [[DBNetworkManager sharedInstance] fetchLatestAppVersionSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *version = [responseObject objectForKey:@"version"];
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
            if (version.floatValue > currentVersion.floatValue) {
                version = @"有新版本";
            }
            NSDictionary *versionDic = @{@"identifier": @"version", @"title": @"版本更新", @"detail": version};
            [safeSelf.settingsMenu addObject:[NSArray arrayWithObjects:versionDic, nil]];
            
            [self.tableView reloadData];
        }
    } failure:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)settingButtonDidTapped:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"showMyInfo" sender:nil];
}

- (IBAction)logoutButtonDidTapped:(id)sender {
    __weak DBSettingsViewController *safeSelf = self;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^{
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[DBAclManager sharedInstance] logoutWithComplecation:nil];
        });
    } completionBlock:^{
        [safeSelf presentLoginViewCompleted:nil];
        [hud removeFromSuperview];
    }];
}

#pragma mark - table vew data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingsMenu.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0 == section ? 1 : [[self.settingsMenu objectAtIndex:section - 1] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0 == indexPath.section ? 80 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (0 == indexPath.section) {
        UIImageView *avator = (UIImageView *)[cell.contentView viewWithTag:10];
        if (!avator) {
            avator = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
            avator.backgroundColor = [UIColor yellowColor];
            [cell.contentView addSubview:avator];
        }
        [avator HLY_loadNetworkImageAtPath:self.user.avatorUrl withPlaceholder:[UIImage HLY_defaultAvatar] errorImage:[UIImage HLY_errorImage] activityIndicator:nil];
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:11];
        if (!nameLabel) {
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avator.x + avator.width + 10, 20, cell.contentView.width - avator.x - avator.width - 10, 18)];
            nameLabel.font = [UIFont HLY_boldMediumFont];
            nameLabel.backgroundColor = [UIColor greenColor];
            [cell.contentView addSubview:nameLabel];
        }
        nameLabel.text = self.user.nickname;
        
        UILabel *loginNameLabel = (UILabel *)[cell.contentView viewWithTag:12];
        if (!loginNameLabel) {
            loginNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, nameLabel.y + nameLabel.height + 8, nameLabel.width, nameLabel.height)];
            loginNameLabel.font = [UIFont HLY_smallFont];
            [cell.contentView addSubview:loginNameLabel];
        }
        loginNameLabel.text = [NSString stringWithFormat:@"登录号:%@", self.user.username];
    } else {
        for (UIView *subView in cell.contentView.subviews) {
            if (subView.tag >= 10) {
                [subView removeFromSuperview];
            }
        }
        NSDictionary *settingIni = [[self.settingsMenu objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        cell.textLabel.text = [settingIni objectForKey:@"title"];
        if ([settingIni objectForKey:@"detail"]) {
            UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
            versionLabel.textAlignment = HLYTextAlignmentRight;
            versionLabel.text = [settingIni objectForKey:@"detail"];
            versionLabel.tag = 111;
            versionLabel.x = cell.contentView.width - versionLabel.width;
            versionLabel.y = ceilf((cell.contentView.height - versionLabel.height) / 2);
            [cell.contentView addSubview:versionLabel];
        }
    }
    
    return cell;
}


#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        [self performSegueWithIdentifier:@"showMyInfo" sender:nil];
    } else {
        NSDictionary *settingIni = [[self.settingsMenu objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        NSString *identifier = [settingIni objectForKey:@"identifier"];
        if ([identifier isEqualToString:@"booking"]) {
            [self performSegueWithIdentifier:@"showBookingStateSegue" sender:nil];
        } else if ([identifier isEqualToString:@"feedback"]) {
            [self performSegueWithIdentifier:@"showFeedback" sender:nil];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}


@end
