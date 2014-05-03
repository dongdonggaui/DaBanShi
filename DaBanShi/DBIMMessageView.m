//
//  DBIMMessageView.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBIMMessageView.h"
#import "DBIMMessageCell.h"
#import "DBMessageInputBox.h"

#import "DBKeyboardUtility.h"

#import "UIFont+HLY.h"
#import "UIColor+Convenience.h"

@interface DBIMMessageView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, DBMessageInputBoxDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) DBMessageInputBox *inputBox;
@property (nonatomic) CGFloat deltaHeight;
/// 用于字符表情切换
@property (nonatomic) BOOL showKeyboard;

@end

@implementation DBIMMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _deltaHeight = frame.origin.y;
        _showKeyboard = YES;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 44)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        _inputBox = [[DBMessageInputBox alloc] initWithStyle:DBMessageInputBoxStyleDefault];
        _inputBox.delegate = self;
        _inputBox.y = _tableView.height;
        [self addSubview:_inputBox];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapped:)];
        tap.delegate = self;
        [_tableView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        pan.delegate = self;
        [_tableView addGestureRecognizer:pan];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        pinch.delegate = self;
        [_tableView addGestureRecognizer:pan];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        swipe.delegate = self;
        [_tableView addGestureRecognizer:pan];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveKeyboardWillChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}


#pragma mark - public
- (DBIMMessageCell *)dequeueReuseCellForIdentifier:(NSString *)identifier
{
    return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.height) animated:animated];
}


#pragma mark - private
- (void)didSingleTapped:(UITapGestureRecognizer *)tap
{
    [self resetFrame];
}

- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    [self resetFrame];
}

- (void)resetFrame
{
    [self.inputBox endEditing:YES];
    self.y = self.deltaHeight;
}


#pragma mark - setters & getters
- (UIEdgeInsets)contentInset
{
    return self.tableView.contentInset;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    self.tableView.contentInset = contentInset;
}


#pragma mark - notification
- (void)didReceiveKeyboardWillChangeNotification:(NSNotification *)notification
{
    
    if (self.showKeyboard) {
        [DBKeyboardUtility handleKeyboardWillChangeFrameNotification:notification tobeAdjustView:self.inputBox withView:self delta:self.deltaHeight];
    } else {

    }
}


#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfMessageInMessageView:)]) {
        return [self.dataSource numberOfMessageInMessageView:self];
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageView:heightForRowAtIndexPath:)]) {
        return [self.dataSource messageView:self heightForRowAtIndexPath:indexPath.row];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageView:cellAtIndexPath:)]) {
        return [self.dataSource messageView:self cellAtIndexPath:indexPath.row];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noMessageCell"];
    cell.textLabel.text = @"暂无消息";
    cell.textLabel.textAlignment = HLYTextAlignmentCenter;
    cell.textLabel.font = [UIFont HLY_smallFont];
    cell.textLabel.textColor = [UIColor HLY_grayTextColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - input box delegate
- (void)messageInputBox:(DBMessageInputBox *)inputBox textLineChanged:(CGFloat)changedHeight
{
    self.y -= changedHeight;
    self.height += changedHeight;
    self.deltaHeight -= changedHeight;
}

- (void)messageInputBoxEmotionButtonDidTapped:(DBMessageInputBox *)inputBox
{
    self.showKeyboard = [inputBox isEmotionMode];
    [inputBox resignFirstResponder];
}

- (void)messageInputBoxTextButtonDidTapped:(DBMessageInputBox *)inputBox
{
    self.showKeyboard = [inputBox isEmotionMode];
    if (self.showKeyboard) {
        [inputBox becomeFirstResponder];
    }
}


@end
