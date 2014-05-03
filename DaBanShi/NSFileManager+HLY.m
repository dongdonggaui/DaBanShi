//
//  NSFileManager+HLY.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "NSFileManager+HLY.h"

@implementation NSFileManager (HLY)

+ (NSString *)HLY_userDirectoryForName:(NSString *)directoryName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSString *directory = [documentsDirectory stringByAppendingPathComponent:directoryName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DLog(@"create directory error --> %@", error);
            return nil;
        }
    }
    
    return directory;
}

@end
