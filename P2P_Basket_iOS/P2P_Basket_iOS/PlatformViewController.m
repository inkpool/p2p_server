//
//  PlatformViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

//earning：具体加了多少钱(收益)
//takeout：具体取出多少钱 假如用户不输入的话 就为0
//timeStampEnd：结算的时间戳
//rest：操作完成之后 平台的余额还剩多少

#import "PlatformViewController.h"
#import "PlatformDetailViewController.h"

@interface PlatformViewController ()
{
    CGFloat screen_width;
    CGFloat screen_height;
    int tagRecord;//记录用户选择的平台
}
@end

@implementation PlatformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:247.0/255.0 alpha:1.0];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    
    if ([plateformArray count] != 0) {
        tagRecord = 10;
    }
    else {
        tagRecord = 0;
    }
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 1)];//view1的作用就是避免scrollView下垂
    [self.view addSubview:view1];
    
    CGFloat myScrollViewHight = screen_height/6;
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screen_width, myScrollViewHight)];
    //是否支持滑动到最顶端
    myScrollView.delegate = self;
    //设置内容大小
    myScrollView.contentSize = CGSizeMake(screen_width/3 * [plateformArray count], myScrollView.frame.size.height);
    myScrollView.pagingEnabled = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;//不显示滑动条
    //加载scrollView
    [self.view addSubview:myScrollView];
    
    if ([plateformArray count] != 0) {
        tagRecord = 10;
        UIView *platformBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width/3, myScrollViewHight)];
        platformBgView.tag = 10000;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/18, myScrollViewHight/6-5, screen_width*2/9, myScrollViewHight/3*2+10)];
        NSString *imageName = [NSString stringWithFormat:@"%@-120",plateformArray[0]];
        imageView.image = [UIImage imageNamed:imageName];
        [platformBgView addSubview:imageView];
        //添加橙色三角形
        UIImageView *orangeArrow = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width/3-myScrollViewHight/6)/2, myScrollViewHight/3*2+myScrollViewHight/6+myScrollViewHight/12, myScrollViewHight/6, myScrollViewHight/10)];
        orangeArrow.tag = 1000;
        orangeArrow.image = [UIImage imageNamed:@"platform_arrow"];
        [platformBgView addSubview:orangeArrow];
        
        UIButton *platformButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width/3, myScrollViewHight)];
        platformButton.tag = 10;
        [platformButton addTarget:self action:@selector(platformButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [platformBgView addSubview:platformButton];
        
        [myScrollView addSubview:platformBgView];
        
        for (int i = 1; i < [plateformArray count]; i++) {
            UIView *platformBgView = [[UIView alloc] initWithFrame:CGRectMake(i*screen_width/3, 0, screen_width/3, myScrollViewHight)];
            platformBgView.tag = 10000 + i;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/18, myScrollViewHight/6-5, screen_width*2/9, myScrollViewHight/3*2+10)];
            NSString *imageName = [NSString stringWithFormat:@"%@-120",plateformArray[i]];
            imageView.image = [UIImage imageNamed:imageName];
            [platformBgView addSubview:imageView];
            //添加橙色三角形
            UIImageView *orangeArrow = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width/3-myScrollViewHight/6)/2, myScrollViewHight/3*2+myScrollViewHight/6+myScrollViewHight/12, myScrollViewHight/6, myScrollViewHight/10)];
            orangeArrow.tag = 1000+i;
            orangeArrow.image = [UIImage imageNamed:@"platform_arrow"];
            [platformBgView addSubview:orangeArrow];
            orangeArrow.hidden = YES;
            
            UIButton *platformButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width/3, myScrollViewHight)];
            platformButton.tag = 10+i;
            [platformButton addTarget:self action:@selector(platformButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [platformBgView addSubview:platformButton];
            
            [myScrollView addSubview:platformBgView];
        }
    }
    
    
//    myScrollView.contentOffset = CGPointMake(([plateformArray count]-1)/2*screen_width/5,0);
    
