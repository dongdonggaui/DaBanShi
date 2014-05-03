//
//  HLYMyInfoViewController.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-8.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import <MMProgressHUD.h>
#import <UIImage+ImageWithColor.h>

#import "DBMyInfoViewController.h"
#import "DBUser.h"
#import "DBImage.h"

#import "DBUserManager.h"
#import "DBAclManager.h"

#import "UIFont+HLY.h"
#import "UIColor+Convenience.h"
#import "UIImage+Convenience.h"
#import "UIImageView+Network.h"
#import "NSDictionary+NetworkProperties.h"

static const NSInteger kActionSheetTagLogout = 22;

@interface DBMyInfoViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, weak) DBUser *user;
@property (nonatomic, strong) DBImage *uploadedImage;

@end

@implementation DBMyInfoViewController

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
    self.title = @"资料编辑";
    
    self.user = [DBAclManager sharedInstance].loginCredential.user;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 44)];
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutButton.width = 300;
    logoutButton.height = 36;
    logoutButton.x = ceilf((footerView.width - logoutButton.width) / 2);
    logoutButton.y = ceilf((footerView.height - logoutButton.height) / 2);
    logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [logoutButton setTitle:@"注销" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *redImage = [[UIImage imageWithColor:[UIColor redColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 1, 1)];
    
    [logoutButton setBackgroundImage:redImage forState:UIControlStateNormal];
    [footerView addSubview:logoutButton];
    _tableView.tableFooterView = footerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DLog(@"user --> %@", [DBAclManager sharedInstance].loginCredential.user);
    
    [[DBUserManager sharedInstance] fetchUserInfoByUserId:self.user.userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"user info --> %@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseObject = [responseObject dictionaryByRemoveNull];
            [responseObject enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [self.user setValue:obj forKey:key];
            }];
            [self.tableView reloadData];
        }
    } failed:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private
- (void)updateUserInfo
{
    [[DBUserManager sharedInstance] updateUserInfoWithUserId:self.user.userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"update user info --> %@", responseObject);
    } failure:nil];
}

- (void)logoutButtonDidTapped:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定注销" otherButtonTitles:nil];
    as.tag = kActionSheetTagLogout;
    [as showInView:self.view];
}

- (void)showImagePickerWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if (buttonIndex == 0 && [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1 && [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBViewController *vc = (DBViewController *)segue.destinationViewController;
    vc.passValue = sender;
}


#pragma mark - table view data source & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (self.user == nil) {
//        return 0;
//    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 70 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont HLY_smallFont];
    cell.detailTextLabel.font = [UIFont HLY_smallFont];
    cell.textLabel.textColor = [UIColor HLY_grayTextColor];
    cell.detailTextLabel.textColor = [UIColor HLY_grayTextColor];
    if (0 == indexPath.section) {
        UIImageView *userAvatorImageView = (UIImageView *)[cell.contentView viewWithTag:101];
        if (!userAvatorImageView) {
            userAvatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [cell.contentView addSubview:userAvatorImageView];
        }
        
        cell.textLabel.text = @"头像";
        CGFloat cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        userAvatorImageView.x = cell.width - userAvatorImageView.width - 35;
        userAvatorImageView.y = ceilf((cellHeight - userAvatorImageView.height) / 2);
        userAvatorImageView.backgroundColor = [UIColor yellowColor];
        [userAvatorImageView HLY_loadNetworkImageAtPath:self.user.avatorUrl withPlaceholder:[UIImage HLY_defaultAvatar] errorImage:[UIImage HLY_errorImage] activityIndicator:nil];
    } else {
        if (0 == indexPath.row) {
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = self.user.nickname;
        } else if (1 == indexPath.row) {
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = self.user.gender.integerValue == 0 ? @"男" : @"女";
        } else if (2 == indexPath.row) {
            cell.textLabel.text = @"生日";
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"yyyy年MM月dd日";
            cell.detailTextLabel.text = [df stringFromDate:self.user.birthday];
        } else if (3 == indexPath.row) {
            cell.textLabel.text = @"地区";
            cell.detailTextLabel.text = self.user.city;
        }
//        else if (4 == indexPath.row) {
//            cell.textLabel.text = @"手机号码";
//            cell.detailTextLabel.text = self.user.phone;
//        }
        else {
            cell.textLabel.text = @"个性签名";
            cell.detailTextLabel.text = self.user.signature;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传", @"从相册选取", nil];
        [as showInView:self.view];
    } else if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            [self performSegueWithIdentifier:@"showNickNameSettingSegue" sender:self.user];
        } else if (1 == indexPath.row) {
            [self performSegueWithIdentifier:@"showGenderSegue" sender:self.user];
        } else if (2 == indexPath.row) {
            [self performSegueWithIdentifier:@"showBirthdaySegue" sender:self.user];
        } else if (3 == indexPath.row) {
            [self performSegueWithIdentifier:@"showCitySegue" sender:self.user];
        } else if (4 == indexPath.row) {
            [self performSegueWithIdentifier:@"showSignatureSegue" sender:self.user];
        }
    }
}


#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (actionSheet.tag == kActionSheetTagLogout) {
            __weak DBMyInfoViewController *safeSelf = self;
            [MMProgressHUD showWithStatus:@"请稍候..."];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MMProgressHUD dismissWithSuccess:@"已登出"];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                [[DBAclManager sharedInstance] logoutWithComplecation:^{
                    [safeSelf presentLoginViewCompleted:nil];
                }];
            });
        } else {
            [self showImagePickerWithButtonIndex:buttonIndex];
            
        }
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - image picker view delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    UIImage *compressed = [UIImage imageWithData:imageData];
    DLog(@"size --> %@, volumn --> %lu", NSStringFromCGSize(compressed.size), (unsigned long)imageData.length);
    
    // 上传照片
    __weak DBMyInfoViewController *safeSelf = self;
    [MMProgressHUD showProgressWithStyle:MMProgressHUDProgressStyleRadial title:nil status:@"开始上传"];
    [[MMProgressHUD sharedHUD] setProgressCompletion:^{
        [MMProgressHUD dismissWithSuccess:@"上传成功"];
    }];
    [[DBUserManager sharedInstance] uploadAvatarWithFormat:@"jpeg" data:imageData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"response = %@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            DBImage *avator = [DBImage imageWithProperties:responseObject];
            safeSelf.uploadedImage = avator;
            [safeSelf updateUserInfo];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    } withUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat rate = totalBytesWritten * 1.f / totalBytesExpectedToWrite;
        [MMProgressHUD updateProgress:rate];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker.delegate = nil;
    picker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker.delegate = nil;
    picker = nil;
}

@end
