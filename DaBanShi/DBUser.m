//
//  DBUser.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBUser.h"

#import "NSDictionary+NetworkProperties.h"
#import "NSDate+HLYDate.h"

@implementation DBUser

+ (instancetype)userWithProperties:(NSDictionary *)properties
{
    if (properties == nil) {
        return nil;
    }
    
    DBUser *user = [[DBUser alloc] init];
    NSDictionary *dic = [properties dictionaryByRemoveNull];
    user.avatorId = [dic objectForKey:@"avator_id"];
    user.avatorUrl = [dic objectForKey:@"avator"];
    user.city = [dic objectForKey:@"city"];
    user.email = [dic objectForKey:@"email"];
    user.userId = [dic objectForKey:@"user_id"];
    user.username = [dic objectForKey:@"username"];
    user.phone = [dic objectForKey:@"phone"];
    user.gender = [dic objectForKey:@"gender"];
    user.nickname = [dic objectForKey:@"nickname"];
    user.signature = [dic objectForKey:@"signature"];
    user.address = [dic objectForKey:@"address"];
    user.userDescription = [dic objectForKey:@"description"];
    user.type = [dic objectForKey:@"type"];
    user.age = [dic objectForKey:@"age"];
    user.creditRate = [dic objectForKey:@"credit_rate"];
    user.sourceId = [dic objectForKey:@"source"];
    NSString *dateStr = [dic objectForKey:@"birthday"];
    if (dateStr.length > 0) {
        NSDate *date = [NSDate HLY_dateForLongDisplayTime:dateStr];
        user.birthday = date;
    }
    
    return user;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.avatorId = [aDecoder decodeObjectForKey:@"avator_id"];
        self.avatorUrl = [aDecoder decodeObjectForKey:@"avator"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.userId = [aDecoder decodeObjectForKey:@"user_id"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.userDescription = [aDecoder decodeObjectForKey:@"description"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.creditRate = [aDecoder decodeObjectForKey:@"credit_rate"];
        self.sourceId = [aDecoder decodeObjectForKey:@"source"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId forKey:@"user_id"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.avatorId forKey:@"avator_id"];
    [aCoder encodeObject:self.avatorUrl forKey:@"avator_url"];
    [aCoder encodeObject:self.userDescription forKey:@"user_description"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.sourceId forKey:@"source"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<\nClass: %@;\nuserId : %@;\nusername : %@\nnickname : %@;\navator : %@;\nuserDescription : %@;\naddress : %@;\ncity : %@;\nemail : %@;\nphone : %@;\ngender : %@;\nsignature : %@;\nbirthday : %@;\ntype : %@\n;\nage : %@;\navatorId : %@;\nsourceId : %@\n>", NSStringFromClass([self class]), self.userId, self.username, self.nickname, self.avatorUrl, self.userDescription, self.address, self.city, self.email, self.phone, self.gender, self.signature, self.birthday, self.type, self.age, self.avatorId, self.sourceId];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.userDescription = value;
    } else if ([key isEqualToString:@"birthday"]) {
        NSDate *date = [NSDate HLY_dateForLongDisplayTime:value];
        if (date) {
            self.birthday = date;
        }
        
    } else if ([key isEqualToString:@"user_id"]) {
        self.userId = value;
        
    } else if ([key isEqualToString:@"credit_rate"]) {
        self.creditRate = value;
        
    } else if ([key isEqualToString:@"avator_id"]) {
        self.avatorId = value;
        
    } else if ([key isEqualToString:@"avator"]) {
        self.avatorUrl = value;
        
    } else if ([key isEqualToString:@"source_id"]) {
        self.sourceId = value;
        
    } else {
        [super setValue:value forKey:key];
    }
}


#pragma mark - public
- (NSDictionary *)encodedUesr
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:12];
    if (self.nickname) {
        [dic setObject:self.nickname forKey:@"nickname"];
    }
    if (self.avatorId) {
        [dic setObject:self.avatorId forKey:@"avator_id"];
    }
    if (self.avatorUrl) {
        [dic setObject:self.avatorUrl forKey:@"avator"];
    }
    if (self.userDescription) {
        [dic setObject:self.userDescription forKey:@"description"];
    }
    if (self.address) {
        [dic setObject:self.address forKey:@"address"];
    }
    if (self.city) {
        [dic setObject:self.city forKey:@"city"];
    }
    if (self.email) {
        [dic setObject:self.email forKey:@"email"];
    }
    if (self.phone) {
        [dic setObject:self.phone forKey:@"phone"];
    }
    if (self.signature) {
        [dic setObject:self.signature forKey:@"signature"];
    }
    if (self.gender) {
        [dic setObject:self.gender forKey:@"gender"];
    }
    if (self.sourceId) {
        [dic setObject:self.sourceId forKey:@"source"];
    }
    if (self.birthday) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd";
        [dic setObject:[df stringFromDate:self.birthday] forKey:@"birthday"];
    }
    
    return dic;
}

@end