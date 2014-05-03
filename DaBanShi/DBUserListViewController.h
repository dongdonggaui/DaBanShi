//
//  DBListViewController.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBTableViewController.h"

@interface DBUserListViewController : DBTableViewController

@property (nonatomic, strong) NSMutableArray *datas;

- (void)fetchDatas;
- (void)showItemDetailAtIndexPath:(NSIndexPath *)indexPath;

@end
