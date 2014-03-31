//
//  DBPatternMakerListViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-30.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBPatternMakerListViewController.h"

#import "DBPatternMakerManager.h"

#import "DBUser.h"

@interface DBPatternMakerListViewController ()

@end

@implementation DBPatternMakerListViewController

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

#pragma mark - override
- (void)fetchDatas
{
    [[DBPatternMakerManager sharedInstance] fetchAllDanbanshiAtPage:0  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                DBUser *pm = [DBUser userWithProperties:dic];
                [self.datas addObject:pm];
            }
            [self.tableView reloadData];
        }
        
    } failure:nil];
}

- (void)showItemDetailAtIndexPath:(NSIndexPath *)indexPath
{
    DBUser *patterMaker = [self.datas objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDaBanShiDetailSegue" sender:patterMaker];
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
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", pm.signature, pm.address];
        }
        
        return cell;
    }
    return nil;
}


@end
