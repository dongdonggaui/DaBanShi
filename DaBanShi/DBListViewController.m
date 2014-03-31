//
//  DBListViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBListViewController.h"

#import "DBUser.h"

extern const NSString *kDBNotificationCityDidChange;

@interface DBListViewController ()

- (IBAction)citySelectorDidTapped:(id)sender;

@end

@implementation DBListViewController

- (void)dealloc
{

}

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
    [self fetchDatas];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override
- (void)fetchDatas
{
    
}

- (void)showItemDetailAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - setters & getters
- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    
    return _datas;
}

#pragma mark - 
- (void)didReceiveCityChangeNotification:(NSNotification *)notifation
{
    self.navigationItem.leftBarButtonItem.title = notifation.object;
}

#pragma mark - table view data source & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.datas.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *cellIdentifier = @"ListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell) {
            DBUser *pm = [self.datas objectAtIndex:indexPath.row];
            NSString *avator = pm.avatorUrl != nil ? pm.avatorUrl : @"avatar_placehold";
            UIImage *image = [UIImage imageNamed:avator];
            cell.imageView.image = image;
            cell.imageView.layer.cornerRadius = 5;
            cell.clipsToBounds = YES;
            cell.textLabel.text = pm.nickname;
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"18627979166\n%@", pm.address];
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showItemDetailAtIndexPath:indexPath];
}

- (IBAction)citySelectorDidTapped:(id)sender {
    
}
@end
