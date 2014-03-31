//
//  DBSalerListViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-30.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBSellerListViewController.h"
#import "DBViewController.h"

#import "DBSalerManager.h"

#import "DBUser.h"

@interface DBSellerListViewController ()

@end

@implementation DBSellerListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
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
    [[DBSalerManager sharedInstance] fetchAllSalersAtPage:0  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                DBUser *saler = [DBUser userWithProperties:dic];
                [self.datas addObject:saler];
            }
            [self.tableView reloadData];
        }
        
    } failure:nil];
}

- (void)showItemDetailAtIndexPath:(NSIndexPath *)indexPath
{
    DBUser *seller = [self.datas objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showSellerDetail" sender:seller];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *cellIdentifier = @"ListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        DBUser *saler = [self.datas objectAtIndex:indexPath.row];
        NSString *avator = saler.avatorUrl != nil ? saler.avatorUrl : @"avatar_placehold";
        UIImage *image = [UIImage imageNamed:avator];
        cell.imageView.image = image;
        cell.imageView.layer.cornerRadius = 5;
        cell.clipsToBounds = YES;
        cell.textLabel.text = saler.nickname;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", saler.signature, saler.address];
        
        return cell;
    }
    return nil;
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBViewController *vc = (DBViewController *)segue.destinationViewController;
    vc.passValue = sender;
}

@end
