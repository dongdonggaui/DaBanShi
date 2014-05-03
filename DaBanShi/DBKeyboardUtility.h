//
//  DBKeyboardUtility.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-30.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBKeyboardUtility : NSObject

+ (void)handleKeyboardWillChangeFrameNotification:(NSNotification *)notification tobeAdjustView:(UIView *)tobeAdjustView withView:(UIView *)view delta:(CGFloat)delta;

@end
