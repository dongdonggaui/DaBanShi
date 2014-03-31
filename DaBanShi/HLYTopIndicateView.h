//
//  HLYTopIndicateView.h
//  Haoweidao
//
//  Created by huangluyang on 13-12-29.
//  Copyright (c) 2013年 whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLYTopIndicateView : UIView

@property (nonatomic, strong) NSString *message;

+ (instancetype)topIndicateWithMessage:(NSString *)theMessage;
- (void)showMessage:(NSString *)theMessage;
- (void)hide;

@end
