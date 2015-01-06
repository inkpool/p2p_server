//
//  PlatformViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "PlatformViewController.h"
#import "PlatformDetailViewController.h"

@interface PlatformViewController ()
{
    CGFloat screen_width;
    CGFloat screen_height;
    CGFloat startX;
}
@end

@implementation PlatformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:247.0/255.0 alpha:1.0];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 1)];//view1的作用就是避免scrollView下垂
    [self.view addSubview:view1];
    
    startX = screen_width/2-screen_width/10;
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 70)];
    //myScrollView.backgroundColor = [UIColor clearColor];//clearColor去除背景颜色
    //是否支持滑动到最顶端
    myScrollView.delegate = self;
    //设置内容大小
    myScrollView.contentSize = CGSizeMake(startX*2 + screen_width/5 * [plateformArray count], myScrollView.frame.size.height);
//    myScrollView.alwaysBounceHorizontal = YES;
//    myScrollView.alwaysBounceVertical = NO;
    myScrollView.pagingEnabled = NO;
    myScrollView.decelerationRate = 0.2;
    //加载scrollView
    [self.view addSubview:myScrollView];
    
    for (int i = 0; i < [plateformArray count]; i++) {
        UIView *platformView = [[UIView alloc] initWithFrame:CGRectMake(startX+i*screen_width/5, 0, screen_width/5, 60)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/10-22, 10, 44, 26)];
        imageView.tag = 1000+i;
        NSString *imageName = [NSString stringWithFormat:@"%@-icon",plateformArray[i]];
        imageView.image = [UIImage imageNamed:imageName];
        [platformView addSubview:imageView];
        UILabel *platformNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, screen_width/5, 10)];
        platformNameLabel.text = plateformArray[i];
        platformNameLabel.textAlignment = NSTextAlignmentCenter;
        platformNameLabel.font = [UIFont systemFontOfSize:12];
        [platformView addSubview:platformNameLabel];
        
        [myScrollView addSubview:platformView];
    }
    myScrollView.contentOffset = CGPointMake(([plateformArray count]-1)/2*screen_width/5,0);
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 131, screen_width, 5)];
    pageControl.numberOfPages = [plateformArray count];
    pageControl.tag = 11;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    myScrollView.showsHorizontalScrollIndicator = NO;//不显示滑动条
    pageControl.currentPage = ([plateformArray count]-1)/2;
    [self.view addSubview:pageControl];//不能加载到scrollView上，避免拖动时将pageIndicaator也拖走
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 137, screen_width, 2)];
    line.image = [UIImage imageNamed:@"horiz_line"];
    [self.view addSubview:line];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+145, screen_width/3, 20)];
    label1.tag = 100;
    label1.font = [UIFont systemFontOfSize:20];
    label1.text = [NSString stringWithFormat:@"%@",plateformArray[([plateformArray count]-1)/2]];
    [self.view addSubview:label1];
    UILabel *label1_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30+145, screen_width/3*2, 25)];
    label1_1.tag = 101;
    label1_1.text = @"预期收益:￥1888878.80";
    label1_1.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:label1_1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-90, 30+145+10, 90, 25)];
    label2.tag = 102;
    label2.text = @"12.80%";
    label2.textColor = [UIColor redColor];
    label2.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30+25+5+145, screen_width-20, 20)];
    label3.tag = 103;
    label3.text = [NSString stringWithFormat:@"在投总额:%.1f",[[remainCapitalDic objectForKey:plateformArray[([plateformArray count]-1)/2]] floatValue]];
    label3.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:label3];
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30+25+5+145+20, screen_width, screen_height-(30+25+5+145+20)-49)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x+screen_width/10)/(screen_width/5);
    NSLog(@"第%i页",index);
    
    if(index<[plateformArray count])
    {
        UIImageView *imageView = (UIImageView*)[self.view viewWithTag:1000+index];
        //开始放大
        CGPoint center = imageView.center;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect imageRect = imageView.frame;
            imageRect.size = CGSizeMake(68, 43);
            [imageView setFrame:imageRect];
            [imageView setCenter:center];
        }];
        
        if (index != 0) {
            UIImageView *imageView = (UIImageView*)[self.view viewWithTag:1000+index-1];
            //缩小
            CGPoint center = imageView.center;
            [UIView animateWithDuration:0.5 animations:^{
                CGRect imageRect = imageView.frame;
                imageRect.size = CGSizeMake(44, 26);
                [imageView setFrame:imageRect];
                [imageView setCenter:center];
            }];
        }
        if (index != [plateformArray count]-1) {
            UIImageView *imageView = (UIImageView*)[self.view viewWithTag:1000+index+1];
            //缩小
            CGPoint center = imageView.center;
            [UIView animateWithDuration:0.5 animations:^{
                CGRect imageRect = imageView.frame;
                imageRect.size = CGSizeMake(44, 26);
                [imageView setFrame:imageRect];
                [imageView setCenter:center];
            }];
        }
        UILabel *label1 = (UILabel*)[self.view viewWithTag:100];
        label1.text = plateformArray[index];
        UILabel *label3 = (UILabel*)[self.view viewWithTag:103];
        label3.text = [NSString stringWithFormat:@"在投总额:%.1f",[[remainCapitalDic objectForKey:plateformArray[index]] floatValue]];
        UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:11];
        pageControl.currentPage = index;
    }
}

#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return  [records count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UIView*) tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    titleLabel.text = @"历史信息";
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, screen_width/3, 20)];
        label1.tag = 1001;
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-110, 10, 100, 20)];
        label2.tag = 1002;
        label2.text = @"2014-11-04";
        [cell.contentView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, screen_width-20, 20)];
        label3.tag = 1003;
        [cell.contentView addSubview:label3];
        
    }
    
    UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:1001];
    UILabel *label3 = (UILabel *)[cell.contentView viewWithTag:1003];
    if (indexPath.row%2 == 0) {
        label1.text = @"买入";
        label1.textColor = [UIColor colorWithRed:20.0/255.0 green:130.0/255.0 blue:1.0/255.0 alpha:1];
        label3.text = @"+ 50000元";
    } else {
        label1.text = @"卖出";
        label1.textColor = [UIColor redColor];
        label3.text = @"- 50000元";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}//返回cell的高度

@end
