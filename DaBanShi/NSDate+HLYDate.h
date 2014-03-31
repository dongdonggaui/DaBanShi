//
//  NSDate+HLYDate.h
//  WeChat
//
//  Created by Cai on 13-5-21.
//  Copyright (c) 2013年 whu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HLYDate)

+ (NSDate *)HLY_dateForTodayBeforeDawn;
+ (NSDate *)HLY_dateForTomorrowBeforeDawn;
+ (NSDate *)HLY_dateForYesterdayBeforeDawn;
+ (NSDate *)HLY_dateForLastWeek;
+ (NSDate *)HLY_dateForLongDisplayTime:(NSString *)displayTime;

// 根据日期过去时间设置日期显示格式
+ (NSString *)HLY_displayDate:(NSDate *)date;
+ (NSString *)HLY_displayLongDate:(NSDate *)date;

@end
