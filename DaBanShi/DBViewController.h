//
//  HLYViewController.h
//  MyWeChat
//
//  Created by 黄露洋 on 13-11-7.
//  Copyright (c) 2013年 黄露洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBAppDelegate;
@class HLYTopIndicateView;
@interface DBViewController : UIViewController

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

@end
