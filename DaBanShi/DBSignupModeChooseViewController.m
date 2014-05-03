//
//  DBSignupModeChooseViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBSignupModeChooseViewController.h"
#import "DBViewController.h"

@interface DBSignupModeChooseViewController ()

@end

@implementation DBSignupModeChooseViewController

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
    self.title = @"用户注册";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBViewController *vc = (DBViewController *)segue.destinationViewController;
    vc.passValue = sender;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0 == section ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            cell.textLabel.text = @"手机号注册";
        } else {
            cell.textLabel.text = @"Email注册";
        }
    } else {
        if (0 == indexPath.row) {
            cell.textLabel.text = @"微信账号登陆";
        } else if (1 == indexPath.row) {
            cell.textLabel.text = @"QQ账号登陆";
        } else {
            cell.textLabel.text = @"微博账号登陆";
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - table view delgate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section && 1 == indexPath.row) {
        [self performSegueWithIdentifier:@"showEmailSignup" sender:self.passValue];
    }
}

@end
