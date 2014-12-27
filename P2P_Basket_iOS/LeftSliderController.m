//
//  LeftSliderController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "LeftSliderController.h"
#import "CustomCellBackground.h"
#import "AboutUsViewController.h"
#import "FeedbackViewController.h"
#import "LoginAndRegisterViewController.h"
#import "CloudSyncingViewController.h"
#import "PasswordViewController.h"
#import "AccountManagementViewController.h"

@interface LeftSliderController ()
{
    NSArray *menu;
    CGFloat screen_width;
    CGFloat screen_height;
}
@end

static LeftSliderController *sharedLSC;

@implementation LeftSliderController
+ (LeftSliderController *)sharedViewController
{//单例
    return sharedLSC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLSC = self;
    });
    
    loggedOnUser = @"default";
    //获取所有的用户信息
    [self createEditableCopyOfDatabaseIfNeeded];//拷贝userInfo.plist文件
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"userInfo.plist"];//不应该从资源文件中读取数据，资源文件中的数据没有更改，要从沙箱中的资源文件读取数据
    userInfoArray = [[NSMutableArray alloc] initWithContentsOfFile:path];//从资源文件中加载内容
    if ([userInfoArray count] != 0) {
        for (int i = 0; i < [userInfoArray count]; i++) {
            if ([[userInfoArray[i] objectForKey:@"isSelected"] intValue] == 1) {
                loggedOnUser = [userInfoArray[i] objectForKey:@"userName"];
                break;
            }
        }
    }
    
    [self connectedToNetWork];//监测网络连接情况
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    menu = [NSArray arrayWithObjects:@"云同步",@"检查更新",@"用户反馈",@"关于我们",@"密码设置",@"好友分享",nil];
    
    //添加一个背景图片
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:backView];
    
    //添加图像视图和用户名称Label
    UIButton *portraitButton = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/3-25, screen_height/15, 50, 50)];
    [portraitButton setImage:[UIImage imageNamed:@"portrait_default"] forState:UIControlStateNormal];
    [portraitButton addTarget:self action:@selector(portraitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:portraitButton];
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3-100, screen_height/15+55, 200, 15)];
    userNameLabel.tag = 10001;
    if (![loggedOnUser isEqualToString:@"default"]) {
        userNameLabel.text = loggedOnUser;
    } else {
        userNameLabel.text = @"登录";
    }
    userNameLabel.font = [UIFont systemFontOfSize:13];
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userNameLabel];
    
    //添加一个tableView，显示菜单
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screen_height/5+10, screen_width/3*2, 300)];
    //tableView.backgroundView = backView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor=[UIColor clearColor];
    //tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    
    //显示账户注册和退出登录的button
    UIImageView *manageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/6-40, screen_height/5+320, 25, 25)];
    manageImageView.image = [UIImage imageNamed:@"account_management"];
    [self.view addSubview:manageImageView];
    UIButton *manageButton = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/6-12, screen_height/5+320, 55, 25)];
    [manageButton setTitle:@"账号管理" forState:UIControlStateNormal];
    [manageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [manageButton addTarget:self action:@selector(manageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    manageButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:manageButton];
    
    UIImageView *separateView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/3-3, screen_height/5+320+4, 1, 17)];
    separateView.image = [UIImage imageNamed:@"vertical_line"];
    [self.view addSubview:separateView];
    
    UIImageView *signOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/3+screen_width/3-3-screen_width/6-43, screen_height/5+320, 25, 25)];
    signOutImageView.image = [UIImage imageNamed:@"sign_out"];
    [self.view addSubview:signOutImageView];
    UIButton *signOutButton = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/3+screen_width/3-3-screen_width/6-43+28, screen_height/5+320, 55, 25)];
    [signOutButton setTitle:@"退出账号" forState:UIControlStateNormal];
    [signOutButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [signOutButton addTarget:self action:@selector(signOutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    signOutButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:signOutButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 3;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @" ";
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(UIView*) tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    if(section == 1) {
        headerView.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4.5, screen_width/3*2-10, 2)];
        imageView.image = [UIImage imageNamed:@"horiz_line"];
        [headerView addSubview:imageView];
        
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
        cell.tag = indexPath.section*3 + indexPath.row + 1;
    }
    cell.textLabel.text = menu[indexPath.section*3+indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_icon_%ld",indexPath.section*3+indexPath.row+1]];
    CGSize itemSize = CGSizeMake(20, 20);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    cell.imageView.frame = CGRectMake(0, 0, 10, 10);
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSelected"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}//返回cell的高度

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger num = indexPath.section*3 + indexPath.row;
    switch (num) {
        case 0:{
            CloudSyncingViewController *cloudBackupVC = [[CloudSyncingViewController alloc] init];
            UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:cloudBackupVC];
            [self presentViewController:navC animated:YES completion:^{
                UITableViewCell *cell = (UITableViewCell*)[self.view viewWithTag:1];
                cell.selected = NO;
            }];
            break;
        }
        case 1:
            break;
        case 2:{
            FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
            UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:feedbackVC];
            [self presentViewController:navC animated:YES completion:^{
                UITableViewCell *cell = (UITableViewCell*)[self.view viewWithTag:3];
                cell.selected = NO;
            }];
            
            break;
        }
        case 3:{
            AboutUsViewController *aboutUs = [[AboutUsViewController alloc] init];
            UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:aboutUs];
            [self presentViewController:navC animated:YES completion:^{
                UITableViewCell *cell = (UITableViewCell*)[self.view viewWithTag:4];
                cell.selected = NO;
            }];
            break;
        }
        case 4:{
            PasswordViewController *passwordVC = [[PasswordViewController alloc] init];
            UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:passwordVC];
            [self presentViewController:navC animated:YES completion:^{
                UITableViewCell *cell = (UITableViewCell*)[self.view viewWithTag:5];
                cell.selected = NO;
            }];
            break;
        }
        case 5:
            break;
        default:
            break;
    }
    
}

