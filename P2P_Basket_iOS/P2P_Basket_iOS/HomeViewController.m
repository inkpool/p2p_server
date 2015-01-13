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
    NSDictionary *platformColor;
    UILabel *left_label1;
    UILabel *right_label1;
    UILabel *incomeLabel;
    UILabel *interestRateLabel;
    UILabel *totalCapitalLable;
    UITextField *income1;
    UITextField *rest1;
    int prewTag;
    float prewMoveY;
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
    
    UIView *upBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height/4)];
    upBackgroundView.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:83.0/255.0 blue:137.0/255.0 alpha:1];
    [self.view addSubview:upBackgroundView];

    //显示当天年月日
    UILabel *myDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, screen_width-30, screen_height/16-8)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSString *nowDate = [formatter stringFromDate:[NSDate date]];
    myDateLabel.text = nowDate;
    myDateLabel.font = [UIFont fontWithName:@"Superclarendon" size:28];
    myDateLabel.textColor = [UIColor whiteColor];
    [upBackgroundView addSubview:myDateLabel];
    
    //当日收益
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, screen_height/16+5, screen_width/3, screen_height/16-10)];
    label1.text = @"当日收益";
    label1.font = [UIFont systemFontOfSize:19];
    label1.textColor = [UIColor whiteColor];
    [upBackgroundView addSubview:label1];
    incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3+10, screen_height/16+5, screen_width-screen_width/3-15, screen_height/16-10)];
    incomeLabel.textColor = [UIColor whiteColor];
    incomeLabel.font = [UIFont systemFontOfSize:26];
    [upBackgroundView addSubview:incomeLabel];
    
    //均年化收益
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, screen_height/8+5, screen_width/3, screen_height/16-10)];
    label2.text = @"均年化收益";
    label2.font = [UIFont systemFontOfSize:19];
    label2.textColor = [UIColor whiteColor];
    [upBackgroundView addSubview:label2];
    interestRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3+15, screen_height/8+5, screen_width-screen_width/3-20, screen_height/16-10)];
    interestRateLabel.textColor = [UIColor whiteColor];
    interestRateLabel.font = [UIFont systemFontOfSize:26];
    [upBackgroundView addSubview:interestRateLabel];
    
    //在投总额
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, screen_height/16*3+5, screen_width/3, screen_height/16-10)];
    label3.text = @"在投总额";
    label3.font = [UIFont systemFontOfSize:19];
    label3.textColor = [UIColor whiteColor];
    [upBackgroundView addSubview:label3];
    
    totalCapitalLable = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3+10, screen_height/16*3+5, screen_width-screen_width/3-15, screen_height/16-10)];
    totalCapitalLable.textColor = [UIColor whiteColor];
    totalCapitalLable.font = [UIFont systemFontOfSize:26];
    [upBackgroundView addSubview:totalCapitalLable];
    
    platformColor = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor colorWithRed:205.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1],@"爱投资",
                                      [UIColor colorWithRed:28.0/255.0 green:154.0/255.0 blue:39.0/255.0 alpha:1],@"点融网",
                                      [UIColor colorWithRed:28.0/255.0 green:171.0/255.0 blue:224.0/255.0 alpha:1],@"积木盒子",
                                      [UIColor colorWithRed:193.0/255.0 green:61.0/255.0 blue:18.0/255.0 alpha:1],@"陆金所",
                                      [UIColor colorWithRed:10.0/255.0 green:74.0/255.0 blue:144.0/255.0 alpha:1],@"人人贷",
                                      [UIColor colorWithRed:237.0/255.0 green:175.0/255.0 blue:79.0/255.0 alpha:1],@"盛融在线",
                                      [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:203.0/255.0 alpha:1],@"鑫合汇",
                                      [UIColor colorWithRed:238.0/255.0 green:108.0/255.0 blue:15.0/255.0 alpha:1],@"有利网",
                                      nil];
    
    //left_bt上显示一个UIView(红色背景，红色背景上又一个Label，显示到期项目的个数)，
    //一个Label（显示“已经到期”），right_bt类似
    //左UIButton
    UIButton *left_bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 64+screen_height/4, screen_width/2, 50)];
    left_bt.tag = 101;
    
    UIView *left_view = [[UIView alloc] initWithFrame:CGRectMake(screen_width/16, 15, screen_width/7, 20)];
    left_view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:195.0/255.0 blue:0.0/255.0 alpha:1.0];//橘黄色
    left_view.layer.cornerRadius = 7;//设置圆角
    [left_view setUserInteractionEnabled:NO];//防止阻碍left_bt响应用户点击
    [left_bt addSubview:left_view];
    
    left_label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, screen_width/7-10, 16)];
    left_label1.tag = 111;
    left_label1.textAlignment = NSTextAlignmentCenter;
    left_label1.textColor = [UIColor whiteColor];
    [left_view addSubview:left_label1];
    
    UILabel *left_label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/18+screen_width/6, 12, screen_width/4, 26)];
    left_label2.text = @"即将到期";
    left_label2.textAlignment = NSTextAlignmentCenter;
    [left_bt addSubview:left_label2];
    
    //右UIButton
    UIButton *right_bt = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/2, 64+screen_height/4, screen_width/2, 50)];
    right_bt.tag = 102;
    right_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];//未选中时浅灰色
    
    UIView *right_view = [[UIView alloc] initWithFrame:CGRectMake(screen_width/16, 15, screen_width/7, 20)];
    right_view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];//浅红色
    right_view.layer.cornerRadius = 7;//设置圆角
    [right_view setUserInteractionEnabled:NO];//防止阻碍left_bt响应用户点击
    [right_bt addSubview:right_view];
    
    right_label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, screen_width/7-10, 16)];
    right_label1.tag = 112;
    right_label1.textAlignment = NSTextAlignmentCenter;
    right_label1.textColor = [UIColor whiteColor];
    [right_view addSubview:right_label1];
    
    UILabel *right_label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/18+screen_width/6, 12, screen_width/4, 26)];
    right_label2.text = @"已经到期";
    right_label2.textAlignment = NSTextAlignmentCenter;
    [right_bt addSubview:right_label2];
    
    //给左右UIButton添加事件响应
    [left_bt addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [right_bt addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //将左右UIButton添加到self.view中
    [self.view addSubview:left_bt];
    [self.view addSubview:right_bt];
    
    //添加UITableView
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+screen_height/4+50, screen_width-15, screen_height-(64+49+screen_height/4+50)) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    
    [self showData];
    
    //********************************显示到期确认的对话框*********************************
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    
    alertView = [[UIView alloc] initWithFrame:CGRectMake(screen_width/10, screen_height/6, screen_width/5*4, 290)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.alpha = 0.96;
    alertView.layer.cornerRadius = 10;
    
    //    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    //    effectview.frame = CGRectMake(0, 0, alertView.frame.size.width, alertView.frame.size.height);
    //    [alertView addSubview:effectview];
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertView.frame.size.width, 40)];
    upView.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    //只有上面两个角设为圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:upView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = upView.bounds;
    maskLayer.path = maskPath.CGPath;
    upView.layer.mask = maskLayer;
    [alertView addSubview:upView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    titleLabel.text = @"确认投资";
    [upView addSubview:titleLabel];
    
    UILabel *datelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 100, 20)];
    datelabel.tag = 201;
    [alertView addSubview:datelabel];
    
    UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 75, 200, 20)];
    productLabel.tag = 202;
    [alertView addSubview:productLabel];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 103, alertView.frame.size.width-20, 1)];
    line1.image = [UIImage imageNamed:@"horiz_line"];
    [alertView addSubview:line1];
    
    UILabel *capitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 115, 100, 20)];
    capitalLabel.text = @"投资金额";
    [alertView addSubview:capitalLabel];
    
    UILabel *capital = [[UILabel alloc] initWithFrame:CGRectMake(115, 115, alertView.frame.size.width-115-15, 20)];
    capital.tag = 203;
