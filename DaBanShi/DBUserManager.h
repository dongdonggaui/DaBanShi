//
//  DBUserManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface DBUserManager : NSObject

+ (instancetype)sharedInstance;
- (void)fetchAllDaBanShiOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
