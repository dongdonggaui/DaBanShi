//
//  DBIMManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBIMManager.h"
#import "DBIMSelfMessageCell.h"
#import "DBIMOtherMessageCell.h"
#import "DBMessage.h"
#import "DBUser.h"

#import "NSString+Size.h"
#import "UIFont+HLY.h"

@interface DBIMManager ()

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *messageCellHeights;
@property (nonatomic, strong) UIFont *defaultFont;

@end

@implementation DBIMManager

- (instancetype)init
{
    if (self = [super init]) {
        _messages = [NSMutableArray array];
        _messageCellHeights = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)initWithUID:(NSString *)uid
{
    if (self = [self init]) {
        _uid = uid;
    }
    
    return self;
}


#pragma mark - public
- (void)fetchMessagesForUID:(NSString *)uid
{
    DBUser *user = [DBUser userWithProperties:@{@"nickname": @"zhangsan"}];
    DBMessage *msg0 = [DBMessage messageWithContent:@"zxgdfgdfgsdfgsdfg测[微笑]试kjgjkhgjhkgjkhgkjhg" createTime:[NSDate date] messageType:DBMessageTypeSelf user:user];
    DBMessage *msg1 = [DBMessage messageWithContent:@"测试[微笑]1[抠鼻]" createTime:[NSDate date] messageType:DBMessageTypeOther user:user];
    DBMessage *msg2 = [DBMessage messageWithContent:@"测试2" createTime:[NSDate date] messageType:DBMessageTypeSelf user:user];
    DBMessage *msg3 = [DBMessage messageWithContent:@"测试3测试3[酷]测试3[快哭了]测试3测试3测试3[亲亲]测试3[嘴唇]测试3测试3测试3测试3测试3测试3测试3测试3测试3测试3测试3测试3测试3测试3测试3测试3gkjhgkjhghjk" createTime:[NSDate date] messageType:DBMessageTypeSelf user:user];
    DBMessage *msg4 = [DBMessage messageWithContent:@"测试[微笑]4" createTime:[NSDate date] messageType:DBMessageTypeOther user:user];
    [self.messages addObject:msg0];
    [self.messages addObject:msg1];
    [self.messages addObject:msg2];
    [self.messages addObject:msg3];
    [self.messages addObject:msg4];
}

- (DBIMMessageCell *)messageCellAtIndex:(NSInteger)index identifier:(NSString *)identifier
{
    DBMessage *message = [self.messages objectAtIndex:index];
    DBIMMessageCell *cell = nil;
    if (message.type == DBMessageTypeSelf) {
        cell = [[DBIMSelfMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    } else {
        cell = [[DBIMOtherMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    cell.textLabel.font = [self currentFont];
//    cell.textLabel.text = message.content;
//    cell.textLabel.numberOfLines = 0;
    [cell configureCellWithContent:message.content imagePath:message.user.avatorUrl time:message.createTime];
    cell.messageContentView.font = [self currentFont];
    cell.displayTime = [message needToDisplayTime];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)cellHeightForMessageAtIndex:(NSInteger)index
{
    DBMessage *message = [self.messages objectAtIndex:index];
    CGFloat baseHeight = 2 * (kIMMessageCellMarginMedium + kIMMessageCellMarginSmall) + 2 * kIMMessageCellMarginMedium;
    
    UIFont *font = [self currentFont];
    
    NSString *text = message.content;
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:@"\\[[\u4E00-\u9FA5]+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = nil;
    while (1) {
        match = [regx firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
        if (match) {
            text = [text stringByReplacingCharactersInRange:match.range withString:@"与"];   // 将表情图片替换为任一中文字符，表情图片宽度与中文字符宽度相当
        } else
            break;
    }
    
    CGSize contentSize = [text HLY_heightWithFont:font maxWidth:kMessageWidthMax characterMargin:0 lineMargin:0 pragraphMargin:0];
    baseHeight += contentSize.height + 6;
    // 不能比头像高度小
    baseHeight = MAX(70, baseHeight);
    // 加入时间标签的高度
    if ([message needToDisplayTime]) {
        baseHeight += 21 + kIMMessageCellMarginMedium;
    }
    
    return baseHeight;
}


#pragma mark - private
- (UIFont *)currentFont
{
    UIFont *font = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontForIMManager:)]) {
        font = [self.delegate fontForIMManager:self];
    } else {
        font = self.defaultFont;
    }
    
    return font;
}


- (UIFont *)defaultFont
{
    if (!_defaultFont) {
        _defaultFont = [UIFont systemFontOfSize:16];
    }
    
    return _defaultFont;
}

@end
