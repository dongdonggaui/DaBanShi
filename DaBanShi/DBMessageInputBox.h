//
//  DBMessageInputBox.h
//  DaBanShi
//
//  Created by huangluyang on 14-4-29.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum DBMessageInputBoxStyle {
    DBMessageInputBoxStyleDefault,
} DBMessageInputBoxStyle;

typedef enum DBMessageInputBoxMode {
    DBMessageInputBoxModeText,
    DBMessageInputBoxModeEmotion,
    DBMessageInputBoxModeAudio
} DBMessageInputBoxMode;

@protocol DBMessageInputBoxDelegate;
@interface DBMessageInputBox : UIView

@property (nonatomic) id<DBMessageInputBoxDelegate> delegate;
@property (nonatomic) DBMessageInputBoxMode inputMode;

- (instancetype)initWithStyle:(DBMessageInputBoxStyle)style;
- (BOOL)isEmotionMode;

@end

@protocol DBMessageInputBoxDelegate <NSObject>

- (void)messageInputBox:(DBMessageInputBox *)inputBox textLineChanged:(CGFloat)changedHeight;
- (void)messageInputBoxDidBegin:(DBMessageInputBox *)inputBox;
- (void)messageInputBoxEmotionButtonDidTapped:(DBMessageInputBox *)inputBox;
- (void)messageInputBoxTextButtonDidTapped:(DBMessageInputBox *)inputBox;

@end

@interface DBEmotionView : UIView

@end

@class DBEmotionContentView;
@protocol DBEmotionContentViewDataSource <NSObject>

- (NSInteger)totalEmotionsInContentView:(DBEmotionContentView *)contentView;
- (NSInteger)numberOfPagesInContentView:(DBEmotionContentView *)contentView;
- (NSInteger)contentView:(DBEmotionContentView *)contentView totalEmotionsAtPage:(NSInteger)page;
- (NSInteger)contentView:(DBEmotionContentView *)contentView numberOfRowsAtPage:(NSInteger)page;
- (NSString *)contentView:(DBEmotionContentView *)contentView pathOfEmotionsAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)contentView:(DBEmotionContentView *)contentView nameOfEmotionsAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DBEmotionContentView : UIScrollView

@property (nonatomic) id<DBEmotionContentViewDataSource> dataSource;

@end
