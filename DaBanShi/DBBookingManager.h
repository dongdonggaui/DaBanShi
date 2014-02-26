//
//  DBBookingManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-26.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBBookingManager : NSObject

+ (instancetype)sharedInstance;

- (NSMutableArray *)testBooking;

@end
