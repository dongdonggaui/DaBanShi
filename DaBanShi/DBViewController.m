//
//  HLYViewController.m
//  MyWeChat
//
//  Created by 黄露洋 on 13-11-7.
//  Copyright (c) 2013年 黄露洋. All rights reserved.
//

#import <UMengAnalytics/MobClick.h>
#import "DBViewController.h"
#import "HLYTopIndicateView.h"

#import "UIColor+Convenience.h"

const NSString *kNotificationControllerDidPushed = @"kNotificationControllerDidPushed";

@interface DBViewController ()

@end

@implementation DBViewController

- (void)dealloc
{
    self.passValue = nil;
    self.topIndicateView = nil;
    self.dbsLeftBarButtonItem = nil;
    self.dbsRightBarButtonItem = nil;
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
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController != nil && [self.navigationController.viewControllers objectAtIndex:0] != self) {
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kNotificationControllerDidPushed object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"isRoot", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kNotificationControllerDidPushed object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"isRoot", nil]];
    }
    
    // analytics
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.topIndicateView showMessage:@"服务器错误，请稍候再试"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // analytics
    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setters & getters
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

- (DBAppDelegate *)appDelegate {
    return (DBAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (void)setupViews
{
    if (HLYSystemVersion >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor HLY_mainBackgroundColor];
    HLYTopIndicateView *top = [HLYTopIndicateView topIndicateWithMessage:@"hello"];
    [self.navigationController.navigationBar addSubview:top];
    self.topIndicateView = top;
    if ([self needCustomLeftItem]) {
        self.navigationItem.leftBarButtonItem = self.dbsLeftBarButtonItem;
    }
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
//    return self.navigationController != nil && [self.navigationController.viewControllers indexOfObject:self] != 0;
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

@end
