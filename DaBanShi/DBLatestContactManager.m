//
//  DBLatestContactManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBLatestContactManager.h"

#import "NSFileManager+HLY.h"

static const NSString *kUserDefaultKeyLatestContactList = @"kUserDefaultKeyLatestContactList";
static const NSString *kLatestContactListDirectoryName = @"latestcontacts";

@implementation DBLatestContactManager

+ (instancetype)sharedInstance
{
    static DBLatestContactManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DBLatestContactManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWillEnterBackgroundNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public
- (void)fetchLatestList
{
    [self.latestContactList removeAllObjects];
    NSData *listData = [self readFile];
    if (listData) {
        NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
        [self.latestContactList addObjectsFromArray:list];
    }
}

- (void)updateLatestList
{
    [self writeFile];
}

#pragma mark - private
- (NSString *)userDirectory
{
    return [NSFileManager HLY_userDirectoryForName:(NSString *)kLatestContactListDirectoryName];
}

- (NSData *)readFile
{
    return [NSData dataWithContentsOfFile:[[self userDirectory] stringByAppendingPathComponent:@"latestContacts.archive"]];
}

- (void)writeFile
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.latestContactList];
    BOOL flag = [data writeToFile:[[self userDirectory] stringByAppendingPathComponent:@"latestContacts.archive"] atomically:YES];
    if (!flag) {
        DLog(@"latest contacts save error");
    }
}

#pragma mark - notifiation
- (void)didReceiveMemoryWarningNotification:(NSNotification *)notifation
{
    [self writeFile];
}

- (void)didReceiveWillEnterBackgroundNotification:(NSNotification *)notification
{
    [self writeFile];
}

#pragma mark - setters & getters
- (NSMutableArray *)latestContactList
{
    if (!_latestContactList) {
        _latestContactList = [NSMutableArray array];
    }
    
    return _latestContactList;
}
                

@end
