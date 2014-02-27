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

#endif
