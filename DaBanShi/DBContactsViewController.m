//
//  DBContactsViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-8.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBContactsViewController.h"

#import "DBVibriteManager.h"

#import "DBRichLabel.h"

@interface DBContactsViewController ()

@end

@implementation DBContactsViewController

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
    
    UIButton *shakeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shakeButton.width = 100;
    shakeButton.height = 40;
    shakeButton.backgroundColor = [UIColor yellowColor];
    shakeButton.center = self.view.center;
    [shakeButton setTitle:@"震动" forState:UIControlStateNormal];
    [shakeButton addTarget:self action:@selector(shakeButtonDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [shakeButton addTarget:self action:@selector(shakeButtonDidTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shakeButton];
    
    DBRichLabel *rlabel = [[DBRichLabel alloc] initWithFrame:self.view.bounds];
    rlabel.text = @"ceshi[微笑]，抠鼻子[抠鼻]，衰[衰]";
    self.view = rlabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)shakeButtonDidTouchDown:(UIButton *)sender
{
    DLog(@"touch down");
//    [[DBVibriteManager sharedInstance] startShake];
}

- (void)shakeButtonDidTouchUp:(UIButton *)sender
{
    if (sender.isSelected) {
        sender.selected = NO;
        [[DBVibriteManager sharedInstance] stopShake];
        sender.backgroundColor = [UIColor yellowColor];
    } else {
        sender.selected = YES;
        [[DBVibriteManager sharedInstance] startShake];
        sender.backgroundColor = [UIColor redColor];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
