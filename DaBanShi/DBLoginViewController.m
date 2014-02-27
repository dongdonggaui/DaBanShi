//
//  DBLoginViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBLoginViewController.h"
#import "DBAuthManager.h"
#import <MBProgressHUD.h>

@interface DBLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgetPasswordDidTapped:(id)sender {
    [[DBAuthManager sharedInstance] testEnCoding];
}

- (IBAction)registerDidTapped:(id)sender {
    [[DBAuthManager sharedInstance] testDeCoding];
}

- (IBAction)loginButtonDidTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak DBLoginViewController *safeSelf = self;
    [[DBAuthManager sharedInstance] loginWithAccount:self.accountLabel.text password:self.passwordLabel.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:safeSelf.view animated:YES];

        double delayInSeconds = 0.8;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [safeSelf.appDelegate switchToMainView];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"errorCode : %d, errorMessage : %@", operation.response.statusCode, operation.responseString);
        [MBProgressHUD hideAllHUDsForView:safeSelf.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", operation.responseString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}
@end
