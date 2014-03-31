//
//  DBFeedbackViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-29.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//
#import <MMProgressHUD.h>
#import "DBFeedbackViewController.h"

#import "DBNetworkManager.h"
#import "DBAclManager.h"

#import "DBUser.h"

#import "UIColor+Convenience.h"

@interface DBFeedbackViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *textViewBackgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceholder;

@end

@implementation DBFeedbackViewController

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
    UIImage *image = [[UIImage imageNamed:@"text_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 4, 7, 3)];
    self.textViewBackgroundImageView.image = image;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.background = image;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySend;
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyNext;
    
    self.navigationItem.rightBarButtonItem = self.dbsRightBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override
- (void)dbsRightItemDidTapped:(id)sender
{
    DBUser *user = [DBAclManager sharedInstance].loginCredential.user;
    __weak DBFeedbackViewController *safeSelf = self;
    [[DBNetworkManager sharedInstance] submitFeedback:self.textView.text userId:user.userId email:self.textField.text.length > 0 ? self.textField.text : user.email udid:[DBNetworkManager sharedInstance].deviceUDID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MMProgressHUD showWithStatus:nil];
        [MMProgressHUD dismissWithSuccess:@"提交成功，感谢您的支持" title:nil afterDelay:0.8];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [safeSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.textViewPlaceholder.alpha = 0;
    } else {
        self.textViewPlaceholder.alpha = 1;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.textField becomeFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textView.text.length > 0) {
        [self dbsRightItemDidTapped:nil];
    }
    [textField resignFirstResponder];
    return YES;
}

@end

@interface UITextField (AutoAdjustment)

@end

@implementation UITextField (AutoAdjustment)

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat horizotalPadding = 5;
    CGFloat verticalPadding = 3;
    return CGRectMake(horizotalPadding, verticalPadding, bounds.size.width - 2 * horizotalPadding, bounds.size.height - 2 * verticalPadding);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGFloat horizotalPadding = 5;
    CGFloat verticalPadding = 3;
    return CGRectMake(horizotalPadding, verticalPadding, bounds.size.width - 2 * horizotalPadding, bounds.size.height - 2 * verticalPadding);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGFloat horizotalPadding = 5;
    CGFloat verticalPadding = 3;
    return CGRectMake(horizotalPadding, verticalPadding, bounds.size.width - 2 * horizotalPadding, bounds.size.height - 2 * verticalPadding);
}

@end
