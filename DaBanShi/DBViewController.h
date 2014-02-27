//
//  DBViewController.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "DBAppDelegate.h"

@interface DBViewController : UIViewController

@property (nonatomic, weak) id passValue;
@property (nonatomic, strong) MBProgressHUD *hud;

- (DBAppDelegate *)appDelegate;

@end
