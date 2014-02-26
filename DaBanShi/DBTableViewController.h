//
//  DBTableViewController.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBTableViewController : UITableViewController

@property (nonatomic, weak) id passValue;
@property (nonatomic) BOOL refreshEnable;

- (void)refreshControlValueChanged:(UIRefreshControl *)sender;

@end
