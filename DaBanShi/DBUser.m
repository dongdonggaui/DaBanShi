//
//  DBUser.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBUser.h"

@implementation DBUser

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userId = [aDecoder decodeObjectForKey:@"user_id"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.avator = [aDecoder decodeObjectForKey:@"avator"];
        self.userDescription = [aDecoder decodeObjectForKey:@"description"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId forKey:@"user_id"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.avator forKey:@"avator"];
    [aCoder encodeObject:self.userDescription forKey:@"description"];
    [aCoder encodeObject:self.address forKey:@"address"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nClass: %@\nuserId = %@\nusername = %@\nnickname = %@\navator = %@\nuserDescription = %@\n", NSStringFromClass([self class]), self.userId, self.username, self.nickname, self.avator, self.userDescription];
}

@end