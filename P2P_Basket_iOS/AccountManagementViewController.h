//
//  AccountManagementViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-26.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountManagementViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
@public
    BOOL isManagement;
    NSMutableArray *userInfoArray;
    NSString *loggedOnUser;
}
@end
