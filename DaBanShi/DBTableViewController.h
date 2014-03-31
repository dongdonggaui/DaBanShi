//
//  DBTableViewController.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBAppDelegate;
@class HLYTopIndicateView;
@interface DBTableViewController : UITableViewController

@property (nonatomic) BOOL refreshEnable;
@property (nonatomic, strong) HLYTopIndicateView *topIndicateView;
@property (nonatomic, strong) UIBarButtonItem *dbsLeftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *dbsRightBarButtonItem;
@property (nonatomic, strong) id passValue;

- (DBAppDelegate *)appDelegate;
- (NSUserDefaults *)userDefaults;
- (void)setupViews;
- (void)dbsLeftItemDidTapped:(id)sender;
- (void)dbsRightItemDidTapped:(id)sender;
- (BOOL)needCustomLeftItem;
- (void)presentLoginViewCompleted:(void(^)(void))completed;

// table view private
- (void)refreshControlValueChanged:(UIRefreshControl *)sender;

@end
