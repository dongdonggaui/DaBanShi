//
//  DBMessage.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBMessage.h"

@interface DBMessage ()

@property (nonatomic) DBUser *user;
@property (nonatomic) DBMessageType type;
@property (nonatomic) NSString *content;
@property (nonatomic) NSDate *createTime;

@end

@implementation DBMessage

+ (instancetype)messageWithContent:(NSString *)content createTime:(NSDate *)createTime messageType:(DBMessageType)type user:(DBUser *)user
{
    DBMessage *message = [[DBMessage alloc] init];
    message.type = type;
    message.content = content;
    message.createTime = createTime;
    message.user = user;
    
    return message;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
}

- (BOOL)needToDisplayTime
{
    return YES;
}

@end
