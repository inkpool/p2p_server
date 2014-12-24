//
//  CloudBackupViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-16.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "CloudSyncingViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "LeftSliderController.h"
#import "RecordDB.h"
#import "DejalActivityView.h"

//#import "LDProgressView.h"

@interface CloudSyncingViewController  ()
{
    BOOL networkConnected;
    RecordDB *recordDB;
    BOOL isCloudSyncing;
    int mark;
}

@end

@implementation CloudSyncingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    networkConnected = FALSE;
    isCloudSyncing = NO;
    recordDB = [[RecordDB alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
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
    [upButton setTitle:@"同步" forState:UIControlStateNormal];
    [upButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [upButton setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [upButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    CALayer * buttonLayer1 = [upButton layer];
    [buttonLayer1 setMasksToBounds:YES];
    [buttonLayer1 setCornerRadius:5.0];
    [buttonLayer1 setBorderWidth:1.5];
    [buttonLayer1 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:upButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ButtonPressedAction

- (void)backItemPressed
{
    if (isCloudSyncing) {
        LeftSliderController *leftSliderC = [LeftSliderController sharedViewController];
        [leftSliderC->delegate refresh1];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonPressed {
    isCloudSyncing = YES;
    LeftSliderController *leftSliderC = [LeftSliderController sharedViewController];
    //读取数据库表recordT中用户的所有未删除的投资记录
    records = [recordDB getAllRecord:YES];//读取所有的数据，包括已被标记为删除的数据
    if (leftSliderC->networkConnected) {//网络已连接
        UIView *viewToUse = self.view;
        [DejalBezelActivityView activityViewForView:viewToUse withLabel:@"同步中..." width:100];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //这个决定了下面responseObject返回的类型
        [self cloudSyncingUp:manager withAmount:(int)[records count] withIndex:0];
        
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

- (void)cloudSyncingUp:(AFHTTPRequestOperationManager*)manager withAmount:(int)amount withIndex:(int)index {
    if (index != amount) {
//        progressView.progress = (index+1)/amount/2.0;
        
        [manager POST:@"http://128.199.226.246/beerich/index.php/sync"
           parameters:@{@"user_name":@"xuxin@qq.com",@"platform":[records[index] objectForKey:@"platform"],
                        @"product":[records[index] objectForKey:@"product"],
                        @"capital":[records[index] objectForKey:@"capital"],
                        @"minRate":[records[index] objectForKey:@"minRate"],
                        @"maxRate":[records[index] objectForKey:@"maxRate"],
                        @"calType":[records[index] objectForKey:@"calType"],
                        @"startDate":[records[index] objectForKey:@"startDate"],
                        @"endDate":[records[index] objectForKey:@"endDate"],
                        @"state":[records[index] objectForKey:@"state"],
                        @"add_time":[records[index] objectForKey:@"timeStamp"],
                        @"ifDeleted":[records[index] objectForKey:@"isDeleted"]}
            constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
                
             
                }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"JSON#######: %@", operation.responseString);
                  if (!operation.responseString) {
                      mark = 0;
                      [self showAlertView];
                      
                  } else {
                      NSString *requestTmp = [NSString stringWithString:operation.responseString];
                      NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                      NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                      NSLog(@"%@,%@",[resultDic objectForKey:@"error_code"],[resultDic objectForKey:@"error_meesage"]);
                      if ([[resultDic objectForKey:@"error_code"] intValue] == 0) {
                          //该记录上传成功
                          [self cloudSyncingUp:manager withAmount:amount withIndex:index+1];
                      } else {
                          mark = 1;
                          [self showAlertView];
                      }
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
              }];
        
    }
    else {
        [self cloudSyncingDownStep1:manager];
    }
}


- (void)cloudSyncingDownStep1:(AFHTTPRequestOperationManager*)manager {
    [manager POST:@"http://128.199.226.246/beerich/index.php/sync/cloudAmount"
       parameters:@{@"user_name":@"xuxin@qq.com"}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *requestTmp = [NSString stringWithString:operation.responseString];
              int intString = [requestTmp intValue];
              [self cloudSyncingDownStep2:manager withAmount:intString withIndex:0];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error######: %@", error);
          }];
}

- (void)cloudSyncingDownStep2:(AFHTTPRequestOperationManager*)manager withAmount:(int)amount withIndex:(int)index {
    int num = index*5+5;
    if (num <= amount) {
        [manager POST:@"http://128.199.226.246/beerich/index.php/sync/fromCloud"
           parameters:@{@"user_name":@"xuxin@qq.com",
                        @"index":[[NSNumber alloc] initWithInt:index*5],
                        @"number":[[NSNumber alloc] initWithInt:5]}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  for (int j = 0; j < 5; j++) {
                      NSString *requestTmp = [NSString stringWithString:operation.responseString];
                      NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                      NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//                      NSLog(@"%@",resultArray);
//                      NSLog(@"%@,%@",[[NSNumber alloc] initWithInt:i*5],[[NSNumber alloc] initWithInt:num3]);
                      BOOL isOK = [recordDB coverLocalRecord:[resultArray[j] objectForKey:@"platform"]
                                                  secondPara:[resultArray[j] objectForKey:@"product"]
                                                   thirdPara:[[resultArray[j] objectForKey:@"capital"] floatValue]
                                                   forthPara:[[resultArray[j] objectForKey:@"minRate"] floatValue]
                                                   fifthPara:[[resultArray[j] objectForKey:@"maxRate"] floatValue]
                                                   sixthPara:[resultArray[j] objectForKey:@"calType"]
                                                 seventhPara:[resultArray[j] objectForKey:@"startDate"]
                                                  eighthPara:[resultArray[j] objectForKey:@"endDate"]
                                                   ninthPara:[[resultArray[j] objectForKey:@"addTime"] longLongValue]
                                                   tenthPara:[[resultArray[j] objectForKey:@"state"] intValue]
                                                eleventhPara:[[resultArray[j] objectForKey:@"ifDeleted"] intValue]
                                   ];//end isOK
                      NSLog(@"isOK:%d",isOK);
                      
                  }//end for
                  if (num != amount) {
                      [self cloudSyncingDownStep2:manager withAmount:amount withIndex:index+1];
                  }
                  else {
                      [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.0];
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error######: %@", error);
              }];
    }
    else {
        [manager POST:@"http://128.199.226.246/beerich/index.php/sync/fromCloud"
           parameters:@{@"user_name":@"xuxin@qq.com",
                        @"index":[[NSNumber alloc] initWithInt:index*5],
                        @"number":[[NSNumber alloc] initWithInt:amount-index*5]}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  for (int j = 0; j < amount-index*5; j++) {
                      NSString *requestTmp = [NSString stringWithString:operation.responseString];
                      NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                      NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                      //                      NSLog(@"%@",resultArray);
                      //                      NSLog(@"%@,%@",[[NSNumber alloc] initWithInt:i*5],[[NSNumber alloc] initWithInt:num3]);
                      BOOL isOK = [recordDB coverLocalRecord:[resultArray[j] objectForKey:@"platform"]
                                                  secondPara:[resultArray[j] objectForKey:@"product"]
                                                   thirdPara:[[resultArray[j] objectForKey:@"capital"] floatValue]
                                                   forthPara:[[resultArray[j] objectForKey:@"minRate"] floatValue]
                                                   fifthPara:[[resultArray[j] objectForKey:@"maxRate"] floatValue]
                                                   sixthPara:[resultArray[j] objectForKey:@"calType"]
                                                 seventhPara:[resultArray[j] objectForKey:@"startDate"]
                                                  eighthPara:[resultArray[j] objectForKey:@"endDate"]
                                                   ninthPara:[[resultArray[j] objectForKey:@"addTime"] longLongValue]
                                                   tenthPara:[[resultArray[j] objectForKey:@"state"] intValue]
                                                eleventhPara:[[resultArray[j] objectForKey:@"ifDeleted"] intValue]
                                   ];//end isOK
                      NSLog(@"isOK:%d",isOK);
                      
                  }//end for
                  [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.0];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error######: %@", error);
              }];
    }
    
}


- (void)removeActivityView
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void) alertWithTitle:(NSString *)title withMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showAlertView
{
    switch (mark) {
        case 0:
            [self alertWithTitle:@"提示" withMsg:@"网络连接异常"];
            break;
        case 1:
            [self alertWithTitle:@"提示" withMsg:@"同步失败"];
            break;
//        case 2:
//            [self alertWithTitle:@"提示" withMsg:@"不存在该账号"];
//            break;
//        case 3:
//            [self alertWithTitle:@"提示" withMsg:@"密码错误！"];
//            break;
        default:
            break;
    }
}


@end
