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
    NSObject<UIViewPassValueDelegate> *delegate;//在AddViewController中添加新的投资后，要刷新主页和流水界面的tableVIew
}


@end
