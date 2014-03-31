//
//  NSString+InputCheck.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "NSString+InputCheck.h"

@implementation NSString (InputCheck)

- (BOOL)HLY_isValidateEmail
{
    return [self isValidateWithRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)HLY_isValidatePhone
{
    return [self isValidateWithRegex:@"^(134|135|136|137|138|139|150|151|152|158|159|157|182|187|188|147|130|131|132|155|185|186|133|153|180|189)\\d{8}$"];
}

- (BOOL)isValidateWithRegex:(NSString *)theRegex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", theRegex];
    
    return [predicate evaluateWithObject:self];
}

/**
 @brief 验证输入是否为空
 @params theInput 输入字符串
 @returns 输入为空则返回 YES，否则返回 NO
 */
- (BOOL)HLY_isNull
{
    if (!self || self.length == 0) {
        return YES;
    }
    
    return NO;
}

/**
 @brief 用内置的非法字符串集验证输入是否合法
 @params theInput 输入
 @returns 若不包含非法字符返回 YES，否则返回 NO
 */
- (BOOL)HLY_isValidateInput
{
    return [self isValidateInputWithNotWantSet:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
}

/**
 @brief 验证输入是否合法
 @params theInput 输入
 @params doNotWantSetString 用于验证的非法字符集的字符串表示
 @returns 若不包含非法字符返回 YES，否则返回 NO
 */
- (BOOL)isValidateInputWithNotWantSet:(NSString *)doNotWantSetString
{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:doNotWantSetString];
    NSString *tempString = [[self componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    
    return self.length == tempString.length;
}

@end
