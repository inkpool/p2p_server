//
//  AddViewController.h
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/16/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"

@interface AddViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITextField *platformField,*productField,*capitalField,*minRateField,*maxRateField,*cal_typeField,*startimeField,*endtimeField;

    NSArray *platformArray,*productArray,*cal_typeArray;
    NSInteger currentTextTag;
    UIDatePicker *startTimePicker,*endTimePicker;
    UIAlertController *myAlert;
@public
    NSMutableArray *records;//用户所有的投资记录
//    NSMutableDictionary *untreatedDic;//各个平台对应的未处理投资
//    NSMutableDictionary *treatedDic;//各个平台对应的已处理过的投资
    NSObject<UIViewPassValueDelegate> *delegate;//在AddViewController中添加新的投资后，要刷新主页,流水界面的tableVIew和分析界面
}


@end
