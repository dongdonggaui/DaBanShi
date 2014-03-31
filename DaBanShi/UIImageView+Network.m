//
//  UIImageView+HWD.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-13.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import <UIImageView+AFNetworking.h>

#import "UIImageView+Network.h"
#import "HLYImageCache.h"

@implementation UIImageView (Network)

- (void)HLY_loadNetworkImageAtPath:(NSString *)avatorPath withPlaceholder:(UIImage *)placeholder errorImage:(UIImage *)errorImage activityIndicator:(UIActivityIndicatorView *)juhua
{
    if (!avatorPath) {
        self.image = placeholder;
    }
    
    UIImage *image = [HLYImageCache fetchCachedImageForEntity:avatorPath];
    if (image) {
        self.image = image;
        if (juhua && [juhua isAnimating]) {
            [juhua stopAnimating];
        }
        return;
    }
    
    NSURL *url = [NSURL URLWithString:avatorPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (juhua != nil && !juhua.isAnimating) {
        [juhua startAnimating];
    }
    
    if (placeholder) {
        self.image = placeholder;
    }
    
    __weak UIImageView *safeSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT , 0), ^{
        [safeSelf setImageWithURLRequest:request placeholderImage:placeholder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                safeSelf.image = image;
                if (juhua != nil && juhua.isAnimating) {
                    [juhua stopAnimating];
                }
                
            });
            
            [HLYImageCache cacheImage:image withEntityName:avatorPath];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                safeSelf.image = errorImage;
                if (juhua != nil && juhua.isAnimating) {
                    [juhua stopAnimating];
                }
            });
        }];
    });
    
}

@end
