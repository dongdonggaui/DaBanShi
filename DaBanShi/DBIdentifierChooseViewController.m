//
//  DBIdentifierChooseViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-3-28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBIdentifierChooseViewController.h"

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
    [self.patternMakerButton addTarget:self action:@selector(identifierChooseButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.firmButton addTarget:self action:@selector(identifierChooseButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.salerButton addTarget:self action:@selector(identifierChooseButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private
- (void)identifierChooseButtonDidTapped:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"showSignup" sender:sender];
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
