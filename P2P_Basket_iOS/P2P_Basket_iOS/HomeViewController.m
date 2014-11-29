//
//  RootViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-4.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "HomeViewController.h"
#import "AddViewController.h"

@interface HomeViewController ()
{
    CGFloat screen_width;//屏幕宽
    CGFloat screen_height;//屏幕高
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    
    flag = 1;//初始显示即将到期
    

    //left_bt上显示一个UIView(红色背景，红色背景上又一个Label，显示到期项目的个数)，
    //一个Label（显示“已经到期”），right_bt类似
    //左UIButton
    UIButton *left_bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 64+147, screen_width/2, 50)];
    left_bt.tag = 101;
    
    UIView *left_view = [[UIView alloc] initWithFrame:CGRectMake(screen_width/16, 15, screen_width/7, 20)];
    left_view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:195.0/255.0 blue:0.0/255.0 alpha:1.0];//橘黄色
    left_view.layer.cornerRadius = 7;//设置圆角
    [left_view setUserInteractionEnabled:NO];//防止阻碍left_bt响应用户点击
    [left_bt addSubview:left_view];
    
    UILabel *left_label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, screen_width/7-10, 16)];
    left_label1.text = @"5";
    left_label1.textAlignment = UITextAlignmentCenter;
    left_label1.textColor = [UIColor whiteColor];
    [left_view addSubview:left_label1];
    
    UILabel *left_label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/18+screen_width/6, 12, screen_width/4, 26)];
    left_label2.text = @"即将到期";
    left_label2.textAlignment = UITextAlignmentCenter;
    [left_bt addSubview:left_label2];
    
    //右UIButton
    UIButton *right_bt = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/2, 64+147, screen_width/2, 50)];
    right_bt.tag = 102;
    right_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];//未选中时浅灰色
    
    UIView *right_view = [[UIView alloc] initWithFrame:CGRectMake(screen_width/16, 15, screen_width/7, 20)];
    right_view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];//浅红色
    right_view.layer.cornerRadius = 7;//设置圆角
    [right_view setUserInteractionEnabled:NO];//防止阻碍left_bt响应用户点击
    [right_bt addSubview:right_view];
    
    UILabel *right_label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, screen_width/7-10, 16)];
    right_label1.text = @"456";
    right_label1.textAlignment = UITextAlignmentCenter;
    right_label1.textColor = [UIColor whiteColor];
    [right_view addSubview:right_label1];
    
    UILabel *right_label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/18+screen_width/6, 12, screen_width/4, 26)];
    right_label2.text = @"已经到期";
    right_label2.textAlignment = UITextAlignmentCenter;
    [right_bt addSubview:right_label2];
    
    //给左右UIButton添加事件响应
    [left_bt addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [right_bt addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //将左右UIButton添加到self.view中
    [self.view addSubview:left_bt];
    [self.view addSubview:right_bt];
    
    //添加UITableView
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+147+50, screen_width-15, screen_height-(64+147+50+49)) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ButtonPressedAction

- (IBAction)leftButtonPressed {//左变白色
    flag = 1;
    UIButton *left_bt = (UIButton *)[self.view viewWithTag:101];
    UIButton *right_bt = (UIButton *)[self.view viewWithTag:102];
    left_bt.backgroundColor = [UIColor whiteColor];//用户选中的为白色
    right_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];//未选中的为浅灰色
}

- (IBAction)rightButtonPressed {//右变浅灰色
    flag = 2;
    UIButton *left_bt = (UIButton *)[self.view viewWithTag:101];
    UIButton *right_bt = (UIButton *)[self.view viewWithTag:102];
    left_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    right_bt.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"%d",[violationRecord count]);
    return 10;//violationRecord[0]内记录的时车辆的信息（非违章信息）
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, screen_width/3, 15)];
        label1.tag = 1001;
        label1.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label1];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/3+25, 10, 38, 24)];
        imageView.tag = 1002;
        [cell.contentView addSubview:imageView];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3+68, 14, screen_width/3*2-54-10, 15)];
        label2.tag = 1003;
        label2.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3+37, 40, 15, 16)];
        label3.text = @"￥";
        label3.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3+55, 40, 80, 16)];
        label4.tag = 1004;
        label4.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/4*3, 45, screen_width/4-15, 15)];
        label5.tag = 1005;
        label5.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label5];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    //写入数据
    UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:1001];
    label1.text = @"2014-8-25 到期";
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1002];
//    [imageView setImage:[UIImage imageNamed:@"人人贷-icon"]];
    [imageView setImage:[UIImage imageNamed:@"点融网-icon"]];
//    [imageView setImage:[UIImage imageNamed:@"爱投资-icon"]];
//    [imageView setImage:[UIImage imageNamed:@"积木盒子-icon"]];
//    [imageView setImage:[UIImage imageNamed:@"陆金所-icon"]];
//    [imageView setImage:[UIImage imageNamed:@"盛融在线-icon"]];
//    [imageView setImage:[UIImage imageNamed:@"鑫合汇-icon"]];
//    [imageView setImage:[UIImage imageNamed:@"有利网-icon"]];
    
    UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:1003];
//    label2.text = @"人人贷-优选计划";
//    label2.textColor = [UIColor colorWithRed:13.0/255.0 green:90.0/255.0 blue:157.0/255.0 alpha:1.0];
    
    label2.text = @"点触网-团团赚-高手";
    label2.textColor = [UIColor colorWithRed:33.0/255.0 green:150.0/255.0 blue:46.0/255.0 alpha:1.0];
    
//    label2.text = @"爱投资-";
//    label2.textColor = [UIColor colorWithRed:207.0/255.0 green:150.0/255.0 blue:12.0/255.0 alpha:1.0];
//
//    label2.text = @"积木盒子-饮品生产";
//    label2.textColor = [UIColor colorWithRed:27.0/255.0 green:166.0/255.0 blue:220.0/255.0 alpha:1.0];
    
//    label2.text = @"陆金所-富盈人生";
//    label2.textColor = [UIColor colorWithRed:213.0/255.0 green:74.0/255.0 blue:20.0/255.0 alpha:1.0];
    
//    label2.text = @"盛融在线-";
//    label2.textColor = [UIColor colorWithRed:232.0/255.0 green:170.0/255.0 blue:21.0/255.0 alpha:1.0];
    
//    label2.text = @"鑫合汇-";
//    label2.textColor = [UIColor colorWithRed:14.0/255.0 green:110.0/255.0 blue:203.0/255.0 alpha:1.0];
    
//    label2.text = @"有利网-月息通";
//    label2.textColor = [UIColor colorWithRed:235.0/255.0 green:97.0/255.0 blue:7.0/255.0 alpha:1.0];

    
    UILabel *label4 = (UILabel *)[cell.contentView viewWithTag:1004];
    label4.text = @"1,000,000";
    
    UILabel *label5 = (UILabel *)[cell.contentView viewWithTag:1005];
    label5.text = @"12%~14%";
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}//返回cell的高度


@end
