//
//  MoreViewController.m
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/15/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import "MoreViewController.h"
#import "LeftSliderController.h"
#import "AFHTTPRequestOperationManager.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    
    UIButton *informationButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 80, 30)];
    [informationButton setTitle:@"资讯" forState:UIControlStateNormal];
    [informationButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [informationButton setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [informationButton addTarget:self action:@selector(informationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CALayer * buttonLayer1 = [informationButton layer];
    [buttonLayer1 setMasksToBounds:YES];
    [buttonLayer1 setCornerRadius:5.0];
    [buttonLayer1 setBorderWidth:1.5];
    [buttonLayer1 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:informationButton];
    
    UIButton *recommendButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 80, 80, 30)];
    [recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
    [recommendButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [recommendButton setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [recommendButton addTarget:self action:@selector(recommendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CALayer * buttonLayer2 = [recommendButton layer];
    [buttonLayer2 setMasksToBounds:YES];
    [buttonLayer2 setCornerRadius:5.0];
    [buttonLayer2 setBorderWidth:1.5];
    [buttonLayer2 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:recommendButton];
    
//    //添加一个tableView
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
//    //tableView.backgroundView = backView;
//    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    tableView.backgroundColor=[UIColor clearColor];
//    //tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//    [self.view addSubview:tableView];
//    tableView.delegate=self;
//    tableView.dataSource=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)informationButtonPressed {
    LeftSliderController *leftSliderC = [LeftSliderController sharedViewController];
    //读取数据库表recordT中用户的所有未删除的投资记录
    NSNumber *timeStamp = [[NSNumber alloc] initWithInt:0];
    if (leftSliderC->networkConnected) {//网络已连接
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //这个决定了下面responseObject返回的类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
        [manager POST:@"http://128.199.226.246/beerich/index.php/news"
           parameters:@{@"last_timestamp":timeStamp}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  NSLog(@"JSON#######: %@", responseObject);
//                  NSLog(@"Success: %@", operation.responseString);
                  NSString *requestTmp = [NSString stringWithString:operation.responseString];
                  NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                  
                  
                  //系统自带JSON解析
                  NSArray *array = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//                  NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                  NSLog(@"_____%@_____",result);
//                  if (!result) {//wifi已连接，但无法访问网络
//                      [self alertWithTitle:@"提示" withMsg:@"网络连接异常"];
//                      
//                  } else {
//                      
//                  }
//                  NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:resData];
//                   NSArray *deserializedArray = (NSArray *)resultDic;
                  NSLog(@"resultDic:%@",[array[0] objectForKey:@"title"]);
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error######: %@", error);
              }];
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

- (void)recommendButtonPressed {
    
}

- (void) alertWithTitle:(NSString *)title withMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 8;
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
    }
    
    NSUInteger row = [indexPath row];
    
    switch(row)
    {
        case 4:
        {
            cell.textLabel.text = @"账户设置";
            UIImage *image = [UIImage imageNamed:@"homepage"];
            cell.imageView.image = image;
            cell.backgroundColor=[UIColor clearColor];
            break;
        }
        case 5:
        {
            cell.textLabel.text = @"云端备份";
            UIImage *image = [UIImage imageNamed:@"homepage"];
            cell.imageView.image = image;
            cell.backgroundColor=[UIColor clearColor];
            break;
        }
        case 6:
        {
            cell.textLabel.text = @"用户反馈";
            UIImage *image = [UIImage imageNamed:@"homepage"];
            cell.imageView.image = image;
            cell.backgroundColor=[UIColor clearColor];
            break;
        }
        case 7:
        {
            cell.textLabel.text = @"联系我们";
            UIImage *image = [UIImage imageNamed:@"homepage"];
            cell.imageView.image = image;
            cell.backgroundColor=[UIColor clearColor];
            break;
        }
        default: cell.backgroundColor=[UIColor clearColor];break;
    }
    return cell;
}


@end
