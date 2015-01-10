//
//  NewsContentViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 15-1-10.
//  Copyright (c) 2015年 inkJake. All rights reserved.
//

#import "NewsContentViewController.h"

@interface NewsContentViewController ()

@end

@implementation NewsContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabelNav = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    titleLabelNav.text = @"  资讯";
    titleLabelNav.textColor = [UIColor whiteColor];
    titleLabelNav.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.navigationItem.titleView = titleLabelNav;
    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-10)];
    [self.view addSubview:scrollView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, screen_width-30, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];  //UILabel的字体大小
    titleLabel.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;  //文本对齐方式
//    [titleLabel setBackgroundColor:[UIColor redColor]];
    //宽度不变，根据字的多少计算label的高度
    CGSize contentSize1 = [title boundingRectWithSize:CGSizeMake(titleLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]} context:nil].size;
//    CGSize contentSize = [title sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(titleLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    [titleLabel setFrame:CGRectMake(15, 10, screen_width-30, contentSize1.height)];
    titleLabel.text = title;
    [scrollView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+contentSize1.height+10, screen_width-20, 20)];
    contentLabel.font = [UIFont boldSystemFontOfSize:16.0f];  //UILabel的字体大小
    contentLabel.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:10];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [content length])];
//    [contentLabel setAttributedText:attributedString1];
//    [contentLabel sizeToFit];
    
    //宽度不变，根据字的多少计算label的高度
    CGSize contentSize2 = [content boundingRectWithSize:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSParagraphStyleAttributeName:paragraphStyle1.copy} context:nil].size;
    //    CGSize contentSize = [title sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(titleLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    [contentLabel setFrame:CGRectMake(10, 10+contentSize1.height+10, screen_width-20, contentSize2.height)];
    [contentLabel setAttributedText:attributedString1];
    [scrollView addSubview:contentLabel];
//
    scrollView.contentSize = CGSizeMake(screen_width, 10+contentSize1.height+contentSize2.height+10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Button Pressed

-(void)cancelPressed{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
