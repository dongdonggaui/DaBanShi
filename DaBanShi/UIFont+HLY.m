//
//  UIFont+HLY.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-7.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "UIFont+HLY.h"

@implementation UIFont (HLY)

+ (instancetype)HLY_bigFont
{
    return [UIFont systemFontOfSize:17];
}

+ (instancetype)HLY_boldBigFont
{
    return [UIFont boldSystemFontOfSize:17];
}

+ (instancetype)HLY_mediumFont
{
    return [UIFont systemFontOfSize:15];
}

+ (instancetype)HLY_boldMediumFont
{
    return [UIFont boldSystemFontOfSize:15];
}

+ (instancetype)HLY_smallFont
{
    return [UIFont systemFontOfSize:13];
}

+ (instancetype)HLY_boldSmallFont
{
    return [UIFont boldSystemFontOfSize:13];
}

@end
