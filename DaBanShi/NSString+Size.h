//
//  NSString+Size.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-8.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)HLY_sizeWithFontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth forSingleLine:(BOOL)isSingleLine;
- (CGSize)HLY_heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth characterMargin:(CGFloat)character lineMargin:(CGFloat)line pragraphMargin:(CGFloat)pragraph;

@end
