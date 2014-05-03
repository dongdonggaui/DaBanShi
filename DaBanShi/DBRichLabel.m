//
//  DBRichLabel.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "DBRichLabel.h"
#import "DBEmotion.h"

#import "NSString+Size.h"

@interface DBRichLabel ()

/// 用于构建表情选择器
@property (nonatomic) NSMutableArray *emotions;

/// 表情键值映射表，用于查询
@property (nonatomic) NSMutableDictionary *emotionDic;

@property (nonatomic) NSMutableArray *emotionKeys;
@property (nonatomic) NSMutableArray *emotionPositions;
@property (nonatomic) NSString *cleanText;

@end

@implementation DBRichLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat RunDelegateGetAscentCallback( void *refCon ){
    NSString *imageName = (__bridge NSString *)refCon;
    return [UIImage imageNamed:imageName].size.height - 8; // 降低图片的上行高度减少行距
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    NSString *imageName = (__bridge NSString *)refCon;
    return [UIImage imageNamed:imageName].size.width;
}


- (void)drawRect:(CGRect)rect
{
    [self resolveText];
    NSString *text = self.cleanText;
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"keys --> %@, loctions --> %@", self.emotionKeys, self.emotionPositions);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //这四行代码只是简单测试drawRect中context的坐标系
//    CGContextSetRGBFillColor (context, 1, 0, 0, 1);
//    CGContextFillRect (context, CGRectMake (0, 200, 200, 100 ));
//    CGContextSetRGBFillColor (context, 0, 0, 1, .5);
//    CGContextFillRect (context, CGRectMake (0, 200, 100, 200));
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    //为所有文本设置字体
    //[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, [attributedString length])]; // 6.0+
    UIFont *font = self.font;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, [attributedString length])];
    
    // 设置字体颜色
    //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 2)]; //6.0+
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:NSMakeRange(0, attributedString.length)];
    
//    // 行距
//    //设置文本行间距
//    CGFloat lineSpace = 5;
//    CTParagraphStyleSetting lineSpaceStyle;
//    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
//    lineSpaceStyle.valueSize = sizeof(lineSpace);
//    lineSpaceStyle.value =&lineSpace;
//    //创建设置数组
//    CTParagraphStyleSetting settings[] = {lineSpaceStyle};
//    CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,1);
//    //给文本添加设置
//    [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [attributedString length])];
    
    for (int i = 0; i < self.emotionKeys.count; i++) {
        NSString *emotionKey = [self.emotionKeys objectAtIndex:i];
        NSString *emotionPosition = [self.emotionPositions objectAtIndex:i];
        NSString *emotionPath = [NSString stringWithFormat:@"Expression_%@", [self.emotionDic objectForKey:emotionKey]];
        NSRange emotionRange = NSMakeRange(0, 1);
        
        //为图片设置CTRunDelegate,delegate决定留给图片的空间大小
        CTRunDelegateCallbacks imageCallbacks;
        imageCallbacks.version = kCTRunDelegateVersion1;
        imageCallbacks.dealloc = RunDelegateDeallocCallback;
        imageCallbacks.getAscent = RunDelegateGetAscentCallback;
        imageCallbacks.getDescent = RunDelegateGetDescentCallback;
        imageCallbacks.getWidth = RunDelegateGetWidthCallback;
        CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(emotionPath));
        NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "];//空格用于给图片留位置
        [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:emotionRange];
        CFRelease(runDelegate);
        
        [imageAttributedString addAttribute:@"imageName" value:emotionPath range:emotionRange];
        
        // 确定图片插入位置
        [attributedString insertAttributedString:imageAttributedString atIndex:emotionPosition.integerValue];
    }
    
    // 画文本
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(3, -3, self.bounds.size.width - 6, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame, context);
    
    // 画图片
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary *attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            
            runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = image.size;
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x + 3;
                    imageDrawRect.origin.y = lineOrigin.y - 8;  // 让表情图片下沉 5px 显示效果更好
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(ctFramesetter);
}


#pragma mark - public
- (CGSize)displaySizeForWidth:(CGFloat)width
{
    [self resolveText];
    CGSize textSize = [[self.cleanText stringByReplacingOccurrencesOfString:@" " withString:@"一1"] HLY_heightWithFont:self.font maxWidth:width characterMargin:0 lineMargin:0 pragraphMargin:0];
    
    return CGSizeMake(textSize.width + 6, textSize.height + 6);
}


#pragma mark - private
- (void)resolveText
{
    if (![self.text isEqualToString:self.cleanText]) {
        return;
    }
    
    NSString *text = self.text;
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:@"\\[[\u4E00-\u9FA5]+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = nil;
    while (1) {
        match = [regx firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
        if (match) {
            NSString *emotionKey = [text substringWithRange:NSMakeRange(match.range.location + 1, match.range.length - 2)];
            text = [text stringByReplacingCharactersInRange:match.range withString:@" "];
            [self.emotionKeys addObject:emotionKey];
            [self.emotionPositions addObject:[NSNumber numberWithInteger:match.range.location]];
        } else
            break;
    }
    
    self.cleanText = text;
}

#pragma mark - setters & getters
- (NSMutableArray *)emotions
{
    if (!_emotions) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Emotions" withExtension:@"plist"];
        NSArray *nativeEmotions = [NSArray arrayWithContentsOfURL:url];
        _emotions = [NSMutableArray arrayWithCapacity:nativeEmotions.count];
        for (int i = 0; i < nativeEmotions.count; i++) {
            NSDictionary *dic = [nativeEmotions objectAtIndex:i];
            DBEmotion *emotion = [DBEmotion emotionWithKey:[dic objectForKey:@"key"] path:[dic objectForKey:@"path"]];
            [_emotions addObject:emotion];
        }
    }
    
    return _emotions;
}

- (NSMutableDictionary *)emotionDic
{
    if (!_emotionDic) {
        _emotionDic = [NSMutableDictionary dictionaryWithCapacity:self.emotions.count];
        for (DBEmotion *emotion in self.emotions) {
            [_emotionDic setObject:emotion.emotionPath forKey:emotion.emotionKey];
        }
    }
    
    return _emotionDic;
}

- (NSMutableArray *)emotionKeys
{
    if (!_emotionKeys) {
        _emotionKeys = [NSMutableArray array];
    }
    
    return _emotionKeys;
}

- (NSMutableArray *)emotionPositions
{
    if (!_emotionPositions) {
        _emotionPositions = [NSMutableArray array];
    }
    
    return _emotionPositions;
}

- (UIFont *)font
{
    if (!_font) {
        _font = [UIFont systemFontOfSize:14];
    }
    
    return _font;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    
    return _textColor;
}

- (void)setText:(NSString *)text
{
    if (_text != text) {
        _text = text;
        self.cleanText = text;
    }
}

@end

