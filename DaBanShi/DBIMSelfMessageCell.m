//
//  DBIMSelfMessageCell.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBIMSelfMessageCell.h"

@implementation DBIMSelfMessageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textAlignment = HLYTextAlignmentRight;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatorImageView.x = self.contentView.width - kIMMessageCellMarginMedium - self.avatorImageView.width;
    self.messageContentView.x = self.avatorImageView.x - 3 * kIMMessageCellMarginMedium - self.messageContentView.width;
    self.backgroundImageView.x = self.messageContentView.x - 10;
    UIImage *background = [[UIImage imageNamed:@"SenderTextNodeBkg_ios7"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 32, 27, 33)];
    self.backgroundImageView.image = background;
}


@end
