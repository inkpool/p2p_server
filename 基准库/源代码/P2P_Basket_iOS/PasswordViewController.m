//
//  PasswordViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-19.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "PasswordViewController.h"
#import "LeftSliderController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DejalActivityView.h"

@interface PasswordViewController ()
{
    int flag;
}
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    titleLabel.text = @"密码设置";
    
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.navigationItem.titleView = titleLabel;
    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    
    //获取navigationbar 的高度
    CGFloat naviHeight=self.navigationController.navigationBar.frame.size.height;
    //计算Label宽高
    CGFloat labelHeight=(screen_height-naviHeight)/11;
    CGFloat labelWidth=screen_width/6;
    
    UILabel *emailLable = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/9, naviHeight+screen_width/10, labelWidth, labelHeight)];
    emailLable.textAlignment = NSTextAlignmentRight;
    emailLable.text=@"账号:\n";
    //    emailLable.backgroundColor = [UIColor blueColor];
    [self.view addSubview:emailLable];
    
    UILabel *oldPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/9-15, naviHeight+screen_width/10+labelHeight, labelWidth+15, labelHeight)];
    oldPasswordLabel.textAlignment = NSTextAlignmentRight;
    oldPasswordLabel.text=@"原密码:\n";
    [self.view addSubview:oldPasswordLabel];
    
    UILabel *newPasswordLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/9-15, naviHeight+screen_width/10+labelHeight+labelHeight, labelWidth+15, labelHeight)];
    newPasswordLabel1.textAlignment = NSTextAlignmentRight;
    newPasswordLabel1.text=@"新密码:\n";
    [self.view addSubview:newPasswordLabel1];
    
    UILabel *newPasswordLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/9-25, naviHeight+screen_width/10+labelHeight+labelHeight+labelHeight, labelWidth+25, labelHeight)];
    newPasswordLabel2.textAlignment = NSTextAlignmentRight;
    newPasswordLabel2.text=@"再输一遍:\n";
    [self.view addSubview:newPasswordLabel2];
    
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/9+labelWidth+5, naviHeight+screen_width/10, screen_width-labelWidth-screen_width/5, labelHeight)];
    emailLabel.text = @"xuxin@qq.com";
    [self.view addSubview:emailLabel];
    
    //放置textField
    oldPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(screen_width/9+labelWidth+5, naviHeight+screen_width/10+labelHeight+3, screen_width-labelWidth-screen_width/5, labelHeight-6)];
    oldPasswordField.tag = 101;
    oldPasswordField.placeholder=@"请输入原密码";
    oldPasswordField.borderStyle = UITextBorderStyleRoundedRect;
    oldPasswordField.backgroundColor = [UIColor whiteColor];
    oldPasswordField.delegate=self;
    oldPasswordField.returnKeyType=UIReturnKeyDone;
    oldPasswordField.secureTextEntry = YES;
    [oldPasswordField addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventEditingDidEndOnExit];//点击键盘Done键时，调用hideKeyBoard方法
    [self.view addSubview:oldPasswordField];
    
    newPasswordField1 = [[UITextField alloc]initWithFrame:CGRectMake(screen_width/9+labelWidth+5, naviHeight+screen_width/10+labelHeight+labelHeight+3, screen_width-labelWidth-screen_width/5, labelHeight-6)];
    newPasswordField1.placeholder=@"请输入新密码";
    newPasswordField1.borderStyle = UITextBorderStyleRoundedRect;
    newPasswordField1.backgroundColor = [UIColor whiteColor];
    newPasswordField1.delegate=self;
    newPasswordField1.returnKeyType=UIReturnKeyDone;
    newPasswordField1.secureTextEntry = YES;
    [newPasswordField1 addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventEditingDidEndOnExit];//点击键盘Done键时，调用hideKeyBoard方法
    [self.view addSubview:newPasswordField1];
    
    newPasswordField2 = [[UITextField alloc]initWithFrame:CGRectMake(screen_width/9+labelWidth+5, naviHeight+screen_width/10+labelHeight+labelHeight+labelHeight+3, screen_width-labelWidth-screen_width/5, labelHeight-6)];
    newPasswordField2.placeholder=@"请再次输入新密码";
    newPasswordField2.borderStyle = UITextBorderStyleRoundedRect;
    newPasswordField2.backgroundColor = [UIColor whiteColor];
    newPasswordField2.delegate=self;
    newPasswordField2.returnKeyType=UIReturnKeyDone;
    newPasswordField2.secureTextEntry = YES;
    [newPasswordField2 addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventEditingDidEndOnExit];//点击键盘Done键时，调用hideKeyBoard方法
    [self.view addSubview:newPasswordField2];
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/9+labelWidth+5, naviHeight+screen_width/10+labelHeight*4, screen_width-labelWidth-screen_width/5, labelHeight/3)];
    alertLabel.tag = 102;
    alertLabel.textColor = [UIColor redColor];
    alertLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:alertLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/2-50, naviHeight+screen_width/10+labelHeight*4+labelHeight/3+10, 100, 30)];
    [button setTitle:@"更新密码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    //给registerButton添加边框
    CALayer * buttonLayer = [button layer];
    [buttonLayer setMasksToBounds:YES];
    [buttonLayer setCornerRadius:5.0];
    [buttonLayer setBorderWidth:1.5];
    [buttonLayer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:button];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ButtonPressedAction

- (void)backItemPressed
{
    [self dismissViewControllerAnimated:YES  completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [oldPasswordField resignFirstResponder];
    [newPasswordField1 resignFirstResponder];
    [newPasswordField2 resignFirstResponder];
}

- (void)hideKeyBoard
{//点击键盘Done键时，调用该方法
    [oldPasswordField resignFirstResponder];
    [newPasswordField1 resignFirstResponder];
    [newPasswordField2 resignFirstResponder];
}

- (void)buttonPressed {
    if ([oldPasswordField.text isEqualToString:@""]) {
        [self alertWithTitle:@"提示" msg:@"请输入原密码"];
        return;
    }
    if ([newPasswordField1.text isEqualToString:@""]) {
        [self alertWithTitle:@"提示" msg:@"请输入新密码"];
        return;
    }
    if (![newPasswordField1.text isEqualToString:newPasswordField2.text]) {
        [self alertWithTitle:@"提示" msg:@"新密码输入不一致"];
        return;
    }
    LeftSliderController *leftSliderC = [LeftSliderController sharedViewController];
    if (leftSliderC->networkConnected) {//网络已连接
        UIView *viewToUse = self.view;
        [DejalBezelActivityView activityViewForView:viewToUse withLabel:@"更新中..." width:100];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //这个决定了下面responseObject返回的类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
        [manager POST:@"http://128.199.226.246/beerich/index.php/login/changePassword"
           parameters:@{@"user_name":loggedOnUser,@"old_password":oldPasswordField.text,@"new_password":newPasswordField1.text}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (!operation.responseString) {
                      flag = 0;
                      [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.8];
                  } else {
                      NSString *requestTmp = [NSString stringWithString:operation.responseString];
                      NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                      NSLog(@"%@,%@",[dic objectForKey:@"error_code"],[dic objectForKey:@"error_meesage"]);
                      if ([[dic objectForKey:@"error_code"] intValue] == 0) {
                          flag = 1;
                          [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.8];
                      }
                      else if ([[dic objectForKey:@"error_code"] intValue] == 2) {
                          flag = 2;
                          [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.8];
                      }
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error######: %@", error);
              }];
    }
    else {//网络未连接
        [self alertWithTitle:@"连接错误" msg:@"无法连接服务器，请检查您的网络连接是否正常"];
    }
}

- (int)removeActivityView
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    switch (flag) {
        case 0:
            [self alertWithTitle:@"连接异常" msg:@"网络连接异常"];
        case 1:{//发送成功
            [self alertWithTitle:@"更新成功" msg:@"密码修改成功"];
            break;
        }
        case 2:{//发送失败
            [self alertWithTitle:@"更新失败" msg:@"原密码输入错误"];
            break;
        }
        default:
            break;
    }
    return 0;
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//限制用户输入字符的个数
{
    int MAX_CHARS = 25;
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    return ([newtxt length] <= MAX_CHARS);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag != 101) {
        UILabel *alertLabel = (UILabel *)[self.view viewWithTag:102];
        if (![newPasswordField1.text isEqualToString:newPasswordField2.text]) {
            alertLabel.text = @"*新密码输入不一致";
        }
        else {
            alertLabel.text = @"";
        }
    }
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