//    capital.backgroundColor = [UIColor redColor];
    capital.textAlignment = NSTextAlignmentRight;
    [alertView addSubview:capital];
    
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 145, 100, 20)];
    rateLabel.text = @"预期收益率";
//    rateLabel.backgroundColor = [UIColor yellowColor];
    [alertView addSubview:rateLabel];
    
    UILabel *rateLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(115, 145, alertView.frame.size.width-115-15, 20)];
    rateLabel_1.tag = 204;
//    rateLabel_1.backgroundColor = [UIColor redColor];
    rateLabel_1.textAlignment = NSTextAlignmentRight;
    [alertView addSubview:rateLabel_1];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 173, alertView.frame.size.width-20, 1)];
    line2.image = [UIImage imageNamed:@"horiz_line"];
    [alertView addSubview:line2];
    
    UILabel *incomeRecognition = [[UILabel alloc] initWithFrame:CGRectMake(15, 185, 80, 20)];
    incomeRecognition.text = @"收益确认";
//    incomeRecognition.backgroundColor = [UIColor yellowColor];
    incomeRecognition.textColor = [UIColor redColor];
    [alertView addSubview:incomeRecognition];
    
    UILabel *restLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 215, 80, 20)];
    restLabel.text = @"取出余额";
//    restLabel.backgroundColor = [UIColor blueColor];
    restLabel.textColor = [UIColor redColor];
