//
//  DBKeyboardUtility.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-30.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBKeyboardUtility.h"

@implementation DBKeyboardUtility

+ (void)handleKeyboardWillChangeFrameNotification:(NSNotification *)notification tobeAdjustView:(UIView *)tobeAdjustView withView:(UIView *)view delta:(CGFloat)delta
{
    CGRect beginFrame = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSValue *timeValue = [notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval timeInterval = 0.0;
    [timeValue getValue:&timeInterval];
    CGFloat deltaY = endFrame.origin.y - beginFrame.origin.y;
    
    if (deltaY >= endFrame.size.height) {           // 键盘收起
        [UIView animateWithDuration:timeInterval animations:^{
//            scrollView.contentInset = UIEdgeInsetsZero;
            view.y = delta;
        }];
    } else if (deltaY <= -endFrame.size.height) {    // 键盘弹出
        CGRect absolutelyCoordinate = [self fetchAbsolutelyCoordinateForSubView:tobeAdjustView];
        CGFloat distance = absolutelyCoordinate.origin.y + absolutelyCoordinate.size.height + endFrame.size.height - [self appWindow].height;
        [UIView animateWithDuration:timeInterval animations:^{
            view.y -= distance;
//            scrollView.contentInset = UIEdgeInsetsMake(-distance, 0, 0, 0);
        }];
    } else {                                        // 中英文切换
        CGRect absolutelyCoordinate = [self fetchAbsolutelyCoordinateForSubView:tobeAdjustView];
        CGFloat distance = absolutelyCoordinate.origin.y + absolutelyCoordinate.size.height + endFrame.size.height - [self appWindow].height;
        [UIView animateWithDuration:timeInterval animations:^{
            view.y -= distance;
        }];
    }
}


#pragma mark - private
+ (UIWindow *)appWindow
{
    return [[[UIApplication sharedApplication] windows] lastObject];
}

+ (CGRect)fetchAbsolutelyCoordinateForSubView:(UIView *)theView
{
    CGRect currentFrame = theView.frame;
    for (__weak UIView *view = theView.superview; ![view isKindOfClass:[UIWindow class]]; view = view.superview) {
        currentFrame.origin.y += view.frame.origin.y;
        DLog(@"class --> %@, frame --> %@", NSStringFromClass([view class]), NSStringFromCGRect(view.frame));
    }
    
    return currentFrame;
}

@end
