//
//  DBIMViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-4-23.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBIMViewController.h"
#import "DBIMMessageView.h"
#import "DBMessageInputBox.h"
#import "DBIMMessageCell.h"
#import "DBIMManager.h"
#import "DBKeyboardUtility.h"

#import "DBUser.h"

@interface DBIMViewController () <DBIMMessageViewDataSource>

@property (nonatomic, strong) DBIMManager *imManager;
@property (nonatomic, strong) DBIMMessageView *messageView;
/// 聊天对象
@property (nonatomic, strong) DBUser *user;

@end

@implementation DBIMViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.passValue && [self.passValue isKindOfClass:[DBUser class]]) {
        self.user = self.passValue;
        self.title = self.user.nickname;
    }
    _imManager = [[DBIMManager alloc] initWithUID:@"123"];
    [_imManager fetchMessagesForUID:@"123"];
    [self messageTableSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.messageView scrollToBottomAnimated:NO];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)messageTableSetup
{
    _messageView = [[DBIMMessageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HLYViewHeight)];
    _messageView.dataSource = self;
    
    [self.view addSubview:_messageView];
    [self.messageView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.messageView.inputBox endEditing:YES];
}


#pragma mark - im data source
- (NSInteger)numberOfMessageInMessageView:(DBIMMessageView *)messageView
{
    return self.imManager.messages.count;
}

- (DBIMMessageCell *)messageView:(DBIMMessageView *)messageView cellAtIndexPath:(NSInteger)index
{
    static NSString *cellIdentifier = @"imMessageCell";
    DBIMMessageCell *cell = [messageView dequeueReuseCellForIdentifier:cellIdentifier];
    if (!cell) {
        cell = [self.imManager messageCellAtIndex:index identifier:cellIdentifier];
    }
    
    return cell;
}

- (CGFloat)messageView:(DBIMMessageView *)messageView heightForRowAtIndexPath:(NSInteger)index
{
    return [self.imManager cellHeightForMessageAtIndex:index];
}

@end
