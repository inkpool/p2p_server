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
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showData];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    
    flag = 1;//初始显示即将到期

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
    UIButton *left_bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 64+147, screen_width/2, 50)];
    left_bt.tag = 101;
    
    UIView *left_view = [[UIView alloc] initWithFrame:CGRectMake(screen_width/16, 15, screen_width/7, 20)];
    left_view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:195.0/255.0 blue:0.0/255.0 alpha:1.0];//橘黄色
    left_view.layer.cornerRadius = 7;//设置圆角
    [left_view setUserInteractionEnabled:NO];//防止阻碍left_bt响应用户点击
    [left_bt addSubview:left_view];
    
    UILabel *left_label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, screen_width/7-10, 16)];
    left_label1.tag = 111;
    left_label1.text = [NSString stringWithFormat:@"%ld",[expiringRecord count]];
    left_label1.textAlignment = NSTextAlignmentCenter;
    left_label1.textColor = [UIColor whiteColor];
    [left_view addSubview:left_label1];
    
    UILabel *left_label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/18+screen_width/6, 12, screen_width/4, 26)];
    left_label2.text = @"即将到期";
    left_label2.textAlignment = NSTextAlignmentCenter;
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
    right_label1.tag = 112;
    right_label1.text = [NSString stringWithFormat:@"%ld",[expireRecord count]];
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

- (void)showData {
    //显示当天年月日
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSString *nowDate = [formatter stringFromDate:[NSDate date]];
    dateLabel.text = nowDate;
    //计算显示在投总额
    float totalCapital = 0;
    for (int i = 0; i < [records count]; i++) {
        totalCapital += [[records[i] objectForKey:@"capital"] floatValue];
    }
    totalCapitalLable.text = [NSString stringWithFormat:@"%.2f",totalCapital];
}

#pragma mark - ButtonPressedAction

- (IBAction)leftButtonPressed {//左变白色
    flag = 1;
    UIButton *left_bt = (UIButton *)[self.view viewWithTag:101];
    UIButton *right_bt = (UIButton *)[self.view viewWithTag:102];
    left_bt.backgroundColor = [UIColor whiteColor];//用户选中的为白色
    right_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];//未选中的为浅灰色
    
    [tableView reloadData];
}

- (IBAction)rightButtonPressed {//右变浅灰色
    flag = 2;
    UIButton *left_bt = (UIButton *)[self.view viewWithTag:101];
    UIButton *right_bt = (UIButton *)[self.view viewWithTag:102];
    left_bt.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    right_bt.backgroundColor = [UIColor whiteColor];
    
    [tableView reloadData];
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
        if ([[expiringRecord[indexPath.row] objectForKey:@"minRate"] floatValue] == 0 ) {
            NSString *label5Text = [NSString stringWithFormat:@"%.2f%%",[[expiringRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
            label5.text = label5Text;
        }
        else if ([[expiringRecord[indexPath.row] objectForKey:@"maxRate"] floatValue] == 0) {
            NSString *label5Text = [NSString stringWithFormat:@"%.2f%%",[[expiringRecord[indexPath.row] objectForKey:@"minRate"] floatValue]];
            label5.text = label5Text;
        }
        else {
            NSString *label5Text = [NSString stringWithFormat:@"%.2f%%~%.2f%%",[[expiringRecord[indexPath.row] objectForKey:@"minRate"] floatValue],[[expiringRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
            label5.text = label5Text;
        }
        
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
        if ([[expireRecord[indexPath.row] objectForKey:@"minRate"] floatValue] == 0 ) {
            NSString *label5Text = [NSString stringWithFormat:@"%.2f%%",[[expireRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
            label5.text = label5Text;
        }
        else if ([[expireRecord[indexPath.row] objectForKey:@"maxRate"] floatValue] == 0) {
            NSString *label5Text = [NSString stringWithFormat:@"%.2f%%",[[expireRecord[indexPath.row] objectForKey:@"minRate"] floatValue]];
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

@end
