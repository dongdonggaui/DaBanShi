//
//  DBSettingsViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBSettingsViewController.h"
#import "DBAuthManager.h"
#import <MBProgressHUD.h>

@interface DBSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *settingsMenu;
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
    _settingsMenu = [NSArray arrayWithContentsOfURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table vew data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingsMenu.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.settingsMenu objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell) {
        NSDictionary *settingIni = [[self.settingsMenu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = [settingIni objectForKey:@"title"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *settingIni = [[self.settingsMenu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([[settingIni objectForKey:@"identifier"] isEqualToString:@"booking"]) {
        [self performSegueWithIdentifier:@"showBookingStateSegue" sender:nil];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
            [[DBAuthManager sharedInstance] logoutWithComplecation:nil];
        });
    } completionBlock:^{
        [safeSelf.appDelegate switchToAuhorizationView];
        [hud hide:YES];
    }];
}

@end
