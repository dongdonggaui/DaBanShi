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

@interface DBHomeViewController () <DBGridViewDelegate>
- (IBAction)citySelectorDidTapped:(id)sender;

@end

@implementation DBHomeViewController

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
    cellModel1.cellDetail = @"xxxxxxxx";
    cellModel1.imageName = @"cover_placeholder";
    DBGridCellModel *cellModel2 = [[DBGridCellModel alloc] init];
    cellModel2.cellType = DBGridCellTypeSamll;
    cellModel2.cellTitle = @"榜单";
    cellModel2.cellDetail = @"xxxxxxxx";
    cellModel2.imageName = @"cover_placeholder";
    DBGridCellModel *cellModel3 = [[DBGridCellModel alloc] init];
    cellModel3.cellType = DBGridCellTypeBig;
    cellModel3.cellTitle = @"搜索";
    cellModel3.cellDetail = @"xxxxxxxx";
    cellModel3.imageName = @"cover_placeholder";
    DBGridCellModel *cellModel4 = [[DBGridCellModel alloc] init];
    cellModel4.cellType = DBGridCellTypeBig;
    cellModel4.cellTitle = @"厂家";
    cellModel4.cellDetail = @"最有实力厂家";
    cellModel4.imageName = @"cover_placeholder";
    DBGridCellModel *cellModel5 = [[DBGridCellModel alloc] init];
    cellModel5.cellType = DBGridCellTypeSamll;
    cellModel5.cellTitle = @"销售商";
    cellModel5.cellDetail = @"最有实力销售商";
    cellModel5.imageName = @"cover_placeholder";
    DBGridView *gridView = [[DBGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) contents:[NSArray arrayWithObjects:cellModel1, cellModel2, cellModel3, cellModel4, cellModel5, nil]];
    gridView.gridDelegate = self;
    [self.view addSubview:gridView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - grid view delegate
- (void)gridView:(DBGridView *)gridView didTappedAtIndex:(NSInteger)index
{
    NSLog(@"index = %ld", index);
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