//    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 131, screen_width, 5)];
//    pageControl.numberOfPages = [plateformArray count];
//    pageControl.tag = 11;
//    pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
//    pageControl.currentPage = ([plateformArray count]-1)/2;
//    [self.view addSubview:pageControl];//不能加载到scrollView上，避免拖动时将pageIndicaator也拖走
    
//    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 137, screen_width, 2)];
//    line.image = [UIImage imageNamed:@"horiz_line"];
//    [self.view addSubview:line];
    
    UIView *orangeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, myScrollViewHight+64, screen_width, screen_height/4.5)];
    orangeBgView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:83.0/255.0 blue:48.0/255.0 alpha:1];
    [self.view addSubview:orangeBgView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, orangeBgView.frame.size.height/4+5, screen_width/2-25, 20)];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:18];
    label1.text = @"平台投资总收益";
    [orangeBgView addSubview:label1];
    UILabel *label1_1 = [[UILabel alloc] initWithFrame:CGRectMake(15, orangeBgView.frame.size.height/2, screen_width/2-15, 30)];
    label1_1.textColor = [UIColor whiteColor];
    label1_1.text = @"799878.8元";
    label1_1.font = [UIFont systemFontOfSize:24];
    [orangeBgView addSubview:label1_1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+15, orangeBgView.frame.size.height/4+5, screen_width/2-30, 20)];
    label2.text = @"预期年化收益率";
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:18];
    [orangeBgView addSubview:label2];
    UILabel *label2_2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+15, orangeBgView.frame.size.height/2, screen_width/2-30, 30)];
    label2_2.textAlignment = NSTextAlignmentRight;
    label2_2.textColor = [UIColor whiteColor];
    label2_2.text = @"12.80%";
    label2_2.font = [UIFont systemFontOfSize:24];
    [orangeBgView addSubview:label2_2];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2, orangeBgView.frame.size.height/4, 1, orangeBgView.frame.size.height/2)];
    line1.image = [UIImage imageNamed:@"vertical_line"];
    [orangeBgView addSubview:line1];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15,myScrollViewHight+64+orangeBgView.frame.size.height+screen_height/48, screen_width/2-65, 20)];
    label3.text = @"投资总额";
//    label3.backgroundColor = [UIColor redColor];
    [self.view addSubview:label3];
    UILabel *label3_2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-50,myScrollViewHight+64+orangeBgView.frame.size.height+screen_height/48-5, screen_width/2+15, 30)];
    label3_2.text = @"45678458.0";
    label3_2.textAlignment = NSTextAlignmentRight;
    label3_2.font = [UIFont systemFontOfSize:25];
//    label3_2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:label3_2];
    UILabel *label3_3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-30,myScrollViewHight+64+orangeBgView.frame.size.height+screen_height/48, 15, 20)];
    label3_3.text = @"元";
//    label3_3.backgroundColor = [UIColor redColor];
    [self.view addSubview:label3_3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15,myScrollViewHight+64+orangeBgView.frame.size.height+screen_height/12+screen_height/48, screen_width/2-65, 20)];
    label4.text = @"平台余额";
//    label4.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label4];
    UILabel *label4_2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-50,myScrollViewHight+64+orangeBgView.frame.size.height+screen_height/12+screen_height/48-5, screen_width/2+15, 30)];
    label4_2.text = @"1554485.0";
    label4_2.textAlignment = NSTextAlignmentRight;
    label4_2.font = [UIFont systemFontOfSize:25];
//    label4_2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:label4_2];
    UILabel *label4_3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-30,myScrollViewHight+64+orangeBgView.frame.size.height+screen_height/12+screen_height/48, 15, 20)];
    label4_3.text = @"元";
