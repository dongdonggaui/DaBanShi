//
//  DBSimpleCell.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBSimpleCell : UITableViewCell

- (void)configureWithImagePath:(NSString *)imagePath title:(NSString *)title content:(NSString *)content time:(NSDate *)time;

@end
