//
//  DBIMOtherMessageCell.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBIMOtherMessageCell.h"

@implementation DBIMOtherMessageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatorImageView.x = kIMMessageCellMarginMedium;
    self.messageContentView.x = self.avatorImageView.x + self.avatorImageView.width + 3 * kIMMessageCellMarginMedium;
    self.backgroundImageView.x = self.messageContentView.x - 20;
    UIImage *background = [[UIImage imageNamed:@"ReceiverTextNodeBkg_ios7"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 32, 27, 33)];
    self.backgroundImageView.image = background;
}

@end
