//
//  DBSocialManager.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-3.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DBSocialType {
    DBSocialTypeSina,
    DBSocialTypeQQ,
    DBSocialTypeWeChat,
    DBSocialTypeRenren
} DBSocialType;

@interface DBSocialManager : NSObject

/// 注册角色选择 1.打版师 2.厂商 3.销售商
@property (nonatomic) NSInteger actorIdentifier;

+ (instancetype)sharedInstance;

/**
 注册社会化组件
 */
- (void)registerSocialComponents;

/**
 处理应用间调用
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 第三方登录登录
 @params type 社会化组件类型
 */
- (void)loginWithType:(DBSocialType)type inViewController:(UIViewController *)viewController;

/**
 取消授权
 */
- (void)cancelAuthWithType:(DBSocialType)type;

@end
