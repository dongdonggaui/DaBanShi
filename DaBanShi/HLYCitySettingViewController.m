//
//  HLYCitySettingViewController.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-23.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import "HLYCitySettingViewController.h"
#import "DBUser.h"

@interface HLYCitySettingViewController ()

@property (nonatomic, strong) NSArray *cities;

@end

@implementation HLYCitySettingViewController

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
    self.title = @"地区";
    
    if (self.passValue != nil && [self.passValue isKindOfClass:[DBUser class]]) {
        self.user = self.passValue;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setters & getters
- (NSArray *)cities
{
    if (_cities == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"CityPicker" withExtension:@"plist"];
        _cities = [NSArray arrayWithContentsOfURL:url];
    }
    
    return _cities;
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cities.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.cities objectAtIndex:section] objectForKey:@"title"];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.cities.count];
    [arr addObject:@"热"];
    for (int i = 1; i < self.cities.count; i++) {
        NSDictionary *dic = [self.cities objectAtIndex:i];
        [arr addObject:[dic objectForKey:@"title"]];
    }
    
    return arr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.cities objectAtIndex:section] objectForKey:@"datas"] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    static NSString *hotCityIdentifier = @"hotCityCell";
    static NSString *cityIdentifier = @"cityCell";
    if (0 == indexPath.section) {
        cellIdentifier = hotCityIdentifier;
    } else {
        cellIdentifier = cityIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *city = [[[self.cities objectAtIndex:indexPath.section] objectForKey:@"datas"] objectAtIndex:indexPath.row];
    cell.textLabel.text = city;
    
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *city = [[[self.cities objectAtIndex:indexPath.section] objectForKey:@"datas"] objectAtIndex:indexPath.row];
    self.user.city = city;
    [self updateUserInfo];
}

@end
