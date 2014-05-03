//
//  DBEmotion.m
//  DaBanShi
//
//  Created by huangluyang on 14-5-2.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBEmotion.h"

@implementation DBEmotion

+ (instancetype)emotionWithKey:(NSString *)key path:(NSString *)path
{
    DBEmotion *emotion = [[DBEmotion alloc] init];
    emotion.emotionKey = key;
    emotion.emotionPath = path;
    
    return emotion;
}

@end
