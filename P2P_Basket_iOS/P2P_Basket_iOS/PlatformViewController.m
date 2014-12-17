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
    NSArray *plateformArray;//从platformSet提取出所有的平台名称
}
@end

@implementation PlatformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    
    //添加一个tableView
    tableView = [[UITableView alloc] init];
    if (44*[platformSet count] < screen_height-64-49) {
        tableView.frame = CGRectMake(0, 64, screen_width, 44*[platformSet count]);
    } else {
        tableView.frame = CGRectMake(0, 64, screen_width, screen_height-64-49);
    }
    tableView.backgroundColor=[UIColor clearColor];
    //tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableView];
    tableView.delegate=self;
    tableView.dataSource=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [platformSet count];
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
        plateformArray = [platformSet allObjects];
        cell.textLabel.text = plateformArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-icon",plateformArray[indexPath.row]]];
        cell.backgroundColor=[UIColor clearColor];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *platformRecords = [[NSMutableArray alloc] init];//对应平台的所有投资记录
    PlatformDetailViewController *platformDetailVC = [[PlatformDetailViewController alloc] init];
    platformDetailVC->platformName = plateformArray[indexPath.row];
    for (int i = 0; i < [records count]; i++) {
        if ([[records[i] objectForKey:@"platform"] isEqualToString:plateformArray[indexPath.row]]) {
            [platformRecords addObject:records[i]];
        }
    }
    platformDetailVC->records = platformRecords;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:platformDetailVC];
    [self presentViewController:navC animated:YES completion:nil];
    
}


@end
