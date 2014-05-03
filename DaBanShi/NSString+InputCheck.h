//
//  NSString+InputCheck.h
//  DaBanShi
//
//  Created by huangluyang on 14-3-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (InputCheck)

- (BOOL)HLY_isValidateEmail;
- (BOOL)HLY_isValidatePhone;
- (BOOL)isValidateWithRegex:(NSString *)theRegex;
/**
 @brief 验证输入是否为空
 @params theInput 输入字符串
 @returns 输入为空则返回 YES，否则返回 NO
 */
- (BOOL)HLY_isNull;

/**
 @brief 用内置的非法字符串集验证输入是否合法
 @params theInput 输入
 @returns 若不包含非法字符返回 YES，否则返回 NO
 */
- (BOOL)HLY_isValidateInput;

/**
 @brief 验证输入是否合法
 @params theInput 输入
 @params doNotWantSetString 用于验证的非法字符集的字符串表示
 @returns 若不包含非法字符返回 YES，否则返回 NO
 */
- (BOOL)HLY_isValidateInputWithNotWantSet:(NSString *)doNotWantSetString;

/**
 去除多余空格
 */
- (NSString *)HLY_trim;

@end
