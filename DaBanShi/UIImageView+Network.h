//
//  UIImageView+HWD.h
//  Haoweidao
//
//  Created by huangluyang on 14-3-13.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Network)

- (void)HLY_loadNetworkImageAtPath:(NSString *)avatorPath withPlaceholder:(UIImage *)placeholder errorImage:(UIImage *)errorImage activityIndicator:(UIActivityIndicatorView *)juhua;

@end
