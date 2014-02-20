//
//  DBGridViewCell.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBGridViewCell : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *detailLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end
