//
//  DBIMMessageView.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBMessageInputBox;
@class DBIMMessageCell;
@protocol DBIMMessageViewDataSource;
@protocol DBIMMessageViewDelegate;
@interface DBIMMessageView : UIView

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) DBMessageInputBox *inputBox;
@property (nonatomic, readonly) CGFloat deltaHeight; /// 用于自适应高度
@property (nonatomic, weak) id<DBIMMessageViewDataSource> dataSource;
@property (nonatomic, weak) id<DBIMMessageViewDelegate> delegate;

- (void)reloadData;
- (DBIMMessageCell *)dequeueReuseCellForIdentifier:(NSString *)identifier;
- (void)scrollToBottomAnimated:(BOOL)animated;

@end

@protocol DBIMMessageViewDataSource <NSObject>

- (NSInteger)numberOfMessageInMessageView:(DBIMMessageView *)messageView;
- (DBIMMessageCell *)messageView:(DBIMMessageView *)messageView cellAtIndexPath:(NSInteger)index;
- (CGFloat)messageView:(DBIMMessageView *)messageView heightForRowAtIndexPath:(NSInteger)index;

@end

@protocol DBIMMessageViewDelegate <NSObject>

- (void)messageViewDidEndEditing:(DBIMMessageView *)messageView;

@end
