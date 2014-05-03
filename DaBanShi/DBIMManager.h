//
//  DBIMManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBBusinessManager.h"

@class DBMessage;
@class DBIMMessageCell;
@protocol DBIMDelegate;
@interface DBIMManager : DBBusinessManager

@property (nonatomic, weak) id<DBIMDelegate> delegate;
@property (nonatomic, strong, readonly) NSString *uid;
@property (nonatomic, strong, readonly) NSMutableArray *messages;

- (instancetype)initWithUID:(NSString *)uid;

/**
 拉去消息
 */
- (void)fetchMessagesForUID:(NSString *)uid;

- (DBIMMessageCell *)messageCellAtIndex:(NSInteger)index identifier:(NSString *)identifier;
- (CGFloat)cellHeightForMessageAtIndex:(NSInteger)index;

@end

@protocol DBIMDelegate <NSObject>

- (void)didReceiveMessage:(DBMessage *)message;
- (UIFont *)fontForIMManager:(DBIMManager *)manager;

@end
