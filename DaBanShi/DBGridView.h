//
//  DBGridView.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBGridView;
@protocol DBGridViewDelegate <NSObject>

@optional
- (void)gridView:(DBGridView *)gridView didTappedAtIndex:(NSInteger)index;

@end

@interface DBGridView : UIScrollView

@property (nonatomic, weak) id<DBGridViewDelegate> gridDelegate;

- (instancetype)initWithFrame:(CGRect)frame contents:(NSArray *)contents;

@end
