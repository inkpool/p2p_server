//
//  UIViewPassValueDelegate.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-3.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIViewPassValueDelegate <NSObject>

- (void)refresh1;//在AddViewController中添加新的投资后，要刷新主页和流水界面的tableView，以及分析界面的分析图
- (void)refresh2;//在FlowViewController删除已有的投资后，要刷新主页的tableVIew，以及分析界面的分析图

@end

