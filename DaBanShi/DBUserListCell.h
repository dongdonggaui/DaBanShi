//
//  DBUserListCell.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-8.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBUserListCell : UITableViewCell

- (void)configureCellWithImagePath:(NSString *)imagePath userName:(NSString *)name detail:(NSString *)detail;

@end
