//
//  DBSimpleCell.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBSimpleCell.h"

#import "UIImageView+Network.h"
#import "NSDate+HLYDate.h"
#import "NSString+Size.h"
#import "UIFont+HLY.h"
#import "UIColor+Convenience.h"

static const CGFloat kSimpleCellMarginDefault = 8;
static const CGFloat kSimpleCellMarginMedium = 10;
static const CGFloat kSimpleCellMarginSmall = 5;
static const CGFloat kSimpleCellMarginSingleLineHeight = 21;

@interface DBSimpleCell ()

@property (nonatomic) UIImageView *simpleImageView;
@property (nonatomic) UILabel *simpleTitleLabel;
@property (nonatomic) UILabel *simpleContentLabel;
@property (nonatomic) UILabel *simpleTimeLabel;

@end

@implementation DBSimpleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _simpleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 50, 50)];
        [self.contentView addSubview:_simpleImageView];
        
        _simpleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _simpleTitleLabel.font = [UIFont HLY_boldMediumFont];
        [self.contentView addSubview:_simpleTitleLabel];
        
        _simpleContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _simpleContentLabel.font = [UIFont HLY_smallFont];
        _simpleContentLabel.textColor = [UIColor HLY_grayTextColor];
        [self.contentView addSubview:_simpleContentLabel];
        
        _simpleTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _simpleTimeLabel.font = [UIFont HLY_smallFont];
        _simpleTimeLabel.textColor = [UIColor HLY_grayTextColor];
        [self.contentView addSubview:_simpleTimeLabel];
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
    
    self.simpleTimeLabel.y = kSimpleCellMarginMedium;
    self.simpleTimeLabel.width = [self.simpleTimeLabel.text HLY_sizeWithFontSize:13 maxWidth:250 forSingleLine:YES].width;
    self.simpleTimeLabel.height = kSimpleCellMarginSingleLineHeight;
    self.simpleTimeLabel.x = self.contentView.width - kSimpleCellMarginSmall - self.simpleTimeLabel.width;
    
    self.simpleTitleLabel.x = self.simpleImageView.x + self.simpleImageView.width + kSimpleCellMarginDefault;
    self.simpleTitleLabel.y = kSimpleCellMarginDefault;
    self.simpleTitleLabel.width = self.simpleTimeLabel.x - self.simpleTitleLabel.x;
    self.simpleTitleLabel.height = kSimpleCellMarginSingleLineHeight;
    
    self.simpleContentLabel.x = self.simpleTitleLabel.x;
    self.simpleContentLabel.y = self.simpleTitleLabel.y + self.simpleTitleLabel.height + kSimpleCellMarginSmall;
    self.simpleContentLabel.width = self.contentView.width - self.simpleContentLabel.x - kSimpleCellMarginSmall;
    self.simpleContentLabel.height = [self.simpleContentLabel.text HLY_sizeWithFontSize:13 maxWidth:self.simpleContentLabel.width forSingleLine:NO].height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - public
- (void)configureWithImagePath:(NSString *)imagePath title:(NSString *)title content:(NSString *)content time:(NSDate *)time
{
    [self.simpleImageView HLY_loadNetworkImageAtPath:imagePath];
    self.simpleTitleLabel.text = title;
    self.simpleContentLabel.text = content;
    self.simpleTimeLabel.text = [NSDate HLY_displayDate:time];
}

@end
