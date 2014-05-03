//
//  DBIdentifierChooseViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBIdentifierChooseViewController.h"
#import "DBSocialManager.h"

@interface DBIdentifierChooseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *patternMakerButton;
@property (weak, nonatomic) IBOutlet UIButton *firmButton;
@property (weak, nonatomic) IBOutlet UIButton *salerButton;

@end

@implementation DBIdentifierChooseViewController

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
    self.title = @"角色选择";
    
    self.patternMakerButton.tag = 101;
    [self.patternMakerButton addTarget:self action:@selector(identifierChooseButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.firmButton.tag = 102;
    [self.firmButton addTarget:self action:@selector(identifierChooseButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.salerButton.tag = 103;
    [self.salerButton addTarget:self action:@selector(identifierChooseButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // test
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.x = 20;
//    button.y = 20;
//    button.width = 100;
//    button.height = 40;
//    [button setTitle:@"注销" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(testButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}

// test
- (void)testButtonDidTapped:(UIButton *)sender
{
    [[DBSocialManager sharedInstance] cancelAuthWithType:DBSocialTypeQQ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private
- (void)identifierChooseButtonDidTapped:(UIButton *)sender
{
    [[DBSocialManager sharedInstance] setActorIdentifier:sender.tag - 100];
    if (!self.passValue) {
        [self performSegueWithIdentifier:@"showSignup" sender:sender];
    } else if ([self.passValue isKindOfClass:[NSString class]]) {
        if ([self.passValue isEqualToString:@"sina"]) {
            [[DBSocialManager sharedInstance] loginWithType:DBSocialTypeSina inViewController:self];
        } else if ([self.passValue isEqualToString:@"qq"]) {
            [[DBSocialManager sharedInstance] loginWithType:DBSocialTypeQQ inViewController:self];
        } else if ([self.passValue isEqualToString:@"renren"]) {
            [[DBSocialManager sharedInstance] loginWithType:DBSocialTypeRenren inViewController:self];
        }
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBViewController *vc = (DBViewController *)segue.destinationViewController;
    if (sender == self.patternMakerButton) {
        vc.passValue = [NSNumber numberWithInteger:1];
    } else if (sender == self.firmButton) {
        vc.passValue = [NSNumber numberWithInteger:2];
    } else if (sender == self.salerButton) {
        vc.passValue = [NSNumber numberWithInteger:3];
    }
}


@end
