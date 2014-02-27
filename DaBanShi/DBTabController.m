//
//  DBViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBTabController.h"

@implementation DBTabController

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
  UIViewController* viewController = [[UIViewController alloc] init];
  viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
  return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];

  CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
  if (heightDifference < 0)
    button.center = self.tabBar.center;
  else
  {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
  }
  
  [self.view addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"camera_button_take"] highlightImage:[UIImage imageNamed:@"camera_button_take"]];
}

@end
