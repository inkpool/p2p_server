//
//  FeedbackViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-14.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    
    textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 80, screen_width-20, 80)];
    textView.backgroundColor = [UIColor grayColor];//设置它的背景颜色
    textView.font = [UIFont systemFontOfSize:15];
    textView.text = @"请输入您遇到的问题或建议，我们将不断改进";//设置它显示的内容
    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
//    suggestion.scrollEnabled = YES;//是否可以拖动
//    suggestion.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    textView.layer.cornerRadius = 6;
    textView.layer.masksToBounds = YES;
    textView.delegate = self;
    
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ButtonPressedAction

- (void)backItemPressed
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [textView resignFirstResponder];
}



@end
