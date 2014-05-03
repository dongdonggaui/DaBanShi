//
//  DBIMListViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBIMListViewController.h"
#import "DBSimpleCell.h"

#import "DBLatestContactManager.h"

#import "DBUser.h"
#import "DBLatestContactModel.h"

@interface DBIMListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DBIMListViewController

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
    self.title = @"聊天";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [[DBLatestContactManager sharedInstance] fetchLatestList];
    
    // test
    if (0 == [DBLatestContactManager sharedInstance].latestContactList.count) {
        DBUser *user = [DBUser userWithProperties:@{@"nickname": @"lisi"}];
        DBLatestContactModel *msg0 = [DBLatestContactModel instanceWithContent:@"test0" createTime:[NSDate date] user:user];
        DBLatestContactModel *msg1 = [DBLatestContactModel instanceWithContent:@"test1" createTime:[NSDate date] user:user];
        DBLatestContactModel *msg2 = [DBLatestContactModel instanceWithContent:@"test2" createTime:[NSDate date] user:user];
        [[DBLatestContactManager sharedInstance].latestContactList addObject:msg0];
        [[DBLatestContactManager sharedInstance].latestContactList addObject:msg1];
        [[DBLatestContactManager sharedInstance].latestContactList addObject:msg2];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[DBLatestContactManager sharedInstance] updateLatestList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DBLatestContactManager sharedInstance].latestContactList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"latestContactCell";
    DBSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DBSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    DBLatestContactModel *contact = [[DBLatestContactManager sharedInstance].latestContactList objectAtIndex:indexPath.row];
    [cell configureWithImagePath:contact.user.avatorUrl title:contact.user.nickname content:contact.content time:contact.createTime];
    
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showIMDetail" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

@end
