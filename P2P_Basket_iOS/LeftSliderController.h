//
//  LeftSliderController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface LeftSliderController : UIViewController<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
@public
    NSMutableArray *records;//用户所有的投资记录
}
@end
