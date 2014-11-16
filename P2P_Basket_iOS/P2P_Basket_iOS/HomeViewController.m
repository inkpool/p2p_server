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

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ButtonPressedAction

- (IBAction)leftButtonPressed {//左变白色
    
    UIButton *left_bt = (UIButton *)[self.view viewWithTag:101];
    UIButton *right_bt = (UIButton *)[self.view viewWithTag:102];
    left_bt.backgroundColor = [UIColor whiteColor];//用户选中的为白色
    right_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];//未选中的为浅灰色
}

- (IBAction)rightButtonPressed {//右变浅灰色
    UIButton *left_bt = (UIButton *)[self.view viewWithTag:101];
    UIButton *right_bt = (UIButton *)[self.view viewWithTag:102];
    left_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    right_bt.backgroundColor = [UIColor whiteColor];
}


@end