//    label4_3.backgroundColor = [UIColor redColor];
    [self.view addSubview:label4_3];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, myScrollViewHight+64+screen_height/4.5+screen_height/6, screen_width, 1)];
    line2.image = [UIImage imageNamed:@"horiz_line"];
    [self.view addSubview:line2];
    
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, myScrollViewHight+64+screen_height/4.5+screen_height/6+1, screen_width, screen_height/7-1)];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"button_bk_image"] forState:UIControlStateHighlighted];
    [self.view addSubview:recordButton];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(15,myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/40, 80, 20)];
    label5.text = @"成交记录";
//        label5.backgroundColor = [UIColor redColor];
    [self.view addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(15,myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/14+(screen_height/14-screen_height/40-20), 80, 20)];
    label6.text = @"暂无数据";
//        label6.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label6];
    
    UILabel *label6_2 = [[UILabel alloc] initWithFrame:CGRectMake(15+80+5,myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/14+(screen_height/14-screen_height/40-20), 35, 20)];
    label6_2.text = @"收益";
//    label6_2.backgroundColor = [UIColor redColor];
    [self.view addSubview:label6_2];
    
    UILabel *label6_3 = [[UILabel alloc] initWithFrame:CGRectMake(15+80+5+35+2,myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/14+(screen_height/14-screen_height/40-20), 10, 20)];
    label6_3.text = @"+";
    label6_3.font = [UIFont systemFontOfSize:17];
    label6_3.textColor = [UIColor colorWithRed:35.0/255 green:150.0/255 blue:0 alpha:1];
//    label6_3.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label6_3];
    
    UILabel *label6_4 = [[UILabel alloc] initWithFrame:CGRectMake(15+80+5+35+2+10+2,myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/14+(screen_height/14-screen_height/40-20)-5, screen_width/2-15, 30)];
    label6_4.text = @"9156433.0元";
    label6_4.font = [UIFont systemFontOfSize:25];
    label6_4.textColor = [UIColor colorWithRed:35.0/255 green:150.0/255 blue:0 alpha:1];
//        label6_4.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label6_4];
    
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/7, screen_width, 1)];
    line3.image = [UIImage imageNamed:@"horiz_line"];
    [self.view addSubview:line3];
    
    UIButton *investButton = [[UIButton alloc] initWithFrame:CGRectMake(0, myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/7+1, screen_width/2, screen_height/16)];
    [investButton setTitle:@"投资" forState:UIControlStateNormal];
//    investButton.backgroundColor = [UIColor blueColor];
    [investButton setTitleColor:[UIColor colorWithRed:251.0/255.0 green:83.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
    [investButton setBackgroundImage:[UIImage imageNamed:@"button_bk_image"] forState:UIControlStateHighlighted];
    [self.view addSubview:investButton];
    
    UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2, myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/7+1, 1, screen_height/16)];
    line4.image = [UIImage imageNamed:@"vertical_line"];
    [self.view addSubview:line4];
    
    UIButton *fetchButton = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/2+1, myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/7+1, screen_width/2-1, screen_height/16)];
    [fetchButton setTitle:@"取回" forState:UIControlStateNormal];
    //    investButton.backgroundColor = [UIColor blueColor];
    [fetchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fetchButton setBackgroundImage:[UIImage imageNamed:@"button_bk_image"] forState:UIControlStateHighlighted];
    [self.view addSubview:fetchButton];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-15-13, myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/14-13, 13, 26)];
    arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
    [self.view addSubview:arrowImageView];
    
    UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, myScrollViewHight+64+screen_height/4.5+screen_height/6+screen_height/7+screen_height/16+1, screen_width, 1)];
    line5.image = [UIImage imageNamed:@"horiz_line"];
    [self.view addSubview:line5];
    
//    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30+25+5+145+20, screen_width, screen_height-(30+25+5+145+20)-49)];
//    myTableView.delegate = self;
//    myTableView.dataSource = self;
//    myTableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:myTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)platformButtonPressed:(id)sender {
    UIButton *platformButton = (UIButton *)sender;
