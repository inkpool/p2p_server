//
//  LeftSliderController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSliderController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
@public
    NSMutableArray *records;//用户所有的投资记录
    BOOL networkConnected;
}

+ (id)sharedViewController;//单例，RootViewController只初始化一次

@end
