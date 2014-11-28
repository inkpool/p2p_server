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
    UITableView *tableView;//表视图:显示已到期投资和即将到期投资
    int flag;//用于记录当前显示的是即将到期（1）还是已经到期（2）
}

@end
