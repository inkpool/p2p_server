//
//  PasswordViewController.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-19.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *oldPasswordField,*newPasswordField1,*newPasswordField2;
}
@end
