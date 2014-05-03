//
//  DBFirmListViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-30.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBFirmListViewController.h"
#import "DBViewController.h"

#import "DBFirmManager.h"

#import "DBUser.h"

@interface DBFirmListViewController ()


@end

@implementation DBFirmListViewController

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
    [[DBFirmManager sharedInstance] fetchAllFirmsAtPage:0  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                DBUser *firm = [DBUser userWithProperties:dic];
                [self.datas addObject:firm];
            }
            [self.tableView reloadData];
        }
        
    } failure:nil];
}

- (void)showItemDetailAtIndexPath:(NSIndexPath *)indexPath
{
    DBUser *firm = [self.datas objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showFirmDetail" sender:firm];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.tableView) {
//        static NSString *cellIdentifier = @"ListCell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        }
//        DBUser *firm = [self.datas objectAtIndex:indexPath.row];
//        NSString *avator = firm.avatorUrl != nil ? firm.avatorUrl : @"avatar_placehold";
//        UIImage *image = [UIImage imageNamed:avator];
//        cell.imageView.image = image;
//        cell.imageView.layer.cornerRadius = 5;
//        cell.clipsToBounds = YES;
//        cell.textLabel.text = firm.nickname;
//        cell.detailTextLabel.numberOfLines = 0;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", firm.signature, firm.address];
//        
//        return cell;
//    }
//    return nil;
//}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBViewController *vc = (DBViewController *)segue.destinationViewController;
    vc.passValue = sender;
}

@end
