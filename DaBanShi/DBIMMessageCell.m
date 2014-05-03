//
//  DBIMMessageCell.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBIMMessageCell.h"

#import "UIColor+Convenience.h"
#import "UIFont+HLY.h"
#import "UIImageView+Network.h"
#import "NSString+Size.h"
#import "NSDate+HLYDate.h"

const CGFloat kMessageWidthMax = 170;
const CGFloat kIMMessageCellMarginDefault = 8;
const CGFloat kIMMessageCellMarginMedium = 10;
const CGFloat kIMMessageCellMarginSmall = 5;

@interface DBIMMessageCell ()

@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UIImageView *avatorImageView;
@property (nonatomic) DBRichLabel *messageContentView;
@property (nonatomic) UIImageView *backgroundImageView;

@end

@implementation DBIMMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor HLY_lightGrayColor];
        _timeLabel.height = 21;
        _timeLabel.font = [UIFont HLY_smallFont];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = HLYTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        
        _avatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_avatorImageView];
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_backgroundImageView];
        
        _messageContentView = [[DBRichLabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_messageContentView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat currentOriginX = kIMMessageCellMarginMedium;
    CGFloat currentOriginY = kIMMessageCellMarginMedium;
    if (self.displayTime) {
        CGSize timeSize = [self.timeLabel.text HLY_sizeWithFontSize:self.timeLabel.font.pointSize maxWidth:self.contentView.width - 2 * kIMMessageCellMarginMedium forSingleLine:YES];
        self.timeLabel.width = timeSize.width + 2 * kIMMessageCellMarginMedium;
        self.timeLabel.layer.cornerRadius = 5;
        self.timeLabel.clipsToBounds = YES;
        self.timeLabel.x = ceilf((self.contentView.width - self.timeLabel.width) / 2);
        self.timeLabel.y = currentOriginY;
        currentOriginY += self.timeLabel.height + kIMMessageCellMarginDefault;
    }
    
    CGFloat avatorHeight = 50;
    self.avatorImageView.y = currentOriginY;
    self.avatorImageView.width = avatorHeight;
    self.avatorImageView.height = avatorHeight;
    
    self.messageContentView.font = [UIFont systemFontOfSize:16];
    self.messageContentView.y = self.avatorImageView.y + kIMMessageCellMarginMedium;
    CGSize messageSize = [self.messageContentView displaySizeForWidth:kMessageWidthMax];
    self.messageContentView.height = ceilf(messageSize.height);
    self.messageContentView.width = ceilf(messageSize.width);
    self.messageContentView.backgroundColor = [UIColor clearColor];
    
    self.backgroundImageView.width = self.messageContentView.width + 30;
    self.backgroundImageView.height = self.messageContentView.height + 30;
    self.backgroundImageView.y = self.messageContentView.y - 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - public
- (void)configureCellWithContent:(NSString *)content imagePath:(NSString *)imagePath time:(NSDate *)time
{
    self.messageContentView.text = content;
    self.timeLabel.text = [NSDate HLY_displayDate:time];
    [self.avatorImageView HLY_loadNetworkImageAtPath:imagePath];
}

@end
