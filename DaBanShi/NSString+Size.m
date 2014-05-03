//
//  NSString+Size.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-8.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "NSString+Size.h"

const CGFloat kStringMaxHeight = 1000.f;
static const CGFloat kSingleLineStringMaxHeight = 20.f;

@implementation NSString (Size)

- (CGSize)HLY_sizeWithFontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth forSingleLine:(BOOL)isSingleLine
{
    CGSize size = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [self boundingRectWithSize:CGSizeMake(maxWidth, isSingleLine ? kSingleLineStringMaxHeight : kStringMaxHeight)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
        size = rect.size;
    } else {
        size = [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(maxWidth, isSingleLine ? kSingleLineStringMaxHeight : kStringMaxHeight)];
    }
    
    return size;
}

- (CGSize)HLY_heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth characterMargin:(CGFloat)character lineMargin:(CGFloat)line pragraphMargin:(CGFloat)pragraph
{
    
    //创建AttributeStringfdsa
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]
                                         initWithString:self];
    //创建字体以及字体大小
    CTFontRef helvetica = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    //添加字体目标字符串从下标0开始到字符串结尾
    [string addAttribute:(id)kCTFontAttributeName
                   value:(__bridge id)helvetica
                   range:NSMakeRange(0, [string length])];
    
    
    [string addAttribute:(id)kCTForegroundColorAttributeName
                   value:(id)[UIColor whiteColor].CGColor
                   range:NSMakeRange(0, [string length])];
    
    CTTextAlignment alignment = kCTJustifiedTextAlignment;//这种对齐方式会自动调整，使左右始终对齐
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    
    //设置字体间距
    long number = character;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
    [string addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [string length])];
    CFRelease(num);
    
    
    
    //创建文本行间距
    CGFloat lineSpace=line;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
    lineSpaceStyle.valueSize=sizeof(lineSpace);
    lineSpaceStyle.value=&lineSpace;
    
    //设置段落间距
    CGFloat paragraph = pragraph;
    CTParagraphStyleSetting paragraphStyle;
    paragraphStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphStyle.valueSize = sizeof(CGFloat);
    paragraphStyle.value = &paragraph;
    
    
    //创建样式数组
    CTParagraphStyleSetting settings[]={
        alignmentStyle,lineSpaceStyle,paragraphStyle
    };
    
    //设置样式
    CTParagraphStyleRef paragraphStyle1 = CTParagraphStyleCreate(settings, sizeof(settings));
    
    //给字符串添加样式attribute
    [string addAttribute:(id)kCTParagraphStyleAttributeName
                   value:(__bridge id)paragraphStyle1
                   range:NSMakeRange(0, [string length])];
    
    // layout master
    CTFramesetterRef  framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    //计算文本绘制size
    CGSize tmpSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(maxWidth, MAXFLOAT), NULL);
    //创建textBoxSize以设置view的frame
    CGSize textBoxSize = CGSizeMake((int)tmpSize.width + 1, (int)tmpSize.height + 1);
    
    return textBoxSize;
    
}

@end
