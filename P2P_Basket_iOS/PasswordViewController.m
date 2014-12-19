//
//  PasswordViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-19.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

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
        [self alertWithTitle:@"请输入原密码"];
        return;
    }
    if ([newPasswordField1.text isEqualToString:@""]) {
        [self alertWithTitle:@"请输入新密码"];
        return;
    }
    if (![newPasswordField1.text isEqualToString:newPasswordField2.text]) {
        [self alertWithTitle:@"新密码输入不一致"];
        return;
    }
//    userEmail = emailField.text;
//    if ([self isValidateEmail:userEmail]) {//用户输入的邮箱合法
//        userPassword = passwordField.text;
//        NSLog(@"%@,%@",userEmail,userPassword);
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
//        if (isLogin) {//登录
//            [manager POST:@"http://128.199.226.246/beerich/index.php/login"
//               parameters:@{@"user_name":userEmail,@"password":userPassword}
//                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                      NSLog(@"JSON#######: %@", responseObject);
//                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                      NSLog(@"Error######: %@", error);
//                  }];
//        }
//        else {//注册
//            [manager POST:@"http://128.199.226.246/beerich/index.php/login/register"
//               parameters:@{@"user_name":userEmail,@"password":userPassword}
//                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                      NSLog(@"JSON#######: %@", responseObject);
//                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                      NSLog(@"Error######: %@", error);
//                  }];
//        }
//    }
//    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"请输入正确格式的邮箱"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
//        [alert show];
//    }
    
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

- (void) alertWithTitle:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
