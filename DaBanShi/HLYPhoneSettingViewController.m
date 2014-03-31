//
//  HLYPhoneSettingViewController.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-23.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import "HLYPhoneSettingViewController.h"

@interface HLYPhoneSettingViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation HLYPhoneSettingViewController

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
    self.title = @"电话";
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 18)];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.text = self.passValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *cellIdentifier = @"phoneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    self.textField.center = cell.contentView.center;
    [cell.contentView addSubview:self.textField];
    
    return cell;
}

@end