//    restLabel.textAlignment = NSTextAlignmentRight;
    [alertView addSubview:restLabel];
    //alertView.frame.size.width-15-100, 185, 100, 20
    
    income1 = [[UITextField alloc] initWithFrame:CGRectMake(95+20, 184, alertView.frame.size.width-35-95-20, 22)];
//    income1.backgroundColor = [UIColor blueColor];
    income1.textAlignment = NSTextAlignmentRight;
    income1.textAlignment = NSTextAlignmentRight;
    income1.keyboardType = UIKeyboardTypeDecimalPad;
    CALayer * fieldLayer1 = [income1 layer];
    [fieldLayer1 setMasksToBounds:YES];
    [fieldLayer1 setCornerRadius:5.0];
    [fieldLayer1 setBorderWidth:1.5];
    [fieldLayer1 setBorderColor:[[UIColor grayColor] CGColor]];
    [alertView addSubview:income1];
    
    UILabel *income2 = [[UILabel alloc] initWithFrame:CGRectMake(alertView.frame.size.width-35, 185, 20, 20)];
//    income2.backgroundColor = [UIColor brownColor];
    income2.text = @"元";
    income2.textColor = [UIColor redColor];
    [alertView addSubview:income2];
    
    rest1 = [[UITextField alloc] initWithFrame:CGRectMake(95+20, 214, alertView.frame.size.width-35-95-20, 22)];
//    rest1.backgroundColor = [UIColor yellowColor];
    rest1.textAlignment = NSTextAlignmentRight;
    rest1.keyboardType = UIKeyboardTypeDecimalPad;
    rest1.placeholder = @"0.0";
    CALayer * fieldLayer2 = [rest1 layer];
    [fieldLayer2 setMasksToBounds:YES];
    [fieldLayer2 setCornerRadius:5.0];
    [fieldLayer2 setBorderWidth:1.5];
    [fieldLayer2 setBorderColor:[[UIColor grayColor] CGColor]];
    [alertView addSubview:rest1];
    
    UILabel *rest2 = [[UILabel alloc] initWithFrame:CGRectMake(alertView.frame.size.width-35, 215, 20, 20)];
