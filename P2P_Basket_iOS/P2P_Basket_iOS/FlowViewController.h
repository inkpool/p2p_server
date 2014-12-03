//
//  FlowViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@public
    UITableView *tableView;
    NSMutableArray *records;//用户所有的投资记录
    NSInteger button_flag;//记录此前哪个button被选中
    NSMutableDictionary *triangle_flag;//记录三角的朝向
    NSArray *sortedRecord;//保存用户投资记录排序后的结果
}
@end
