//
//  DBDanbanshiManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-3-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBBusinessManager.h"

@interface DBPatternMakerManager : DBBusinessManager

+ (instancetype)sharedInstance;

/**
 获取打版师列表
 */
- (void)fetchAllDanbanshiAtPage:(NSInteger)page
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
