//
//  DBGridViewCell.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBGridViewCell.h"

const static float cellPadding = 8.f;

@interface DBGridViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DBGridViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellPadding, cellPadding, frame.size.width - 2 * cellPadding, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellPadding, frame.size.height - 20 - cellPadding, frame.size.width - 2 * cellPadding, 20)];
        _detailLabel.font = [UIFont systemFontOfSize:10];
        _detailLabel.textColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        [self addSubview:_imageView];
        [self addSubview:_detailLabel];
        [self addSubview:_titleLabel];
    }
    return self;
}


@end
