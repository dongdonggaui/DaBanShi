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

@interface DBHomeViewController ()

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
	// Do any additional setup after loading the view.
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
    cellModel4.cellTitle = @"xxx";
    cellModel4.cellDetail = @"xxxxxxxx";
    cellModel4.imageName = @"cover_placeholder";
    DBGridCellModel *cellModel5 = [[DBGridCellModel alloc] init];
    cellModel5.cellType = DBGridCellTypeSamll;
    cellModel5.cellTitle = @"xxx";
    cellModel5.cellDetail = @"xxxxxxxx";
    cellModel5.imageName = @"cover_placeholder";
    DBGridView *gridView = [[DBGridView alloc] initWithContents:[NSArray arrayWithObjects:cellModel1, cellModel2, cellModel3, cellModel4, cellModel5, nil]];
    [self.view addSubview:gridView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
