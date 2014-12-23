//
//  CloudBackupViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-16.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "CloudBackupViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "LeftSliderController.h"
#import "RecordDB.h"

@interface CloudBackupViewController ()
{
    BOOL networkConnected;
    BOOL flag;
}

@end

@implementation CloudBackupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    networkConnected = FALSE;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    titleLabel.text = @"云备份";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.navigationItem.titleView = titleLabel;
    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    
    UIButton *upButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 80, 30)];
    [upButton setTitle:@"上传" forState:UIControlStateNormal];
    [upButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [upButton setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [upButton addTarget:self action:@selector(upButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CALayer * buttonLayer1 = [upButton layer];
    [buttonLayer1 setMasksToBounds:YES];
    [buttonLayer1 setCornerRadius:5.0];
    [buttonLayer1 setBorderWidth:1.5];
    [buttonLayer1 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:upButton];
    
    UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 80, 80, 30)];
    [downButton setTitle:@"下载" forState:UIControlStateNormal];
    [downButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [downButton setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [downButton addTarget:self action:@selector(downButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CALayer * buttonLayer2 = [downButton layer];
    [buttonLayer2 setMasksToBounds:YES];
    [buttonLayer2 setCornerRadius:5.0];
    [buttonLayer2 setBorderWidth:1.5];
    [buttonLayer2 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:downButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ButtonPressedAction

- (void)backItemPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)upButtonPressed {
    LeftSliderController *leftSliderC = [LeftSliderController sharedViewController];
    //读取数据库表recordT中用户的所有未删除的投资记录
    RecordDB *recordDB = [[RecordDB alloc] init];
    records = [recordDB getAllRecord:YES];//读取所有的数据，包括已被标记为删除的数据
    if (leftSliderC->networkConnected) {//网络已连接
        flag = TRUE;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //这个决定了下面responseObject返回的类型
        for (int i = 0; i < [records count]; i++) {
            [manager POST:@"http://128.199.226.246/beerich/index.php/sync"
               parameters:@{@"user_name":@"xuxin@qq.com",@"platform":[records[i] objectForKey:@"platform"],
                            @"product":[records[i] objectForKey:@"product"],
                                @"capital":[records[i] objectForKey:@"capital"],
                                @"minRate":[records[i] objectForKey:@"minRate"],
                                @"maxRate":[records[i] objectForKey:@"maxRate"],
                                @"calType":[records[i] objectForKey:@"calType"],
                                @"startDate":[records[i] objectForKey:@"startDate"],
                                @"endDate":[records[i] objectForKey:@"endDate"],
                                @"state":[records[i] objectForKey:@"state"],
                                @"add_time":[records[i] objectForKey:@"timeStamp"],
                                @"ifDeleted":[records[i] objectForKey:@"isDeleted"]}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"JSON#######: %@", operation.responseString);
                      if (!operation.responseString) {
                          [self alertWithTitle:@"提示" withMsg:@"网络连接异常"];
                          
                      } else {
                          NSString *requestTmp = [NSString stringWithString:operation.responseString];
                          NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                          NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                          NSLog(@"%@,%@",[resultDic objectForKey:@"error_code"],[resultDic objectForKey:@"error_meesage"]);
                          if ([[resultDic objectForKey:@"error_code"] intValue] == 0) {
//                              [self alertWithTitle:@"提示" withMsg:@"上传完成"];
                          }
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error######: %@,%@", error,records[i]);
                  }];
        }
    }//end if (leftSliderC->networkConnected)
    else {//网络未连接
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接错误"
                                                        message:@"无法连接服务器，请检查您的网络连接是否正常"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)downButtonPressed {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //这个决定了下面responseObject返回的类型
    [manager POST:@"http://128.199.226.246/beerich/index.php/sync/cloudAmount"
       parameters:@{@"user_name":@"xuxin@qq.com"}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON#######: %@", responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error######: %@", error);
          }];
}

- (void) alertWithTitle:(NSString *)title withMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
