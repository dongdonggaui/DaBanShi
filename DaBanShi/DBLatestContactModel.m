//
//  DBLatestContactModel.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBLatestContactModel.h"

@interface DBLatestContactModel ()

@property (nonatomic) DBUser *user;
@property (nonatomic) NSString *content;
@property (nonatomic) NSDate *createTime;

@end

@implementation DBLatestContactModel

+ (instancetype)instanceWithContent:(NSString *)content createTime:(NSDate *)createTime user:(DBUser *)user
{
    DBLatestContactModel *model = [[DBLatestContactModel alloc] init];
    model.content = content;
    model.createTime = createTime;
    model.user = user;
    
    return model;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.unreadCount = [[aDecoder decodeObjectForKey:@"cunreadCount"] integerValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.unreadCount] forKey:@"unreadCount"];
}

@end
