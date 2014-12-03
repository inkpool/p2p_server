//
//  FlowViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "FlowViewController.h"

@interface FlowViewController ()

@end

@implementation FlowViewController
{
    CGFloat screen_width;//屏幕宽
    CGFloat screen_height;//屏幕高
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    
    button_flag = 0;
    triangle_flag = [NSMutableDictionary dictionary];
    [triangle_flag setValue:@"1" forKey:@"1010"];//初始时三角超下
    [triangle_flag setValue:@"1" forKey:@"1020"];
    [triangle_flag setValue:@"1" forKey:@"1030"];
    sortedRecord = records;
    
    //添加上面的选择菜单
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, screen_width/3, 36)];
    [button1 setTitle:@"投资时间    " forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setTitleColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 101;
    [self.view addSubview:button1];
    
    UIImageView *triangle1 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/3/4*3, 16, 10, 5)];
    triangle1.image = [UIImage imageNamed:@"triangle_gray_1"];
    triangle1.tag = 1010;
    [button1 addSubview:triangle1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/3, 64, screen_width/3, 36)];
    [button2 setTitle:@"投资金额    " forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setTitleColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 102;
    [self.view addSubview:button2];
    
    UIImageView *triangle2 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/3/4*3, 16, 10, 5)];
    triangle2.image = [UIImage imageNamed:@"triangle_gray_1"];
    triangle2.tag = 1020;
    [button2 addSubview:triangle2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/3*2, 64, screen_width/3, 36)];
    [button3 setTitle:@"年化收益率   " forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:14];
    [button3 setTitleColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag = 103;
    [self.view addSubview:button3];
    
    UIImageView *triangle3 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/3/4*3+5, 16, 10, 5)];
    triangle3.image = [UIImage imageNamed:@"triangle_gray_1"];
    triangle3.tag = 1030;
    [button3 addSubview:triangle3];
    
    
    //添加分割线
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/3, 70, 2, 24)];
    line1.image = [UIImage imageNamed:@"vertical_line"];
    [self.view addSubview:line1];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/3*2, 70, 2, 24)];
    line2.image = [UIImage imageNamed:@"vertical_line"];
    [self.view addSubview:line2];
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, screen_width, 2)];
    line3.image = [UIImage imageNamed:@"horiz_line"];
    [self.view addSubview:line3];

    //tableview有背景颜色，和菜单（背景为白色）相区别
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 102, screen_width, screen_height)];
    backgroundView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:247.0/255.0 alpha:1.0];
    [self.view addSubview:backgroundView];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 102, screen_width-15, screen_height-102-49)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:247.0/255.0 alpha:1.0];
    [self.view addSubview:tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonPressedAction

- (void)buttonPressed:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    UIImageView *triangle = (UIImageView *)[self.view viewWithTag:button.tag*10];
    if (button_flag != button.tag) {
        
        if (button_flag != 0) {//先前有button被点击
            //此前被点击的按钮恢复成灰色
            UIButton *pre_button = (UIButton *)[self.view viewWithTag:button_flag];
            [pre_button setTitleColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0] forState:UIControlStateNormal];//先前被点击的button标题还原成灰色
            UIImageView *pre_triangle = (UIImageView *)[self.view viewWithTag:button_flag*10];
            pre_triangle.image = [UIImage imageNamed:@"triangle_gray_1"];//还原成朝下的灰色三角
            

        }
        
        //现在被点击的按钮变为蓝色
        [button setTitleColor:[UIColor colorWithRed:14.0/255.0 green:108.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];//现在被点击的button标题设为蓝色
        triangle.image = [UIImage imageNamed:@"triangle_blue_1"];//设置成朝下的蓝色三角
//        if ([[triangle_flag valueForKey:[NSString stringWithFormat:@"%ld",button.tag*10]] isEqualToString:@"1"]) {
//            triangle.image = [UIImage imageNamed:@"triangle_blue_1"];//设置成朝下的蓝色三角
//        } else {
//            triangle.image = [UIImage imageNamed:@"triangle_blue_2"];//设置成朝上的蓝色三角
//        }
        button_flag = button.tag;
        
    }
    else {
        //设置三角旋转
        CGAffineTransform rotation;
        if ([[triangle_flag valueForKey:[NSString stringWithFormat:@"%ld",button.tag*10]] isEqualToString:@"1"]) {
            [triangle_flag setValue:@"2" forKey:[NSString stringWithFormat:@"%ld",button.tag*10]];
            rotation= CGAffineTransformMakeRotation(M_PI);//pi 180°
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 triangle.transform = rotation;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            [triangle_flag setValue:@"1" forKey:[NSString stringWithFormat:@"%ld",button.tag*10]];
            rotation= CGAffineTransformMakeRotation(0);//0°
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 triangle.transform = rotation;
                             }
                             completion:^(BOOL finished) {
                                 [triangle_flag setValue:@"1" forKey:[NSString stringWithFormat:@"%ld",button.tag*10]];
                             }];
        }

    }
    
    //对用户投资记录进行排序
    if (button.tag == 101) {//按投资时间降序
        if ([[triangle_flag valueForKey:[NSString stringWithFormat:@"%ld",button.tag*10]] isEqualToString:@"1"]) {
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
            sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
            //NSLog(@"sortedRecord:%@",sortedRecord);
        }
        else {//按投资时间升序
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
            sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
        }
    }
    else if (button.tag == 102) {//按投资金额降序
        if ([[triangle_flag valueForKey:[NSString stringWithFormat:@"%ld",button.tag*10]] isEqualToString:@"1"]) {
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"capital" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
            sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
            
        }
        else {//按投资金额升序
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"capital" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
            sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
        }
    }
    else {//按年化收益率降序
        if ([[triangle_flag valueForKey:[NSString stringWithFormat:@"%ld",button.tag*10]] isEqualToString:@"1"]) {
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"maxRate" ascending:NO];
            NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"minRate" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,secondDescriptor,nil];
            sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
            
        }
        else {//按年化收益率升序
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"maxRate" ascending:YES];
            NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"minRate" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,secondDescriptor,nil];
            sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
        }
    }
    
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
    return [records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
//        //投资开始日期
//        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, screen_width/3-25, 15)];
//        label7.tag = 1006;
//        label7.font = [UIFont systemFontOfSize:15];
//        [cell.contentView addSubview:label7];

        //投资结束日期
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
        cell.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:247.0/255.0 alpha:1.0];
    }
    
    //写入数据
