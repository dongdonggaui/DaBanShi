//
//  DBFirmManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-3-30.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBBusinessManager.h"

@interface DBFirmManager : DBBusinessManager

+ (instancetype)sharedInstance;

- (void)fetchAllFirmsAtPage:(NSInteger)page
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
