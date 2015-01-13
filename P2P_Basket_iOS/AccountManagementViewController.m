//
//  AccountManagementViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-26.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "AccountManagementViewController.h"
#import "LoginAndRegisterViewController.h"
#import "LeftSliderController.h"

@interface AccountManagementViewController ()
{
    LeftSliderController *leftSliderC;
    CGFloat screen_width;
    CGFloat screen_height;
    int flag;//记录当前处于登录状态的账号的indexPath.row
}

@end

@implementation AccountManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    
    leftSliderC = [LeftSliderController sharedViewController];
    flag = -1;
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    if (isManagement) {
        titleLabel.text = @"账号管理";
    } else {
        titleLabel.text = @"账号登录";
    }
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.navigationItem.titleView = titleLabel;
    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, screen_width, screen_height)];
    backgroundView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    [self.view addSubview:backgroundView];
    
    UITableView *myTableView;
    if ([userInfoArray count]*40+80+20 < screen_height-84) {
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 74, screen_width-30, [userInfoArray count]*40+80+20)];
        myTableView.scrollEnabled = NO;
    } else {
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 74, screen_width-30, screen_height-84)];
    }
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [self setExtraCellLineHidden: myTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{//消除 UITableView多余的空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

- (void)backItemPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([userInfoArray count] != 0) {
            return [userInfoArray count];
        }
        return 0;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 20;
}

-(UIView*) tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    headerView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
    }
    
    if (indexPath.section == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 4, 32, 32)];
        imageView.image = [UIImage imageNamed:@"wechat-icon"];
        [cell.contentView addSubview:imageView];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 30)];
        lable.text = [userInfoArray[indexPath.row] objectForKey:@"userName"];
        [cell.contentView addSubview:lable];
        if (![loggedOnUser isEqualToString:@"default"]) {
            if ([[userInfoArray[indexPath.row] objectForKey:@"userName"] isEqualToString:loggedOnUser]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                flag = indexPath.row;
            }
        }
    } else {
        if (indexPath.row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 32, 32)];
            imageView.image = [UIImage imageNamed:@"add-account"];
            [cell.contentView addSubview:imageView];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 150, 30)];
            lable.text = @"添加账号";
            [cell.contentView addSubview:lable];
            
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 9, 22, 22)];
            imageView.image = [UIImage imageNamed:@"sign-up"];
            [cell.contentView addSubview:imageView];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 150, 30)];
            lable.text = @"注册账号";
            [cell.contentView addSubview:lable];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}//返回cell的高度

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (flag != indexPath.row) {
            if (flag != -1) {
                [userInfoArray[flag] setObject:[[NSNumber alloc] initWithInt:0] forKey:@"isSelected"];
            }
            [userInfoArray[indexPath.row] setObject:[[NSNumber alloc] initWithInt:1] forKey:@"isSelected"];
            NSString *documentDirectory = [self applicationDocumentsDirectory];
            NSString *path = [documentDirectory stringByAppendingPathComponent:@"userInfo.plist"];//不应该从资源文件中读取数
            [userInfoArray writeToFile:path atomically:YES];//原子性写入，要么全部写入成功，要么全部没写入
            leftSliderC->loggedOnUser = [userInfoArray[indexPath.row] objectForKey:@"userName"];
            UILabel *userNameLabel = (UILabel*)[leftSliderC.view viewWithTag:10001];
            userNameLabel.text = [userInfoArray[indexPath.row] objectForKey:@"userName"];
            [leftSliderC->delegate refresh1];//切换用户，重新显示投资记录
            [self dismissViewControllerAnimated:YES  completion:nil];
        }
    }
    else {
        if (indexPath.row == 0) {//添加账号
            if (![loggedOnUser isEqualToString:@"default"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加账号"
                                                                message:@"添加账号将会注销当前登录，确定添加账号？"
                                                               delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定",nil];
                alert.delegate = self;
                alert.tag = 101;
                [alert show];
            }
            else {
                LoginAndRegisterViewController *registerVC = [[LoginAndRegisterViewController alloc] init];
                registerVC->isLogin = YES;
                registerVC->userInfoArray = userInfoArray;
                [self.navigationController pushViewController:registerVC animated:YES];
            }
        } else {//注册账号
            if (![loggedOnUser isEqualToString:@"default"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册账号"
                                                                message:@"注册新账号将会注销当前登录，确定注册新账号？"
                                                               delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定",nil];
                alert.delegate = self;
                alert.tag = 102;
                [alert show];
            }
            else {
                LoginAndRegisterViewController *registerVC = [[LoginAndRegisterViewController alloc] init];
                registerVC->isLogin = NO;
                registerVC->userInfoArray = userInfoArray;
                [self.navigationController pushViewController:registerVC animated:YES];
            }
        }
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        for (int i = 0; i < [userInfoArray count]; i++) {
            if ([[userInfoArray[i] objectForKey:@"userName"] isEqualToString:loggedOnUser]) {
                [userInfoArray[i] setObject:[[NSNumber alloc] initWithInt:0] forKey:@"isSelected"];
                break;
            }
        }
        NSString *documentDirectory = [self applicationDocumentsDirectory];
        NSString *path = [documentDirectory stringByAppendingPathComponent:@"userInfo.plist"];//不应该从资源文件中读取数
        [userInfoArray writeToFile:path atomically:YES];//原子性写入，要么全部写入成功，要么全部没写入
        
        LoginAndRegisterViewController *registerVC = [[LoginAndRegisterViewController alloc] init];
        registerVC->userInfoArray = userInfoArray;
        if (actionSheet.tag == 101) {
            registerVC->isLogin = YES;
        } else {
            registerVC->isLogin = NO;
        }
        [self.navigationController pushViewController:registerVC animated:YES];
    }
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
