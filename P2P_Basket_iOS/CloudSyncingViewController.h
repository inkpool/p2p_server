//
//  CloudBackupViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-16.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudSyncingViewController : UIViewController
{
    NSMutableArray *records;//用户所有的投资记录
@public
    NSString *loggedOnUser;
}
@end
