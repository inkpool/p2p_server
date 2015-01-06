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
#import "NewsDB.h"
#import "newsTableViewCell.h"
#import "SVPullToRefresh.h"

@interface MoreViewController ()
{
    NSArray *queryArray;
    NewsDB *newsDB;
    NSSortDescriptor *firstDescriptor;
    NSArray *sortDescriptors;
    BOOL flag;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    
    newsDB = [[NewsDB alloc] init];
    [newsDB copyDatabaseIfNeeded];
    newsArray = [newsDB getAllNews];
    firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time_stamp" ascending:YES];
    sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
    newsArray = [[newsArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"资讯",@"推荐", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.frame = CGRectMake(0, 64, screen_width, screen_height/15);
    [segment setTintColor:[UIColor colorWithRed:65.0/255.0 green:83.0/255.0 blue:137.0/255.0 alpha:1]]; //设置segments的颜色
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    [self.view addSubview:segment];
    
//    UIButton *informationButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 80, 30)];
//    [informationButton setTitle:@"资讯" forState:UIControlStateNormal];
//    [informationButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [informationButton setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
//    [informationButton addTarget:self action:@selector(informationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    CALayer * buttonLayer1 = [informationButton layer];
//    [buttonLayer1 setMasksToBounds:YES];
//    [buttonLayer1 setCornerRadius:5.0];
//    [buttonLayer1 setBorderWidth:1.5];
//    [buttonLayer1 setBorderColor:[[UIColor grayColor] CGColor]];
//    [self.view addSubview:informationButton];

    UIButton *recommendButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 100, 80, 30)];
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
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, screen_width, screen_height-130-49)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
    __weak MoreViewController *weakSelf = self;
    // setup pull-to-refresh
    [myTableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
//    [myTableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf insertRowAtBottom];
//    }];
    
//    myTableView.dataSource = newsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertRowAtTop {
    flag = false;
    [self refreshView];
    LeftSliderController *leftSliderC = [LeftSliderController sharedViewController];
    //读取数据库表recordT中用户的所有未删除的投资记录
    NSNumber *timeStamp;
    if ([newsArray count] != 0) {
        timeStamp = [newsArray[0] objectForKey:@"time_stamp"];
    } else {
        timeStamp = [[NSNumber alloc] initWithInt:0];
    }
    
    if (leftSliderC->networkConnected) {//网络已连接
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //这个决定了下面responseObject返回的类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
        [manager POST:@"http://128.199.226.246/beerich/index.php/news"
           parameters:@{@"last_timestamp":timeStamp}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *requestTmp = [NSString stringWithString:operation.responseString];
                  NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                  NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if (!result) {//wifi已连接，但无法访问网络
                      [self alertWithTitle:@"提示" withMsg:@"网络连接异常"];
                      
                  } else {
                      //系统自带JSON解析
                      queryArray = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//                      NSLog(@"resultDic11111:%d",[[queryArray[0] objectForKey:@"add_time"] intValue]);
//                      NSLog(@"resultDic22222:%d",[[queryArray[1] objectForKey:@"add_time"] intValue]);
                      //                      NSLog(@"resultDic:%@",[queryArray[0] objectForKey:@"title"]);
                      //                      NSLog(@"resultDic:%@",[queryArray[0] objectForKey:@"content"]);
                      NSLog(@"%d",[queryArray count]);
                      for (int i = 0; i < [queryArray count]; i++) {
                          [newsDB insertNews:[[queryArray[i] objectForKey:@"add_time"] intValue] withTitle:[queryArray[i] objectForKey:@"title"] withContent:[queryArray[i] objectForKey:@"content"]];
                      }
                      newsArray = [newsDB getAllNews];
                      newsArray = [[newsArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
                      //                      NSLog(@"newsArray:%@",newsArray);
                      //                          [myTableView reloadData];
                      flag = true;
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error######: %@", error);
              }];
    }//end if (leftSliderC->networkConnected)
    else {//网络未连接
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接错误"
                                                        message:@"无法连接服务器，请检查您的网络连接是否正常"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)refreshView {
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    if (!flag) {
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self refreshView];
        });
    }
    else {
        if ([queryArray count] != 0) {
            [myTableView beginUpdates];
            [myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [myTableView endUpdates];
        }
        [myTableView.pullToRefreshView stopAnimating];
    }
}


- (void)insertRowAtBottom {
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [myTableView beginUpdates];
//        [myTableView.dataSource addObject:[myTableView.dataSource.lastObject dateByAddingTimeInterval:-90]];
//        [myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:myTableView.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [myTableView endUpdates];
        
        [myTableView.infiniteScrollingView stopAnimating];
    });
}

//- (void)informationButtonPressed {
//    LeftSliderController *leftSliderC = [LeftSliderController sharedViewController];
//    //读取数据库表recordT中用户的所有未删除的投资记录
//    NSNumber *timeStamp = [[NSNumber alloc] initWithInt:0];
//    if (leftSliderC->networkConnected) {//网络已连接
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //这个决定了下面responseObject返回的类型
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
//        [manager POST:@"http://128.199.226.246/beerich/index.php/news"
//           parameters:@{@"last_timestamp":timeStamp}
//              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  NSString *requestTmp = [NSString stringWithString:operation.responseString];
//                  NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//                  NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                  if (!result) {//wifi已连接，但无法访问网络
//                      [self alertWithTitle:@"提示" withMsg:@"网络连接异常"];
//                      
//                  } else {
//                      //系统自带JSON解析
//                      queryArray = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
////                      NSLog(@"resultDic11111:%d",[[queryArray[0] objectForKey:@"add_time"] intValue]);
////                      NSLog(@"resultDic22222:%d",[[queryArray[1] objectForKey:@"add_time"] intValue]);
////                      NSLog(@"resultDic:%@",[queryArray[0] objectForKey:@"title"]);
////                      NSLog(@"resultDic:%@",[queryArray[0] objectForKey:@"content"]);
//                      NSLog(@"%d",[queryArray count]);
//                      for (int i = 0; i < [queryArray count]; i++) {
//                          [newsDB insertNews:[[queryArray[i] objectForKey:@"add_time"] intValue] withTitle:[queryArray[i] objectForKey:@"title"] withContent:[queryArray[i] objectForKey:@"content"]];
//                      }
//                      newsArray = [newsDB getAllNews];
//                      newsArray = [[newsArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
////                      NSLog(@"newsArray:%@",newsArray);
//                      [myTableView reloadData];
//                  }
//              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                  NSLog(@"Error######: %@", error);
//              }];
//    }//end if (leftSliderC->networkConnected)
//    else {//网络未连接
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接错误"
//                                                        message:@"无法连接服务器，请检查您的网络连接是否正常"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles: nil];
//        [alert show];
//    }
//}

- (void)recommendButtonPressed {
    
}

- (void)segmentAction:(UISegmentedControl *)Seg {
    NSInteger index = Seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            NSLog(@"0 clicked.");
            break;
        case 1:
            NSLog(@"1 clicked.");
            break;
        default:
            break;
    }
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
    return [newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"newsCell";
    newsTableViewCell *cell = (newsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[newsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.portalImage.image = [UIImage imageNamed:@"golden_eggs.jpg"];
    NSString *title = [newsArray[indexPath.row] objectForKey:@"title"];
    cell.newsTitle.text = title;
    
    NSString *content = [newsArray[indexPath.row] objectForKey:@"content"];
    cell.detailText.text = content;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end
