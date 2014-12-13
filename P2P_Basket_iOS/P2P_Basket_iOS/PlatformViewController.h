//
//  PlatformViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
@public
    NSMutableSet *platformSet;//用户所有投资过的平台记录
}
@end