//    UILabel *label7 = (UILabel *)[cell.contentView viewWithTag:1006];
    UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:1001];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1002];
    UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:1003];
    UILabel *label4 = (UILabel *)[cell.contentView viewWithTag:1004];
    UILabel *label5 = (UILabel *)[cell.contentView viewWithTag:1005];
    NSString *imageName = [NSString stringWithFormat:@"%@-icon",[sortedRecord[indexPath.row] objectForKey:@"platform"]];
    [imageView setImage:[UIImage imageNamed:imageName]];
//    NSString *label7Text = [NSString stringWithFormat:@"%@",[sortedRecord[indexPath.row] objectForKey:@"startDate"]];
//    label7.text = label7Text;
    NSString *label1Text = [NSString stringWithFormat:@"%@",[sortedRecord[indexPath.row] objectForKey:@"endDate"]];
    label1.text = label1Text;
    NSString *label2Text = [NSString stringWithFormat:@"%@-%@",[sortedRecord[indexPath.row] objectForKey:@"platform"],[sortedRecord[indexPath.row] objectForKey:@"product"]];
    label2.text = label2Text;
    NSString *label4Text = [NSString stringWithFormat:@"%.1f",[[sortedRecord[indexPath.row] objectForKey:@"capital"] floatValue]];
    label4.text = label4Text;
    if ([[sortedRecord[indexPath.row] objectForKey:@"minRate"] floatValue] == 0 ) {
        NSString *label5Text = [NSString stringWithFormat:@"%.2f%%",[[sortedRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
        label5.text = label5Text;
    }
    else if ([[sortedRecord[indexPath.row] objectForKey:@"maxRate"] floatValue] == 0) {
        NSString *label5Text = [NSString stringWithFormat:@"%.2f%%",[[sortedRecord[indexPath.row] objectForKey:@"minRate"] floatValue]];
        label5.text = label5Text;
    }
    else {
        NSString *label5Text = [NSString stringWithFormat:@"%.2f%%~%.2f%%",[[sortedRecord[indexPath.row] objectForKey:@"minRate"] floatValue],[[sortedRecord[indexPath.row] objectForKey:@"maxRate"] floatValue]];
        label5.text = label5Text;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}//返回cell的高度


@end
