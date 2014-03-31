//
//  NSDictionary+NetworkProperties.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "NSDictionary+NetworkProperties.h"

@implementation NSDictionary (NetworkProperties)

- (NSDictionary *)dictionaryByRemoveNull
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:self.allKeys.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj != [NSNull null]) {
            [dic setObject:obj forKey:key];
        }
    }];
    
    return dic;
}

@end
