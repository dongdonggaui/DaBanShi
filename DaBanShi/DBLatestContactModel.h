//
//  DBLatestContactModel.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBModel.h"

@class DBUser;
@interface DBLatestContactModel : DBModel <NSCoding>

@property (nonatomic, readonly) DBUser *user;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSDate *createTime;
@property (nonatomic) NSInteger unreadCount;

+ (instancetype)instanceWithContent:(NSString *)content createTime:(NSDate *)createTime user:(DBUser *)user;

@end
