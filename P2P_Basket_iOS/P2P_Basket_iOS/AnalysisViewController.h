//
//  AnalysisViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface AnalysisViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,CPTPlotDataSource,CPTPieChartDelegate,CPTBarPlotDelegate>
{
    NSMutableDictionary *platformTotalCapital;
    UIAlertController *myAlert;
    
@public
    NSMutableArray *records;//用户所有的投资记录
    UIView *_mainContentView;
    CPTPieChart *piePlot;
    CPTBarPlot *barPlot;
    CPTXYAxis *xAxis;
    NSArray *platformName;
    NSInteger index3;
}

@property(retain,nonatomic)CPTGraphHostingView *hostView;
@property(retain,nonatomic)CPTXYGraph *graph;
@property(retain,nonatomic)CPTXYPlotSpace *plotSpace;

- (void)initArray2;

@end
