//
//  DBVibriteManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-8.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBVibriteManager : NSObject

+ (instancetype)sharedInstance;

- (void)startShake;
- (void)stopShake;

@end
