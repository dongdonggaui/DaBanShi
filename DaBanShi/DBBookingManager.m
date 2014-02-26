//
//  DBBookingManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBBookingManager.h"

@implementation DBBookingManager

+ (instancetype)sharedInstance
{
    static DBBookingManager *sharedBookingManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedBookingManager == nil) {
            sharedBookingManager = [[DBBookingManager alloc] init];
        }
    });
    
    return sharedBookingManager;
}

- (NSMutableArray *)testBooking
{
    NSMutableArray *bookingList = [NSMutableArray arrayWithCapacity:15];
    int startTime = 9;
    int i;
    for (i = 0; i < 15; i++) {
        NSString *timeInterval = [NSString stringWithFormat:@"%d:00 - %d:00", startTime + i, startTime + i + 1];
        int flag = arc4random() % 2;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:timeInterval, @"timeInterval", flag ? @"已预约" : @"未预约", @"bookingStatus", nil];
        [bookingList addObject:dic];
    }
    
    return bookingList;
}

@end
