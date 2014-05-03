//
//  DBIMMessageCell.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBRichLabel.h"

@interface DBIMMessageCell : UITableViewCell

@property (nonatomic, readonly) UILabel *timeLabel;
@property (nonatomic, readonly) UIImageView *avatorImageView;
@property (nonatomic, readonly) DBRichLabel *messageContentView;
@property (nonatomic, readonly) UIImageView *backgroundImageView;
@property (nonatomic) BOOL displayTime;

- (void)configureCellWithContent:(NSString *)content imagePath:(NSString *)imagePath time:(NSDate *)time;

@end

extern const CGFloat kMessageWidthMax;
extern const CGFloat kIMMessageCellMarginDefault;
extern const CGFloat kIMMessageCellMarginMedium;
extern const CGFloat kIMMessageCellMarginSmall;
