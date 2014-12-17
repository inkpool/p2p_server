//
//  PlatformDetailViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-17.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@public
    NSString *platformName;
    NSMutableArray *records;//对应平台的所有投资记录
}
@end
