//
//  RootViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-4.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger flag;//用于记录当前显示的是即将到期（1）还是已经到期（2）
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *incomeLabel1;
    IBOutlet UILabel *incomeLabel2;
    IBOutlet UILabel *rateLabel1;
    IBOutlet UILabel *rateLable2;
    IBOutlet UILabel *totalCapitalLable;
@public
    UITableView *tableView;//表视图:显示已到期投资和即将到期投资
    NSMutableArray *records;//用户所有的投资记录
    NSMutableArray *expireRecord;//已到期的投资记录
    NSMutableArray *expiringRecord;//即将到期的投资记录
}

- (void)showData;

@end
