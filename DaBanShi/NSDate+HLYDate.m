//
//  NSDate+HLYDate.m
//  WeChat
//
//  Created by Cai on 13-5-21.
//  Copyright (c) 2013年 whu. All rights reserved.
//

#import "NSDate+HLYDate.h"

@implementation NSDate (HLYDate)

+ (NSDate *)HLY_dateForTodayBeforeDawn {
    NSCalendar *nowCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [nowCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *targetComponents = [[NSDateComponents alloc] init];
    targetComponents.year = components.year;
    targetComponents.month = components.month;
    targetComponents.day = components.day;
    NSDate *targetDate = [nowCalendar dateFromComponents:targetComponents];
    
    return targetDate;
}

+ (NSDate *)HLY_dateForTomorrowBeforeDawn {
    NSCalendar *nowCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [nowCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *targetComponents = [[NSDateComponents alloc] init];
    targetComponents.year = components.year;
    targetComponents.month = components.month;
    targetComponents.day = components.day + 1;
    NSDate *targetDate = [nowCalendar dateFromComponents:targetComponents];
    
    return targetDate;
}

+ (NSDate *)HLY_dateForYesterdayBeforeDawn {
    NSCalendar *nowCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [nowCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *targetComponents = [[NSDateComponents alloc] init];
    targetComponents.year = components.year;
    targetComponents.month = components.month;
    targetComponents.day = components.day - 1;
    NSDate *targetDate = [nowCalendar dateFromComponents:targetComponents];
    
    return targetDate;
}

+ (NSDate *)HLY_dateForLastWeek {
    NSCalendar *nowCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [nowCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *targetComponents = [[NSDateComponents alloc] init];
    targetComponents.year = components.year;
    targetComponents.month = components.month;
    targetComponents.day = components.day - 7;
    NSDate *targetDate = [nowCalendar dateFromComponents:targetComponents];
    
    return targetDate;
}

+ (NSDate *)HLY_dateForLongDisplayTime:(NSString *)displayTime
{
    NSString *standardFormat = @"2014-03-04 15:59:30";
    NSString *standardDisplayTime = [displayTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    standardDisplayTime = [standardDisplayTime substringToIndex:standardFormat.length - 1];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [df dateFromString:standardDisplayTime];
    
    return date;
}

+ (NSString *)HLY_displayDate:(NSDate *)date {
    NSString *timeString = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *todyBeforeDawn = [NSDate HLY_dateForTodayBeforeDawn];
    NSDate *tomorrowBeforeDawn = [NSDate HLY_dateForTomorrowBeforeDawn];
    NSDate *yesterdyBeforeDawn = [NSDate HLY_dateForYesterdayBeforeDawn];
    NSDate *lastWeek = [NSDate HLY_dateForLastWeek];
    // 当天的消息时间显示格式
    if ([date timeIntervalSinceDate:todyBeforeDawn] > 0 &&
        [date timeIntervalSinceDate:tomorrowBeforeDawn] < 0) {
        
        dateFormatter.dateFormat = @"HH:mm";
        timeString = [dateFormatter stringFromDate:date];
        
    }
    // 前一天的消息时间显示格式为"昨天"
    else if ([date timeIntervalSinceDate:todyBeforeDawn] < 0 &&
             [date timeIntervalSinceDate:yesterdyBeforeDawn] > 0) {
        
//        timeString = NSLocalizedString(@"yesterday", @"");
        timeString = NSLocalizedString(@"昨天", @"");
        
    }
    // 一周内的消息时间显示格式为"星期几"
    else if ([date timeIntervalSinceDate:yesterdyBeforeDawn] < 0 &&
             [date timeIntervalSinceDate:lastWeek] > 0) {
        dateFormatter.dateFormat = @"c";
        timeString = [dateFormatter stringFromDate:date];
        switch (timeString.intValue) {
            case 1:
//                timeString = NSLocalizedString(@"Sunday", @"");
                timeString = NSLocalizedString(@"星期日", @"");
                break;
            case 2:
//                timeString = NSLocalizedString(@"Monday", @"");
                timeString = NSLocalizedString(@"星期一", @"");
                break;
            case 3:
//                timeString = NSLocalizedString(@"Tuesday", @"");
                timeString = NSLocalizedString(@"星期二", @"");
                break;
            case 4:
//                timeString = NSLocalizedString(@"Wednesday", @"");
                timeString = NSLocalizedString(@"星期三", @"");
                break;
            case 5:
//                timeString = NSLocalizedString(@"Thursday", @"");
                timeString = NSLocalizedString(@"星期四", @"");
                break;
            case 6:
//                timeString = NSLocalizedString(@"Friday", @"");
                timeString = NSLocalizedString(@"星期五", @"");
                break;
                
            default:
//                timeString = NSLocalizedString(@"Saturday", @"");
                timeString = NSLocalizedString(@"星期六", @"");
                break;
        }
        
    }
    // 一周以外的消息时间显示格式
    else {
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        timeString = [dateFormatter stringFromDate:date];
    }
    
    return timeString;
}

+ (NSString *)HLY_displayLongDate:(NSDate *)date {
    NSString *timeString = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *todyBeforeDawn = [NSDate HLY_dateForTodayBeforeDawn];
    NSDate *tomorrowBeforeDawn = [NSDate HLY_dateForTomorrowBeforeDawn];
    NSDate *yesterdyBeforeDawn = [NSDate HLY_dateForYesterdayBeforeDawn];
    NSDate *lastWeek = [NSDate HLY_dateForLastWeek];
    // 当天的消息时间显示格式
    if ([date timeIntervalSinceDate:todyBeforeDawn] > 0 &&
        [date timeIntervalSinceDate:tomorrowBeforeDawn] < 0) {
        
        dateFormatter.dateFormat = @"HH:mm";
        timeString = [dateFormatter stringFromDate:date];
        
    }
    // 前一天的消息时间显示格式为"昨天"
    else if ([date timeIntervalSinceDate:todyBeforeDawn] < 0 &&
             [date timeIntervalSinceDate:yesterdyBeforeDawn] > 0) {
        
        timeString = NSLocalizedString(@"yesterday", @"");
        
    }
    // 一周内的消息时间显示格式为"星期几"
    else if ([date timeIntervalSinceDate:yesterdyBeforeDawn] < 0 &&
             [date timeIntervalSinceDate:lastWeek] > 0) {
        dateFormatter.dateFormat = @"c";
        timeString = [dateFormatter stringFromDate:date];
        switch (timeString.intValue) {
            case 1:
                timeString = NSLocalizedString(@"Sunday", @"");
                break;
            case 2:
                timeString = NSLocalizedString(@"Monday", @"");
                break;
            case 3:
                timeString = NSLocalizedString(@"Tuesday", @"");
                break;
            case 4:
                timeString = NSLocalizedString(@"Wednesday", @"");
                break;
            case 5:
                timeString = NSLocalizedString(@"Thursday", @"");
                break;
            case 6:
                timeString = NSLocalizedString(@"Friday", @"");
                break;
                
            default:
                timeString = NSLocalizedString(@"Saturday", @"");
                break;
        }
        
    }
    // 一周以外的消息时间显示格式
    else {
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        timeString = [dateFormatter stringFromDate:date];
    }
    
    return timeString;
}

@end
