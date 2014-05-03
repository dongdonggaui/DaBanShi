//
//  DBEmotion.h
//  DaBanShi
//
//  Created by huangluyang on 14-5-2.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBEmotion : NSObject

@property (nonatomic) NSString *emotionKey;
@property (nonatomic) NSString *emotionPath;

+ (instancetype)emotionWithKey:(NSString *)key path:(NSString *)path;

@end