//    rest2.backgroundColor = [UIColor greenColor];
    rest2.text = @"元";
    rest2.textColor = [UIColor redColor];
    [alertView addSubview:rest2];
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, alertView.frame.size.height-41, alertView.frame.size.width, 1)];
    line3.image = [UIImage imageNamed:@"horiz_line"];
    [alertView addSubview:line3];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, alertView.frame.size.height-40, alertView.frame.size.width/2-0.5, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    //设置取消button左下角为圆角
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:cancelButton.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = cancelButton.bounds;
    maskLayer2.path = maskPath2.CGPath;
    cancelButton.layer.mask = maskLayer2;
    [cancelButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:91.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"button_bk_image"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelButton];
    
    UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(alertView.frame.size.width/2, alertView.frame.size.height-40, 1, 40)];
    line4.image = [UIImage imageNamed:@"vertical_line"];
    [alertView addSubview:line4];
    
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(alertView.frame.size.width/2+0.5, alertView.frame.size.height-40, alertView.frame.size.width/2-0.5, 40)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    //设置确定button右下角为圆角
    UIBezierPath *maskPath3 = [UIBezierPath bezierPathWithRoundedRect:sureButton.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer3 = [[CAShapeLayer alloc] init];
    maskLayer3.frame = sureButton.bounds;
    maskLayer3.path = maskPath3.CGPath;
    sureButton.layer.mask = maskLayer3;
    [sureButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:91.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"button_bk_image"] forState:UIControlStateHighlighted];
    [sureButton addTarget:self action:@selector(sureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:sureButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showData {
    //显示当天年月日
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSString *nowDate = [formatter stringFromDate:[NSDate date]];
    dateLabel.text = nowDate;
    
    totalCapitalLable.text = [NSString stringWithFormat:@"￥%.2f",remainCapital];//显示在投资金总额
    incomeLabel.text = [NSString stringWithFormat:@"￥%.1f ± %.1f",(minDailyResult+maxDailyResult)/2.0,maxDailyResult-(minDailyResult+maxDailyResult)/2.0];
    interestRateLabel.text = [NSString stringWithFormat:@"%.2f ± %.2f%%",(annualRate_min+annualRate_max)/2.0*100,(annualRate_max - (annualRate_min+annualRate_max)/2.0)*100];
    left_label1.text = [NSString stringWithFormat:@"%ld",[expiringRecord count]];
    right_label1.text = [NSString stringWithFormat:@"%ld",[expireRecord count]];
}



#pragma mark - ButtonPressedAction

- (IBAction)leftButtonPressed {//左变白色
    flag = 1;
    UIButton *left_bt = (UIButton *)[self.view viewWithTag:101];
    UIButton *right_bt = (UIButton *)[self.view viewWithTag:102];
    left_bt.backgroundColor = [UIColor whiteColor];//用户选中的为白色
    right_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];//未选中的为浅灰色
    
    [myTableView reloadData];
}

- (IBAction)rightButtonPressed {//右变浅灰色
    flag = 2;
    UIButton *left_bt = (UIButton *)[self.view viewWithTag:101];
    UIButton *right_bt = (UIButton *)[self.view viewWithTag:102];
    left_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    right_bt.backgroundColor = [UIColor whiteColor];
    
    [myTableView reloadData];
}

- (void)hideKeyBoard
{
    income1.text = @"";
    rest1.text = @"";
    [income1 resignFirstResponder];
    [rest1 resignFirstResponder];
    if ([self isValidatedDecimal:income1.text]) {
//        UILabel *income = (UILabel *)[alertView viewWithTag:204];
//        income.text = @"5266.0元";
//        UILabel *rest = (UILabel *)[alertView viewWithTag:205];
//        rest.text = @"45321564.0元";
    }
}

- (void)cancelButtonPressed {
    income1.text = @"";
    rest1.text = @"";
    [alertView removeFromSuperview];
    [bgView removeFromSuperview];
}

- (void)sureButtonPressed {
    if (![income1.text isEqualToString:@""]) {//已输入最终收益
        if ([self isValidatedDecimal:income1.text]) {//最终收益输入格式合法
            if (![rest1.text isEqualToString:@""]) {//用户输入了取出余额的数量
                if ([self isValidatedDecimal:rest1.text]) {//取出的余额值格式合法
                    
                    [alertView removeFromSuperview];
                    [bgView removeFromSuperview];
                    income1.text = @"";
                    rest1.text = @"";
                }
                else {//取出的余额值格式不合法
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入错误"
                                                                    message:@"请输入正确格式的余额取出值"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil,nil];
                    [alert show];
                }
            }
            else {//取出的余额为默认值0
                
                [alertView removeFromSuperview];
                [bgView removeFromSuperview];
                income1.text = @"";
                rest1.text = @"";
            }
        }
        else {//最终收益输入格式不合法
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入错误"
                                                            message:@"请输入正确格式的最终收益"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,nil];
            [alert show];
        }
    }
    else {//最终收益未输入
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入投资的最终收益"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }
}

