//
//  RegisterViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-15.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginAndRegisterViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *emailField,*passwordField;
    NSDictionary *resultDic;
@public
    BOOL isLogin;
}
@end