#pragma mark - ButtonPressedAction
- (void)portraitButtonPressed {
    if (![loggedOnUser isEqualToString:@"default"]) {
        
    } else {
        AccountManagementViewController *amvc = [[AccountManagementViewController alloc] init];
        amvc->isManagement = NO;
        amvc->userInfoArray = userInfoArray;
        amvc->loggedOnUser = loggedOnUser;
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:amvc];
        [self presentViewController:navC animated:YES  completion:nil];
    }
}

- (void)manageButtonPressed {
    AccountManagementViewController *amvc = [[AccountManagementViewController alloc] init];
    amvc->isManagement = YES;
    amvc->userInfoArray = userInfoArray;
    amvc->loggedOnUser = loggedOnUser;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:amvc];
    [self presentViewController:navC animated:YES  completion:nil];
}

- (void)signOutButtonPressed {
    if (![loggedOnUser isEqualToString:@"default"]) {
        NSString *message = [NSString stringWithFormat:@"确定退出账号:%@？",loggedOnUser];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出账号"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.delegate = self;
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出账号"
                                                        message:@"操作无效：当前无账号处于登录状态"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark -
#pragma mark NetworkConnected

- (void) connectedToNetWork {
    //检测网络是否可以连接
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkConnected = YES;
                NSLog(@"network:YES");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                networkConnected = NO;
                NSLog(@"network:NO");
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark -
#pragma mark Copy of userInfo.plist

- (void)createEditableCopyOfDatabaseIfNeeded {//拷贝CarsInfoList.plist文件到沙箱目录，只执行一次拷贝。
    // First, test for existence - we don't want to wipe out a user's DB
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"userInfo.plist"];//在沙箱创建的数据库文件可以更改，若直接操作资源文件，不能更改数据
    
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];//是否存在该数据库文件
    
    if (!dbexits) {
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"userInfo.plist"];//得到资源（Resources）文件的路径
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }else{
            NSLog(@"userInfo.plist拷贝成功");
        }
    }
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%@",userInfoArray[0]);
    if (buttonIndex == 1) {
        for (int i = 0; i < [userInfoArray count]; i++) {
            if ([[userInfoArray[i] objectForKey:@"userName"] isEqualToString:loggedOnUser]) {
                [userInfoArray[i] setObject:[[NSNumber alloc] initWithInt:0] forKey:@"isSelected"];
                NSString *documentDirectory = [self applicationDocumentsDirectory];
                NSString *path = [documentDirectory stringByAppendingPathComponent:@"userInfo.plist"];
                [userInfoArray writeToFile:path atomically:YES];//原子性写入，要么全部写入成功，要么全部没写入
                loggedOnUser = @"default";
                UILabel *userNameLabel = (UILabel*)[self.view viewWithTag:10001];
                userNameLabel.text = @"登录";
                [delegate refresh1];//切换到默认用户，重新显示投资记录
                break;
            }
        }
    }
}


@end
