//
//  FeedbackViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-14.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "FeedbackViewController.h"


@interface FeedbackViewController ()
{
    CGFloat screen_width;
}
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    titleLabel.text = @"用户反馈";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.navigationItem.titleView = titleLabel;
    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backItemPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;//避免textView上面出现大段空白
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, screen_width-20, 150)];
    textView.delegate = self;
    textView.scrollEnabled = YES;
    textView.font = [UIFont systemFontOfSize:14];
    textView.backgroundColor = [UIColor whiteColor];
    //设置圆边角
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth =1.0;
    textView.layer.cornerRadius =5.0;
    [self.view addSubview:textView];
    
    NSLog(@"%f",[[NSDate date] timeIntervalSince1970]);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ButtonPressedAction

- (void)backItemPressed
{
    NSLog(@"%@",textView.text);
    [self dismissModalViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [textView resignFirstResponder];
}



@end
