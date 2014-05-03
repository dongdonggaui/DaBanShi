//
//  DBHomeViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBHomeViewController.h"
#import "DBGridView.h"
#import "DBGridCellModel.h"

extern const NSString *kNotificationDidLoginNotification;

@interface DBHomeViewController () <DBGridViewDelegate>
- (IBAction)citySelectorDidTapped:(id)sender;

@end

@implementation DBHomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString *)kNotificationDidLoginNotification object:nil];
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
    
    DBGridCellModel *cellModel1 = [[DBGridCellModel alloc] init];
    cellModel1.cellType = DBGridCellTypeBig;
    cellModel1.cellTitle = @"推荐";
    cellModel1.cellDetail = @"服装圈精心推荐";
    cellModel1.imageName = @"cover_placeholder";
    DBGridCellModel *cellModel2 = [[DBGridCellModel alloc] init];
    cellModel2.cellType = DBGridCellTypeSamll;
    cellModel2.cellTitle = @"搜索";
    cellModel2.cellDetail = @"搜索在手 精彩由我";
    cellModel2.imageName = @"cover_placeholder";
    DBGridCellModel *cellModel3 = [[DBGridCellModel alloc] init];
    cellModel3.cellType = DBGridCellTypeBig;
    cellModel3.cellTitle = @"打版师榜单";
    cellModel3.cellDetail = @"最好口碑打版师";
    cellModel3.imageName = @"cover_placeholder";
    DBGridCellModel *cellModel4 = [[DBGridCellModel alloc] init];
    cellModel4.cellType = DBGridCellTypeBig;
    cellModel4.cellTitle = @"厂家榜单";
    cellModel4.cellDetail = @"最有实力厂家";
    cellModel4.imageName = @"cover_placeholder";
    DBGridCellModel *cellModel5 = [[DBGridCellModel alloc] init];
    cellModel5.cellType = DBGridCellTypeSamll;
    cellModel5.cellTitle = @"销售商榜单";
    cellModel5.cellDetail = @"最有实力销售商";
    cellModel5.imageName = @"cover_placeholder";
    DBGridView *gridView = [[DBGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) contents:[NSArray arrayWithObjects:cellModel1, cellModel2, cellModel3, cellModel4, cellModel5, nil]];
    gridView.gridDelegate = self;
    [self.view addSubview:gridView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDidLoginNotifcation:) name:(NSString *)kNotificationDidLoginNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notification
- (void)didReceiveDidLoginNotifcation:(NSNotification *)notifcation
{
    NSDictionary *userInfo = notifcation.userInfo;
    if (self.presentedViewController) {
        __weak DBHomeViewController *safeSelf= self;
        NSInteger delay = 0;
        if (userInfo && [userInfo objectForKey:@"delay"]) {
            delay = [[userInfo objectForKey:@"delay"] integerValue];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [safeSelf.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

#pragma mark - grid view delegate
- (void)gridView:(DBGridView *)gridView didTappedAtIndex:(NSInteger)index
{
    NSLog(@"index = %d", index);
    if (3 == index) {
        [self performSegueWithIdentifier:@"showFirmList" sender:nil];
    } else if (4 == index) {
        [self performSegueWithIdentifier:@"showSalerList" sender:nil];
    } else
        [self performSegueWithIdentifier:@"showDaBanShiList" sender:nil];
}

- (IBAction)citySelectorDidTapped:(id)sender {
    [self performSegueWithIdentifier:@"showCitySelectorSegue" sender:nil];
}

@end
