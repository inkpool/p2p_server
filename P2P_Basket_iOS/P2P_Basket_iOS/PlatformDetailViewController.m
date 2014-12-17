//
//  PlatformDetailViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-17.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "PlatformDetailViewController.h"

@interface PlatformDetailViewController ()
{
    CGFloat screen_width;
    CGFloat screen_height;
}
@end

@implementation PlatformDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;

    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    titleLabel.text = platformName;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.navigationItem.titleView = titleLabel;
    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+5, screen_width/3, 20)];
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"昨日收益预估";
    [self.view addSubview:label1];
    UILabel *label1_1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 64+30, screen_width/2-20, 25)];
    label1_1.tag = 101;
    label1_1.text = @"￥1888878.80";
    label1_1.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:label1_1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+20, 64+5, screen_width/2-30, 20)];
    label2.font = [UIFont systemFontOfSize:16];
    label2.text = @"预期年化收益率";
    [self.view addSubview:label2];
    UILabel *label2_1 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-100, 64+30, 90, 25)];
    label2_1.tag = 102;
    label2_1.text = @"12.80%";
    label2_1.textColor = [UIColor redColor];
    label2_1.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:label2_1];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+30+25+5, screen_width/3, 20)];
    label3.text = @"投资总额";
    label3.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label3];
    UILabel *label3_1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 64+30+25+5+20+5, screen_width-40, 25)];
    label3_1.tag = 103;
    label3_1.text = @"￥188887815652.80";
    label3_1.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:label3_1];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+30+25+5+20+5+25+10, screen_width, screen_height-(64+30+25+5+20+25+5)-10)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ButtonPressedAction

- (void)backItemPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
                initWithStyle:UITableViewCellStyleValue1
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
