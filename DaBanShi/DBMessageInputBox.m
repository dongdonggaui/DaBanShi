//
//  DBMessageInputBox.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-29.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBMessageInputBox.h"

#import "DBEmotion.h"

#import "UIColor+DaBanShi.h"

@interface DBMessageInputBox () <UITextViewDelegate>

@property (nonatomic) UIButton *emotionButton;
@property (nonatomic) UIButton *textButton;
@property (nonatomic) UITextView *textView;
@property (nonatomic) UIButton *sendButton;
@property (nonatomic) DBEmotionView *emotionView;

/// 用于多行输入高度自适应
@property (nonatomic) CGFloat textViewInitHeight;
@property (nonatomic) CGFloat textViewHeightBeforeInput;
@property (nonatomic) CGFloat theInitHeight;

@end

@implementation DBMessageInputBox

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithStyle:(DBMessageInputBoxStyle)style
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (self = [self initWithFrame:CGRectMake(0, 0, screenBounds.size.width, 44)]) {
        _theInitHeight = self.frame.size.height;
        
        _emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emotionView = [[DBEmotionView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 216)];
        
        [self addSubview:_emotionButton];
        [self insertSubview:_textButton belowSubview:_emotionButton];
        [self addSubview:_sendButton];
        [self addSubview:_emotionView];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.delegate = self;
        _textViewInitHeight = 30;
        _textViewHeightBeforeInput = 30;
        [self addSubview:_textView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextViewTextChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.userInteractionEnabled = YES;
    UIImage *background = [UIImage imageNamed:@"ToolViewBkg_Black_ios7"];
    self.layer.contents = (id)background.CGImage;
    
    UIImage *emotionIcon = [UIImage imageNamed:@"ToolViewEmotion_ios7"];
    UIImage *emotionIconHighlight = [UIImage imageNamed:@"ToolViewEmotionHL_ios7"];
    self.emotionButton.width = emotionIcon.size.width;
    self.emotionButton.height = emotionIcon.size.height;
    self.emotionButton.x = 10;
    self.emotionButton.y = ceilf((self.height - self.emotionButton.height) / 2);
    [self.emotionButton setImage:emotionIcon forState:UIControlStateNormal];
    [self.emotionButton setImage:emotionIconHighlight forState:UIControlStateHighlighted];
    [self.emotionButton addTarget:self action:@selector(emotionButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *textIcon = [UIImage imageNamed:@"ToolViewKeyboard_ios7"];
    UIImage *textIconHighlight = [UIImage imageNamed:@"ToolViewKeyboardHL_ios7"];
    self.textButton.width = textIcon.size.width;
    self.textButton.height = textIcon.size.height;
    self.textButton.x = self.emotionButton.x;
    self.textButton.y = self.emotionButton.y;
    [self.textButton setImage:textIcon forState:UIControlStateNormal];
    [self.textButton setImage:textIconHighlight forState:UIControlStateHighlighted];
    [self.textButton addTarget:self action:@selector(textButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendButton.backgroundColor = [UIColor softBlue];
    self.sendButton.width = 50;
    self.sendButton.height = 30;
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.x = self.width - self.sendButton.width - 5;
    self.sendButton.y = ceilf((self.height - self.sendButton.height) / 2);
    self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.x = self.emotionButton.x + self.emotionButton.width + 5;
    self.textView.height = 30;
    self.textView.y = ceilf((self.height - self.textView.height) / 2);
    self.textView.width = self.sendButton.x - self.textView.x - 5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (BOOL)becomeFirstResponder
{
    self.emotionButton.alpha = 1;
    self.textButton.alpha = 0;
    return [self.textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}


#pragma mark - public
- (BOOL)isEmotionMode
{
    return self.emotionButton.alpha == 0;
}


#pragma mark - private
- (void)emotionButtonDidTapped:(UIButton *)sender
{
//    NSInteger emotionIndex = [self.subviews indexOfObject:self.emotionButton];
//    NSInteger textIndex = [self.subviews indexOfObject:self.textButton];
//    [self exchangeSubviewAtIndex:emotionIndex withSubviewAtIndex:textIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageInputBoxEmotionButtonDidTapped:)]) {
        [self.delegate messageInputBoxEmotionButtonDidTapped:self];
    }
    self.inputMode = DBMessageInputBoxModeEmotion;
}

- (void)textButtonDidTapped:(UIButton *)sender
{
//    NSInteger emotionIndex = [self.subviews indexOfObject:self.emotionButton];
//    NSInteger textIndex = [self.subviews indexOfObject:self.textButton];
//    [self exchangeSubviewAtIndex:emotionIndex withSubviewAtIndex:textIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageInputBoxTextButtonDidTapped:)]) {
        [self.delegate messageInputBoxTextButtonDidTapped:self];
    }
    self.inputMode = DBMessageInputBoxModeText;
}

- (void)sendButtonDidTapped:(UIButton *)sender
{
    DLog(@"发送");
}


#pragma mark - setters & getters
- (void)setInputMode:(DBMessageInputBoxMode)inputMode
{
    if (_inputMode != inputMode) {
        _inputMode = inputMode;
        if (inputMode == DBMessageInputBoxModeText) {
            self.emotionButton.alpha = 1;
            self.textButton.alpha = 0;
        } else if (inputMode == DBMessageInputBoxModeEmotion) {
            self.emotionButton.alpha = 0;
            self.textButton.alpha = 1;
        }
    }
}


#pragma mark - notification
- (void)didReceiveTextViewTextChanged:(NSNotification *)notification
{
    UITextView *textView = notification.object;
    if (textView.contentSize.height != self.textViewHeightBeforeInput) {
        CGFloat deltaHeight = textView.contentSize.height - self.textViewHeightBeforeInput;
        self.textViewHeightBeforeInput = textView.contentSize.height;
        if (textView.height < 86 && self.delegate && [self.delegate respondsToSelector:@selector(messageInputBox:textLineChanged:)]) {
            [self.delegate messageInputBox:self textLineChanged:deltaHeight];
            self.height += deltaHeight;
            self.textView.height += deltaHeight;
        }
    }
}


#pragma mark - text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.inputMode = DBMessageInputBoxModeText;
}

@end


@interface DBEmotionView () <DBEmotionContentViewDataSource>

@property (nonatomic) NSArray *emotions;
@property (nonatomic) DBEmotionContentView *classicalEmotionsView;

@end

@implementation DBEmotionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _classicalEmotionsView = [[DBEmotionContentView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 44)];
        _classicalEmotionsView.dataSource = self;
        
        [self addSubview:_classicalEmotionsView];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Emotions" withExtension:@"plist"];
        _emotions = [NSArray arrayWithContentsOfURL:url];
    }
    
    return self;
}

#pragma mark - emotion content data source
- (NSInteger)totalEmotionsInContentView:(DBEmotionContentView *)contentView
{
    return 105;
}

- (NSInteger)numberOfPagesInContentView:(DBEmotionContentView *)contentView
{
    return 4;
}

- (NSInteger)contentView:(DBEmotionContentView *)contentView totalEmotionsAtPage:(NSInteger)page
{
    return 21;
}

- (NSInteger)contentView:(DBEmotionContentView *)contentView numberOfRowsAtPage:(NSInteger)page
{
    return 7;
}

- (NSString *)contentView:(DBEmotionContentView *)contentView pathOfEmotionsAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger countPerPage = [self contentView:contentView totalEmotionsAtPage:indexPath.section] - 1;
    if (indexPath.row == countPerPage) {
        return @"DeleteEmoticonBtn_ios7";
    } else {
        NSInteger index = indexPath.row + (indexPath.section * countPerPage);
        NSDictionary *emotion = [self.emotions objectAtIndex:index];
        return [NSString stringWithFormat:@"Expression_%@", [emotion objectForKey:@"path"]];
    }
}

- (NSString *)contentView:(DBEmotionContentView *)contentView nameOfEmotionsAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger countPerPage = [self contentView:contentView totalEmotionsAtPage:indexPath.section];
    if (row == countPerPage) {
        return @"DeleteEmoticonBtn_ios7";
    } else {
        NSDictionary *emotion = [self.emotions objectAtIndex:row + (indexPath.section * countPerPage)];
        return [emotion objectForKey:@"key"];
    }
}

@end

@implementation DBEmotionContentView


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.dataSource) {
        return;
    }
    
    NSInteger pages = [self.dataSource numberOfPagesInContentView:self];
    self.contentSize = CGSizeMake(self.width * pages, self.height);
    CGFloat emotionMargin = 15;
    for (int i = 0; i < pages; i++) {
        NSInteger rows = [self.dataSource contentView:self numberOfRowsAtPage:i];
        NSInteger count = [self.dataSource contentView:self totalEmotionsAtPage:i];
        CGFloat cellWidth = ceilf((self.width - (rows + 1) * emotionMargin) / rows);
        for (int j = 0; j < count; j++) {
            UIImageView *emotionCellView = [[UIImageView alloc] initWithFrame:CGRectMake(emotionMargin + (j % rows) * (emotionMargin + cellWidth) + i * self.width, emotionMargin + (j / rows) * (emotionMargin + cellWidth), cellWidth, cellWidth)];
            [self addSubview:emotionCellView];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NSString *path = [self.dataSource contentView:self pathOfEmotionsAtIndexPath:indexPath];
            UIImage *emotion = [UIImage imageNamed:path];
            emotionCellView.image = emotion;
        }
    }
}



@end
