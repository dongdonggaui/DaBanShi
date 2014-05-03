//
//  DBLatestContactManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBLatestContactManager : NSObject

@property (nonatomic) NSMutableArray *latestContactList;

+ (instancetype)sharedInstance;

/**
 获取最近联系列表
 */
- (void)fetchLatestList;

/**
 更新最近联系列表
 */
- (void)updateLatestList;

@end
