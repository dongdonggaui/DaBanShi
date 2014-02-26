//
//  DBBookStatusSettingViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBBookStatusSettingViewController.h"
#import "DBBookingManager.h"

@interface DBBookStatusSettingViewController ()

@property (nonatomic, strong) NSMutableArray *bookingList;

@end

@implementation DBBookStatusSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycles
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.refreshEnable = NO;
    self.title = @"预约状态设置";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setters & getters
- (NSMutableArray *)bookingList
{
    if (_bookingList == nil) {
        _bookingList = [[DBBookingManager sharedInstance] testBooking];
    }
    
    return _bookingList;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"bookingListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.bookingList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"timeInterval"];
    NSString *bookingStatus = [dic objectForKey:@"bookingStatus"];
    UISwitch *switchOnOff = [[UISwitch alloc] init];
    cell.accessoryView = switchOnOff;
    if ([bookingStatus isEqualToString:@"未预约"]) {
        switchOnOff.on = NO;
    } else {
        switchOnOff.on = YES;
    }
    
    return cell;
}

@end
