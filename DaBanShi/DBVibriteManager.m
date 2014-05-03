//
//  DBVibriteManager.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-8.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "DBVibriteManager.h"

@interface DBVibriteManager ()

@property (nonatomic) NSTimer *timer;
@property (nonatomic) BOOL shakeStop;

@end

@implementation DBVibriteManager

+ (instancetype)sharedInstance
{
    static DBVibriteManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[DBVibriteManager alloc] init];
            AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL);
        }
    });
    
    return sharedManager;
}

#pragma mark - public
- (void)startShake
{
    self.shakeStop = NO;
    [self shake];
}

- (void)stopShake
{
    self.shakeStop = YES;
}

#pragma mark - private
- (void)shake
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

void MyAudioServicesSystemSoundCompletionProc (SystemSoundID  ssID,void *clientData)
{
    if (![DBVibriteManager sharedInstance].shakeStop) {
        [[DBVibriteManager sharedInstance] shake];
    }
}

@end
