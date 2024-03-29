//
//  FlowViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"

@interface FlowViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
@public
    UITableView *myTableView;
    NSMutableArray *records;//用户所有的投资记录
    NSInteger button_flag;//记录此前哪个button被选中
    NSMutableDictionary *triangle_flag;//记录三角的朝向
    NSObject<UIViewPassValueDelegate> *delegate;//在删除已有的投资后，要刷新主页和流水界面的tableVIew
}
@end
