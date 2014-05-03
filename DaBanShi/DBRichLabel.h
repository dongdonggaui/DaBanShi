//
//  DBRichLabel.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBRichLabel : UIView

@property (nonatomic) NSString *text;
@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;

- (CGSize)displaySizeForWidth:(CGFloat)width;

@end