- (BOOL)  isValidatedDecimal:(NSString *)decimalStr {
//判断用户输入的利息是否为合法格式的浮点小数
    if (decimalStr.length != 0) {//用户输入了内容
        if ([decimalStr rangeOfString:@"."].length>0) {
//            NSLog(@"%@",[decimalStr substringFromIndex:[decimalStr rangeOfString:@"."].location+1]);
            if ([decimalStr rangeOfString:@"."].location != 0 && [decimalStr rangeOfString:@"."].location != decimalStr.length-1) {//小数点不应该在头，也不应该在尾
                NSString *subString1 = [decimalStr substringToIndex:[decimalStr rangeOfString:@"."].location];
                if ([[subString1 substringToIndex:1] isEqualToString:@"0"]) {//开头为0的小数，即小于1的小数
                    if (subString1.length > 1 && ![[subString1 substringToIndex:2] isEqualToString:@"0."]) {//诸如开头为01的为非法格式
                        return false;
                    }
                }
                NSString *subString2 = [decimalStr substringFromIndex:[decimalStr rangeOfString:@"."].location+1];
                if ([subString2 rangeOfString:@"."].length == 0) {//只能有一个小数点
                    return true;
                } else {
                    return false;
                }
            }
            else {
                return false;//小数点在头或尾，非法格式
            }
        }
        else if ([[decimalStr substringToIndex:1] isEqualToString:@"0"]) {//第一个字符为0的整数，非法格式
            return false;
        }
        return true;//用户输入了整数
    }
    return false;//用户未输入内容
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag == 1) {//即将到期
        return [expiringRecord count];
    } else {
        return [expireRecord count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, screen_width/3-25, 15)];
        label1.tag = 1001;
        label1.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label1];
        
        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(15+screen_width/3-25, 13, 30, 15)];
        label6.text = @"到期";
        label6.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label6];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/3+25, 10, 38, 24)];
        imageView.tag = 1002;
        [cell.contentView addSubview:imageView];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3+68, 14, screen_width/3*2-54-10, 15)];
        label2.tag = 1003;
        label2.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3+35, 40, 15, 16)];
        label3.text = @"￥";
        label3.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3+50, 40, 80, 16)];
        label4.tag = 1004;
        label4.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/4*3-15, 45, screen_width/4, 15)];
        label5.tag = 1005;
        label5.font = [UIFont systemFontOfSize:10];
        [cell.contentView addSubview:label5];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    //写入数据
    UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:1001];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1002];
    UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:1003];
    UILabel *label4 = (UILabel *)[cell.contentView viewWithTag:1004];
    UILabel *label5 = (UILabel *)[cell.contentView viewWithTag:1005];
    
    if (flag == 1) {//即将到期
        NSString *imageName = [NSString stringWithFormat:@"%@-icon",[expiringRecord[indexPath.row] objectForKey:@"platform"]];
        [imageView setImage:[UIImage imageNamed:imageName]];
        NSString *label1Text = [NSString stringWithFormat:@"%@",[expiringRecord[indexPath.row] objectForKey:@"endDate"]];
        label1.text = label1Text;
        NSString *label2Text = [NSString stringWithFormat:@"%@-%@",[expiringRecord[indexPath.row] objectForKey:@"platform"],[expiringRecord[indexPath.row] objectForKey:@"product"]];
        label2.text = label2Text;
        label2.textColor = [platformColor objectForKey:[expiringRecord[indexPath.row] objectForKey:@"platform"]];
        NSString *label4Text = [NSString stringWithFormat:@"%.1f",[[expiringRecord[indexPath.row] objectForKey:@"capital"] floatValue]];
        label4.text = label4Text;
        if ([[expiringRecord[indexPath.row] objectForKey:@"minRate"] floatValue] == 0.0) {
            NSString *label5Text = [NSString stringWithFormat:@"%.2f%%",[[expiringRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
            label5.text = label5Text;
        }
        else {
            NSString *label5Text = [NSString stringWithFormat:@"%.2f%%~%.2f%%",[[expiringRecord[indexPath.row] objectForKey:@"minRate"] floatValue],[[expiringRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
            label5.text = label5Text;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    } else {
        NSString *imageName = [NSString stringWithFormat:@"%@-icon",[expireRecord[indexPath.row] objectForKey:@"platform"]];
        [imageView setImage:[UIImage imageNamed:imageName]];
        NSString *label1Text = [NSString stringWithFormat:@"%@",[expireRecord[indexPath.row] objectForKey:@"endDate"]];
        label1.text = label1Text;
        NSString *label2Text = [NSString stringWithFormat:@"%@-%@",[expireRecord[indexPath.row] objectForKey:@"platform"],[expireRecord[indexPath.row] objectForKey:@"product"]];
        label2.text = label2Text;
        label2.textColor = [platformColor objectForKey:[expireRecord[indexPath.row] objectForKey:@"platform"]];
        NSString *label4Text = [NSString stringWithFormat:@"%.1f",[[expireRecord[indexPath.row] objectForKey:@"capital"] floatValue]];
        label4.text = label4Text;
        if ([[expireRecord[indexPath.row] objectForKey:@"minRate"] floatValue] == 0.0) {
            NSString *label5Text = [NSString stringWithFormat:@"%.2f%%",[[expireRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
            label5.text = label5Text;
        }
        else {
            NSString *label5Text = [NSString stringWithFormat:@"%.2f%%~%.2f%%",[[expireRecord[indexPath.row] objectForKey:@"minRate"] floatValue],[[expireRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
            label5.text = label5Text;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}//返回cell的高度

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (flag == 2) {
        UILabel *datelabel = (UILabel *)[alertView viewWithTag:201];
        NSString *dateStr = [NSString stringWithFormat:@"%@",[expireRecord[indexPath.row] objectForKey:@"endDate"]];
        datelabel.text = dateStr;
        
        UILabel *productLabel = (UILabel *)[alertView viewWithTag:202];
        NSString *labelText = [NSString stringWithFormat:@"%@—%@",[expireRecord[indexPath.row] objectForKey:@"platform"],[expireRecord[indexPath.row] objectForKey:@"product"]];
        productLabel.text = labelText;
        
        UILabel *capital = (UILabel *)[alertView viewWithTag:203];
        NSString *capitalStr = [NSString stringWithFormat:@"%.1f元",[[expireRecord[indexPath.row] objectForKey:@"capital"] floatValue]];
        capital.text = capitalStr;
        
        UILabel *rateLabel_1 = (UILabel *)[alertView viewWithTag:204];
        NSString *rateStr;
        if ([[expireRecord[indexPath.row] objectForKey:@"minRate"] floatValue] == 0.0) {
            rateStr = [NSString stringWithFormat:@"%.2f%%",[[expireRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
        }
        else {
            rateStr = [NSString stringWithFormat:@"%.2f%%~%.2f%%",[[expireRecord[indexPath.row] objectForKey:@"minRate"] floatValue],[[expireRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
        }
        rateLabel_1.text = rateStr;
        
        
        [self.parentViewController.navigationController.view addSubview:bgView];
        [self.parentViewController.navigationController.view addSubview:alertView];
    }
}

@end
