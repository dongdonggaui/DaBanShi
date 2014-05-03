//
//  DBLoginViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <MBProgressHUD.h>

#import "DBLoginViewController.h"

#import "DBAclManager.h"
#import "DBSocialManager.h"

#import "NSString+InputCheck.h"

@interface DBLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *sinaLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *qqLoginButton;

- (IBAction)forgetPasswordDidTapped:(id)sender;
- (IBAction)registerDidTapped:(id)sender;
- (IBAction)loginButtonDidTapped:(id)sender;

@end

@implementation DBLoginViewController

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
    self.accountLabel.delegate = self;
    self.accountLabel.keyboardType = UIKeyboardTypeEmailAddress;
    self.accountLabel.returnKeyType = UIReturnKeyNext;
    self.accountLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordLabel.delegate = self;
    self.passwordLabel.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordLabel.secureTextEntry = YES;
    self.passwordLabel.returnKeyType = UIReturnKeyDone;
    self.passwordLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.sinaLoginButton addTarget:self action:@selector(thirdPartyLoginButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqLoginButton addTarget:self action:@selector(thirdPartyLoginButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)thirdPartyLoginButtonDidTapped:(UIButton *)sender
{
    if (sender == self.sinaLoginButton) {
        [self performSegueWithIdentifier:@"showActorChooser" sender:@"sina"];
    } else if (sender == self.qqLoginButton) {
        [self performSegueWithIdentifier:@"showActorChooser" sender:@"qq"];
    }
    
}

- (IBAction)forgetPasswordDidTapped:(id)sender {
    
}

- (IBAction)registerDidTapped:(id)sender {
    
}

- (IBAction)loginButtonDidTapped:(id)sender {
    if ([self.accountLabel.text HLY_isNull] || ![self.accountLabel.text HLY_isValidateInput]) {
        return;
    }
    
    if ([self.passwordLabel.text HLY_isNull] || ![self.passwordLabel.text HLY_isValidateInput]) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak DBLoginViewController *safeSelf = self;
    [[DBAclManager sharedInstance] loginWithAccount:self.accountLabel.text password:self.passwordLabel.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:safeSelf.view animated:YES];

        double delayInSeconds = 0.8;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [safeSelf dismissViewControllerAnimated:YES completion:nil];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"errorCode : %d, errorMessage : %@", operation.response.statusCode, operation.responseString);
        [MBProgressHUD hideAllHUDsForView:safeSelf.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", operation.responseString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}


#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBViewController *vc = (DBViewController *)segue.destinationViewController;
    vc.passValue = sender;
}


#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountLabel) {
        [self.passwordLabel becomeFirstResponder];
    } else {
        [self loginButtonDidTapped:nil];
        [textField resignFirstResponder];
    }
    
    return YES;
}


@end
