//
//  DBCitySelectorViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBCitySelectorViewController.h"

const NSString *kDBNotificationCityDidChange = @"kDBNotificationCityDidChange";

@interface DBCitySelectorViewController ()
- (IBAction)cancelDidTapped:(id)sender;
- (IBAction)confirmDidTapped:(id)sender;

@end

@implementation DBCitySelectorViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return @"热门城市";
    } else if (1 == section) {
        return @"湖北省";
    } else {
        return @"台湾省";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CityListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *city = nil;
    if (indexPath.section == 0) {
        city = @"北京";
    } else if (indexPath.section == 1) {
        city = @"武汉";
    } else {
        city = @"台北";
    }
    cell.textLabel.text = city;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kDBNotificationCityDidChange object:cell.textLabel.text];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelDidTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)confirmDidTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
