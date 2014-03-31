//
//  UIColor+Convenience.m
//  Haoweidao
//
//  Created by huangluyang on 13-12-27.
//  Copyright (c) 2013年 whu. All rights reserved.
//

#import "UIColor+Convenience.h"

@implementation UIColor (Convenience)

+ (instancetype)HLY_mainBackgroundColor
{
    return [UIColor colorWithRed:0xF4/255.0 green:0xF4/255.0 blue:0xF4/255.0 alpha:0xFF/255.0];
}

+ (instancetype)HLY_mainTintColor
{
    return [UIColor colorWithRed:225/255.0 green:73/255.0 blue:19/255.0 alpha:0xFF/255.0];/* FC5D08FF */
}

+ (instancetype)HLY_mainTintColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:225/255.0 green:73/255.0 blue:19/255.0 alpha:alpha];
}

+ (instancetype)HLY_navigationbarColor
{
    return [UIColor colorWithRed:225/255.0 green:73/255.0 blue:19/255.0 alpha:0xFF/255.0];/* FD8208FF */
}

+ (instancetype)HLY_softOrangeColor
{
    return [UIColor colorWithRed:255/255.0 green:171/255.0 blue:128/255.0 alpha:0xFF/255.0];/* FD8208FF */
}

+ (instancetype)HLY_grayTextColor
{
    return [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0xFF/255.0];/* FD8208FF */
}

+ (instancetype)HLY_lightGrayColor
{
    return [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:0xFF/255.0];/* FD8208FF */
}


@end
