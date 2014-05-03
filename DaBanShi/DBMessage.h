//
//  DBMessage.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBModel.h"

typedef enum DBMessageType {
    DBMessageTypeSelf,
    DBMessageTypeOther
} DBMessageType;

@class DBUser;

@interface DBMessage : DBModel <NSCoding>

@property (nonatomic, readonly) DBUser *user;
@property (nonatomic, readonly) DBMessageType type;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSDate *createTime;

/**
 类工厂方法
 */
+ (instancetype)messageWithContent:(NSString *)content createTime:(NSDate *)createTime messageType:(DBMessageType)type user:(DBUser *)user;

/**
 判定是否此消息需要显示到达/发送时间
 */
- (BOOL)needToDisplayTime;

/**
 返回消息的显示视图
 */
//- (UIView *)displayView;

@end
