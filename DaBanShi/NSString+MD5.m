//
//  NSString+MD5.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-24.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

- (NSString*)HWD_md5
{
    const char *str = [self UTF8String];
    unsigned char result[16];
    CC_MD5(str, strlen(str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash uppercaseString];
}

@end
