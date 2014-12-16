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
    BOOL flag1;//记录“建议”标签是否被点击
    BOOL flag2;
    BOOL flag3;
}
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    
    flag1 = FALSE;
    flag2 = FALSE;
    flag3 = FALSE;
    
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    titleLabel.text = @"用户反馈";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.navigationItem.titleView = titleLabel;
    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //添加标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+10, 60, 15)];
    label.text = @"标签:";
    [self.view addSubview:label];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/4-25, 64+10+15, 50, 25)];
    [button1 setTitle:@"建议" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [button1 setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    button1.tag = 101;
    [button1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //给registerButton添加边框
    CALayer * buttonLayer1 = [button1 layer];
    [buttonLayer1 setMasksToBounds:YES];
    [buttonLayer1 setCornerRadius:5.0];
    [buttonLayer1 setBorderWidth:1.5];
    [buttonLayer1 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/2-25, 64+10+15, 50, 25)];
    [button2 setTitle:@"出错" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [button2 setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    button2.tag = 102;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //给registerButton添加边框
    CALayer * buttonLayer2 = [button2 layer];
    [buttonLayer2 setMasksToBounds:YES];
    [buttonLayer2 setCornerRadius:5.0];
    [buttonLayer2 setBorderWidth:1.5];
    [buttonLayer2 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/4*3-25, 64+10+15, 50, 25)];
    [button3 setTitle:@"帮助" forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:15];
    [button3 setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    button3.tag = 103;
    [button3 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //给registerButton添加边框
    CALayer * buttonLayer3 = [button3 layer];
    [buttonLayer3 setMasksToBounds:YES];
    [buttonLayer3 setCornerRadius:5.0];
    [buttonLayer3 setBorderWidth:1.5];
    [buttonLayer3 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:button3];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//避免textView上面出现大段空白
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64+10+15+25+10, screen_width-20, 150)];
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

- (void)buttonPressed:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 101:
            if (!flag1) {
                [button setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor]];
                flag1 = TRUE;
            }
            else {
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] CGColor]];
                flag1 = FALSE;
            }
            break;
        case 102:
            if (!flag2) {
                [button setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor]];
                flag2 = TRUE;
            }
            else {
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] CGColor]];
                flag2 = FALSE;
            }
            break;
        case 103:
            if (!flag3) {
                [button setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor]];
                flag3 = TRUE;
            }
            else {
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] CGColor]];
                flag3 = FALSE;
            }
            break;
        default:
            break;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [textView resignFirstResponder];
}



@end
