//
//  HLYBirthdaySettingViewController.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-23.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import "HLYBirthdaySettingViewController.h"
#import "DBUser.h"

@interface HLYBirthdaySettingViewController ()

@end

@implementation HLYBirthdaySettingViewController

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
    self.title = @"生日";
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, HLYViewHeight - 216, self.view.width, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    if (self.user.birthday) {
        datePicker.date = self.user.birthday;
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


#pragma mark - private
- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    self.user.birthday = sender.date;
    [self.tableView reloadData];
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
    static NSString *cellIdentifier = @"birthdayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy年MM月dd日";
    cell.textLabel.text = [df stringFromDate:self.user.birthday];
    cell.textLabel.textAlignment = HLYTextAlignmentCenter;
    
    return cell;
}

@end
