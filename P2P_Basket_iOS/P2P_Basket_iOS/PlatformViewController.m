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
//    CGFloat screen_height = size.height;
    
    plateformArray = [platformSet allObjects];
    
    //添加一个tableView
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 44*[platformSet count])];
//    if (44*[platformSet count] < screen_height-64-49) {
//        tableView.frame = CGRectMake(0, 64, screen_width, 44*[platformSet count]);
//    } else {
//        tableView.frame = CGRectMake(0, 64, screen_width, screen_height-64-49);
//    }
    myTableView.backgroundColor=[UIColor clearColor];
    [self setExtraCellLineHidden: myTableView];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = plateformArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-icon",plateformArray[indexPath.row]]];
    
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
    platformDetailVC->preTableView = tableView;
    for (int i = 0; i < [records count]; i++) {
        if ([[records[i] objectForKey:@"platform"] isEqualToString:plateformArray[indexPath.row]]) {
            [platformRecords addObject:records[i]];
        }
    }
    platformDetailVC->records = platformRecords;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:platformDetailVC];
    [self presentViewController:navC animated:YES completion:nil];
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{//消除 UITableView多余的空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

@end
