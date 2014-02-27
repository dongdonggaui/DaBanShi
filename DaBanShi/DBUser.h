//
//  DBUser.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUser : NSObject <NSCoding>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avator;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, strong) NSString *address;

@end
