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

#endif
