//
//  DBHeader.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#ifndef DaBanShi_DBHeader_h
#define DaBanShi_DBHeader_h

#define DBSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DBTextAlignCenter (DBSystemVersion > 5 ? NSTextAlignmentCenter : UITextAlignmentCenter)

//use dlog to print while in debug model
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

//************************************************************************************

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define HLYSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define HLYTextAlignmentCenter (HLYSystemVersion >= 6 ? NSTextAlignmentCenter : UITextAlignmentCenter)
#define HLYTextAlignmentLeft (HLYSystemVersion >= 6 ? NSTextAlignmentLeft : UITextAlignmentLeft)
#define HLYTextAlignmentRight (HLYSystemVersion >= 6 ? NSTextAlignmentRight : UITextAlignmentRight)

#define HLYViewHeight (HLYSystemVersion >= 7 ? self.view.frame.size.height - 64 : self.view.frame.size.height)

//************************************************************************************

#import "UIView+ModifyFrame.h"

#endif
