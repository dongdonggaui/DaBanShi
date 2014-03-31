//
//  HLYImage.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-12.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import "DBImage.h"
#import "NSDictionary+NetworkProperties.h"

@implementation DBImage

+ (instancetype)imageWithProperties:(NSDictionary *)properties
{
    if (properties == nil) {
        return nil;
    }
    
    DBImage *image = [[self alloc] init];
    NSDictionary *dic = [properties dictionaryByRemoveNull];
    image.imageId = [dic objectForKey:@"id"];
    image.thumbUrl = [dic objectForKey:@"thumb_url"];
    image.type = [dic objectForKey:@"type"];
    image.url = [dic objectForKey:@"url"];
    
    return image;
}

@end
