//
//  PlatformViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    
@public
    NSMutableArray *records;//用户所有的投资记录
    NSArray *plateformArray;//用户所有投资过的平台记录
    NSMutableDictionary *incomeDic;//用户投资过的平台各自对应的当前预期收益
    NSMutableDictionary *remainCapitalDic;//用户投资过的平台各自对应的投资总额
    NSMutableDictionary *rateMinDic;//用户投资过的平台各自对应的最小年化收益率
    NSMutableDictionary *rateMaxDic;//用户投资过的平台各自对应的最大年化收益率
}
@end