//    NSLog(@"%d",platformButton.tag);
    if (tagRecord != platformButton.tag) {
        UIView *platformBgView1 = (UIView *)[myScrollView viewWithTag:10000+platformButton.tag-10];
        UIView *platformBgView2 = (UIView *)[myScrollView viewWithTag:10000+tagRecord-10];
        UIImageView *orangeArrow1 = (UIImageView *)[platformBgView1 viewWithTag:1000+platformButton.tag-10];
        UIImageView *orangeArrow2 = (UIImageView *)[platformBgView2 viewWithTag:1000+tagRecord-10];
        orangeArrow1.hidden = NO;
        orangeArrow2.hidden = YES;
        tagRecord = (int)platformButton.tag;
    }
}

#pragma mark -
#pragma mark ScrollView Delegate

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    int index = (scrollView.contentOffset.x+screen_width/10)/(screen_width/5);
//    NSLog(@"第%i页",index);
//    
//    if(index<[plateformArray count])
//    {
//        UIImageView *imageView = (UIImageView*)[self.view viewWithTag:1000+index];
//        //开始放大
//        CGPoint center = imageView.center;
//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect imageRect = imageView.frame;
//            imageRect.size = CGSizeMake(68, 43);
//            [imageView setFrame:imageRect];
//            [imageView setCenter:center];
//        }];
//        
//        if (index != 0) {
//            UIImageView *imageView = (UIImageView*)[self.view viewWithTag:1000+index-1];
//            //缩小
//            CGPoint center = imageView.center;
//            [UIView animateWithDuration:0.5 animations:^{
//                CGRect imageRect = imageView.frame;
//                imageRect.size = CGSizeMake(44, 26);
//                [imageView setFrame:imageRect];
//                [imageView setCenter:center];
//            }];
//        }
//        if (index != [plateformArray count]-1) {
//            UIImageView *imageView = (UIImageView*)[self.view viewWithTag:1000+index+1];
//            //缩小
//            CGPoint center = imageView.center;
//            [UIView animateWithDuration:0.5 animations:^{
//                CGRect imageRect = imageView.frame;
//                imageRect.size = CGSizeMake(44, 26);
//                [imageView setFrame:imageRect];
//                [imageView setCenter:center];
//            }];
//        }
//        UILabel *label1 = (UILabel*)[self.view viewWithTag:100];
//        label1.text = plateformArray[index];
//        UILabel *label3 = (UILabel*)[self.view viewWithTag:103];
//        label3.text = [NSString stringWithFormat:@"在投总额:%.1f",[[remainCapitalDic objectForKey:plateformArray[index]] floatValue]];
//        UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:11];
//        pageControl.currentPage = index;
//    }
//}

#pragma mark - TableView delegate methods
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    //这个方法用来告诉表格有几个分组
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section {
//    return  [records count];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 40;
//}
//
//-(UIView*) tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
//    titleLabel.text = @"历史信息";
//    [headerView addSubview:titleLabel];
//    return headerView;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *TableSampleIdentifier = @"CellIdentifier";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
//                             TableSampleIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:TableSampleIdentifier];
//        cell.backgroundColor = [UIColor clearColor];
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, screen_width/3, 20)];
//        label1.tag = 1001;
//        [cell.contentView addSubview:label1];
//        
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-110, 10, 100, 20)];
//        label2.tag = 1002;
//        label2.text = @"2014-11-04";
//        [cell.contentView addSubview:label2];
//        
//        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, screen_width-20, 20)];
//        label3.tag = 1003;
//        [cell.contentView addSubview:label3];
//        
//    }
//    
//    UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:1001];
//    UILabel *label3 = (UILabel *)[cell.contentView viewWithTag:1003];
//    if (indexPath.row%2 == 0) {
//        label1.text = @"买入";
//        label1.textColor = [UIColor colorWithRed:20.0/255.0 green:130.0/255.0 blue:1.0/255.0 alpha:1];
//        label3.text = @"+ 50000元";
//    } else {
//        label1.text = @"卖出";
//        label1.textColor = [UIColor redColor];
//        label3.text = @"- 50000元";
//    }
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}//返回cell的高度
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 12;
//}

@end
