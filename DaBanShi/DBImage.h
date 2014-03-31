//
//  HLYImage.h
//  Haoweidao
//
//  Created by huangluyang on 14-3-12.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import "DBModel.h"

@interface DBImage : DBModel

@property (nonatomic) NSString *imageId;
@property (nonatomic) NSString *thumbUrl;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *url;

+ (instancetype)imageWithProperties:(NSDictionary *)properties;

@end
