//
//  RootViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"

@interface RootViewController : UIViewController<UIViewPassValueDelegate,UITabBarControllerDelegate>
{
    UINavigationController *nc;
    NSMutableArray *records;//用户所有的投资记录
}

@end
