//
//  LeftSliderController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "LeftSliderController.h"

@interface LeftSliderController ()
{
    NSArray *plateformArray;//从platformSet提取出所有的平台名称
}
@end

@implementation LeftSliderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //打算模仿QQ侧边栏来做sidebar
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    
    //添加一个背景图片
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:backView];
    

    //添加一个tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 80, screen_width, screen_height-160)];
    //tableView.backgroundView = backView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    }
    plateformArray = [platformSet allObjects];
    cell.textLabel.text = plateformArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-icon",plateformArray[indexPath.row]]];
    cell.backgroundColor=[UIColor clearColor];
    
    
//    NSUInteger row = [indexPath row];
//    
//    switch(row)
//    {
//        case 4:
//            {
//                cell.textLabel.text = @"账户设置";
//                UIImage *image = [UIImage imageNamed:@"homepage"];
//                cell.imageView.image = image;
//                cell.backgroundColor=[UIColor clearColor];
//                break;
//            }
//        case 5:
//            {
//                cell.textLabel.text = @"云端备份";
//                UIImage *image = [UIImage imageNamed:@"homepage"];
//                cell.imageView.image = image;
//                cell.backgroundColor=[UIColor clearColor];
//                break;
//            }
//        case 6:
//            {
//                cell.textLabel.text = @"用户反馈";
//                UIImage *image = [UIImage imageNamed:@"homepage"];
//                cell.imageView.image = image;
//                cell.backgroundColor=[UIColor clearColor];
//                break;
//            }
//        case 7:
//            {
//                cell.textLabel.text = @"联系我们";
//                UIImage *image = [UIImage imageNamed:@"homepage"];
//                cell.imageView.image = image;
//                cell.backgroundColor=[UIColor clearColor];
//                break;
//            }
//        default: cell.backgroundColor=[UIColor clearColor];break;
//    }
    return cell;
}




@end
