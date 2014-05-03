//
//  DBTableViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

//#import <UMengAnalytics/MobClick.h>
#import "DBTableViewController.h"
#import "HLYTopIndicateView.h"

#import "UIColor+Convenience.h"

@interface DBTableViewController ()

@end

@implementation DBTableViewController

- (void)dealloc
{
    self.passValue = nil;
    self.topIndicateView = nil;
    self.dbsLeftBarButtonItem = nil;
    self.dbsRightBarButtonItem = nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // analytics
//    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // analytics
//    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

#pragma mark - override
- (void)setupViews
{
    if (HLYSystemVersion >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    self.view.backgroundColor = [UIColor HLY_mainBackgroundColor];
    HLYTopIndicateView *top = [HLYTopIndicateView topIndicateWithMessage:@"hello"];
    [self.navigationController.navigationBar addSubview:top];
    self.topIndicateView = top;
    if ([self needCustomLeftItem]) {
        self.navigationItem.leftBarButtonItem = self.dbsLeftBarButtonItem;
    }
    
    self.refreshEnable = YES;
}

- (void)dbsLeftItemDidTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dbsRightItemDidTapped:(id)sender
{
    
}

- (BOOL)needCustomLeftItem
{
    return NO;
}

- (void)presentLoginViewCompleted:(void (^)(void))completed
{
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Authorization" bundle:nil];
    UIViewController *vc = [loginStoryboard instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:^{
        if (completed != nil) {
            completed();
        }
    }];
}

- (void)refreshControlValueChanged:(UIRefreshControl *)sender
{
    if (sender.isRefreshing) {
        [sender endRefreshing];
    }
}


#pragma mark - public
- (DBAppDelegate *)appDelegate
{
    return (DBAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark - setters & getters
- (void)setRefreshEnable:(BOOL)refreshEnable
{
    if (refreshEnable != _refreshEnable) {
        _refreshEnable = refreshEnable;
        if (refreshEnable) {
            UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
            [refresh addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
            self.refreshControl = refresh;
        } else {
            self.refreshControl = nil;
        }
    }
}
- (UIBarButtonItem *)dbsLeftBarButtonItem
{
    if (_dbsLeftBarButtonItem == nil) {
        UIImage *image = [UIImage imageNamed:@"nav_item_back"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.width = image.size.width;
        button.height = image.size.height;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dbsLeftItemDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _dbsLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _dbsLeftBarButtonItem;
}

- (UIBarButtonItem *)dbsRightBarButtonItem
{
    if (_dbsRightBarButtonItem == nil) {
        UIImage *image = [UIImage imageNamed:@"nav_item_done"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.width = image.size.width;
        button.height = image.size.height;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dbsRightItemDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _dbsRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _dbsRightBarButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return nil;
}

@end
