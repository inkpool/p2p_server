//
//  AboutUsViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-13.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
{
    CGFloat screen_width;
    CGFloat screen_height;
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    titleLabel.text = @"关于我们";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.navigationItem.titleView = titleLabel;
    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backItemPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 70, 70)];
    imageView.image = [UIImage imageNamed:@"golden_eggs.jpg"];
    [self.view addSubview:imageView];
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 140, 100, 20)];
//    nameLabel.text = @"网贷篮子";
//    [self.view addSubview:nameLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 140, screen_width-20, 215) ];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
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
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @" ";
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(UIView*) tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    headerView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
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
    }
    
    if (indexPath.section == 0) {
        UILabel *detailLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, screen_width-30, 70)];
        detailLable.text = @"       网贷篮子——为您提供随时的理财记账服务，让您掌握自己的理财情况，收益最大，风险最低。";
        detailLable.numberOfLines = 4;
        cell.userInteractionEnabled = NO;
        [cell.contentView addSubview:detailLable];
    } else {
        if (indexPath.row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 4, 42, 42)];
            imageView.image = [UIImage imageNamed:@"wechat-icon"];
            [cell.contentView addSubview:imageView];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 150, 30)];
            lable.text = @"关注微信";
            [cell.contentView addSubview:lable];
            cell.tag = 101;
            
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
            imageView.image = [UIImage imageNamed:@"weibo-icon"];
            [cell.contentView addSubview:imageView];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 150, 30)];
            lable.text = @"关注微博";
            [cell.contentView addSubview:lable];
            cell.tag = 102;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    } else {
        return 50;
    }
}//返回cell的高度

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = (UITableViewCell *)[self.view viewWithTag:101];
    }
    else {
        cell = (UITableViewCell *)[self.view viewWithTag:102];
    }
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}


@end
