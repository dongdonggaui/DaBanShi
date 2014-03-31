//
//  DBUser.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBModel.h"

@interface DBUser : DBModel <NSCoding>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatorId;
@property (nonatomic, strong) NSString *avatorUrl;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic) NSDate *birthday;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *signature;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *organize;
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSNumber *age;
@property (nonatomic) NSNumber *creditRate;

+ (instancetype)userWithProperties:(NSDictionary *)properties;
- (NSDictionary *)encodedUesr;

@end
