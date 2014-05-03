//
//  DBWelcomeViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBWelcomeViewController.h"

@interface DBWelcomeViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *maskBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation DBWelcomeViewController

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
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(3 * self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private


#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xOffset = scrollView.contentOffset.x;
    CGRect frame = self.maskBackgroundImageView.frame;
    frame.origin.x = -xOffset / 2.f;
    self.maskBackgroundImageView.frame = frame;
}

@end
