//
//  DBListViewController.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBListViewController.h"

extern const NSString *kDBNotificationCityDidChange;

@interface DBListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)citySelectorDidTapped:(id)sender;

@end

@implementation DBListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString *)kDBNotificationCityDidChange object:nil];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveCityChangeNotification:) name:(NSString *)kDBNotificationCityDidChange object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)didReceiveCityChangeNotification:(NSNotification *)notifation
{
    self.navigationItem.leftBarButtonItem.title = notifation.object;
}

#pragma mark - table view data source & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 10;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *cellIdentifier = @"ListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        UIImage *image = [UIImage imageNamed:@"avatar_placehold"];
        cell.imageView.image = image;
        cell.imageView.layer.cornerRadius = 5;
        cell.clipsToBounds = YES;
        cell.textLabel.text = @"打版师xxx";
        cell.detailTextLabel.text = @"地址：武珞路xxx号";
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showDaBanShiDetail" sender:cell.textLabel.text];
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDaBanShiDetail"]) {
        UIViewController *vc = [segue destinationViewController];
        vc.title = sender;
    }
}

- (IBAction)citySelectorDidTapped:(id)sender {
    [self performSegueWithIdentifier:@"showCitySelectorSegue" sender:nil];
}
@end
