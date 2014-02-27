//
//  DBAPIHTTPClient.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "AFHTTPClient.h"

@interface DBAPIHTTPClient : AFHTTPClient

+ (instancetype)sharedInstance;

@end
