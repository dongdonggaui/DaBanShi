//
//  DBSettingsViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBSettingsViewController.h"

@interface DBSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *settingsMenu;

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

@end
