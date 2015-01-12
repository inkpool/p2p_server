//
//  LeftSliderController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"

@interface LeftSliderController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
@public
    BOOL networkConnected;
    NSObject<UIViewPassValueDelegate> *delegate;//在AddViewController中添加新的投资后，要刷新主页,流水界面的tableVIew和分析界面
    NSMutableArray *userInfoArray;
    NSString *loggedOnUser;
}

+ (id)sharedViewController;//单例，RootViewController只初始化一次
- (void)initLoggedOnUser;

@end
