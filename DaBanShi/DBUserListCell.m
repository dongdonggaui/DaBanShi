//
//  DBUserListCell.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-8.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBUserListCell.h"

#import "UIImageView+Network.h"
#import "UIImage+Convenience.h"
#import "NSString+Size.h"

@interface DBUserListCell ()

@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *userDetailLabel;

@end

@implementation DBUserListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _avatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatorImageView.clipsToBounds = YES;
        [self.contentView addSubview:_avatorImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_nameLabel];
        
        _userDetailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_userDetailLabel];
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
    
    self.avatorImageView.width = 50;
    self.avatorImageView.height = 50;
    self.avatorImageView.x = 10;
    self.avatorImageView.y = 10;
    
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.x = self.avatorImageView.x + self.avatorImageView.width + 10;
    self.nameLabel.y = 10;
    self.nameLabel.width = self.contentView.width - self.nameLabel.x - 10;
    self.nameLabel.height = 21;
    
    self.userDetailLabel.font = [UIFont systemFontOfSize:14];
    self.userDetailLabel.x = self.nameLabel.x;
    self.userDetailLabel.y = self.nameLabel.y + self.nameLabel.height + 5;
    self.userDetailLabel.width = self.contentView.width - self.nameLabel.x - 10;
    self.userDetailLabel.numberOfLines = 0;
    self.userDetailLabel.height = [self.userDetailLabel.text HLY_sizeWithFontSize:14 maxWidth:self.userDetailLabel.width forSingleLine:NO].height;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.avatorImageView.image = nil;
    self.nameLabel.text = nil;
    self.userDetailLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - public
- (void)configureCellWithImagePath:(NSString *)imagePath userName:(NSString *)name detail:(NSString *)detail
{
    [self.avatorImageView HLY_loadNetworkImageAtPath:imagePath withPlaceholder:[UIImage HLY_defaultAvatar] errorImage:[UIImage HLY_errorImage] activityIndicator:nil];
    self.nameLabel.text = name;
    self.userDetailLabel.text = detail;
}

@end
