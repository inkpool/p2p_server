//
//  AnalysisViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-25.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"

@interface AnalysisViewController : UIViewController<PieChartDelegate>
{
    NSInteger flag;
@public
    NSMutableArray *records;//用户所有的投资记录
    NSMutableArray *unExpireRecord;//未到期的投资记录
    PieChartView *myPieChartView;
}

@property (nonatomic,strong) UIView *pieContainer;;
@property (nonatomic,strong) UILabel *selLabel;

- (void)reloadData;
- (void)initArray;
- (void)onCenterClick:(PieChartView *)pieChartView;

@end
