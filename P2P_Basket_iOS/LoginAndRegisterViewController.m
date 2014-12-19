//
//  RegisterViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-15.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface LoginAndRegisterViewController ()
{
    NSString *userEmail;
    NSString *userPassword;
}

@end

@implementation LoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    if (isLogin) {
        titleLabel.text = @"账号登录";
    } else {
        titleLabel.text = @"账号注册";
    }
    
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
    
    UILabel *emailLable = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10, labelWidth, labelHeight)];
    emailLable.text=@"账号：\n";
//    emailLable.backgroundColor = [UIColor blueColor];
    [self.view addSubview:emailLable];
    
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight, labelWidth, labelHeight)];
    passwordLabel.text=@"密码：\n";
    [self.view addSubview:passwordLabel];
    
    //放置textField
    emailField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10+3, screen_width-labelWidth-screen_width/5, labelHeight-6)];
    emailField.backgroundColor = [UIColor whiteColor];
    emailField.borderStyle = UITextBorderStyleRoundedRect;
    emailField.placeholder=@"请输入您的邮箱";
    emailField.tag=101;
    emailField.delegate=self;
    emailField.returnKeyType=UIReturnKeyDone;
    [emailField addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventEditingDidEndOnExit];//点击键盘Done键时，调用hideKeyBoard方法
    [self.view addSubview:emailField];
    
    //放置textField
    passwordField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10+labelHeight+3, screen_width-labelWidth-screen_width/5, labelHeight-6)];
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.placeholder=@"请输入密码";
    passwordField.tag=102;
    passwordField.delegate=self;
    passwordField.returnKeyType=UIReturnKeyDone;
    passwordField.secureTextEntry = YES;
    [passwordField addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventEditingDidEndOnExit];//点击键盘Done键时，调用hideKeyBoard方法

    [self.view addSubview:passwordField];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/2-40, naviHeight+screen_width/10+labelHeight+labelHeight+20, 80, 30)];
    if (isLogin) {
        [button setTitle:@"登录" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"注册" forState:UIControlStateNormal];
    }
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
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)hideKeyBoard
{//点击键盘Done键时，调用该方法
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)buttonPressed {
    userEmail = emailField.text;
    if ([self isValidateEmail:userEmail]) {//用户输入的邮箱合法
        userPassword = passwordField.text;
        NSLog(@"%@,%@",userEmail,userPassword);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
        if (isLogin) {//登录
            [manager POST:@"http://128.199.226.246/beerich/index.php/login"
               parameters:@{@"user_name":userEmail,@"password":userPassword}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"JSON#######: %@", responseObject);
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error######: %@", error);
                  }];
        }
        else {//注册
            [manager POST:@"http://128.199.226.246/beerich/index.php/login/register"
               parameters:@{@"user_name":userEmail,@"password":userPassword}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"JSON#######: %@", responseObject);
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error######: %@", error);
                  }];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入正确格式的邮箱"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

- (BOOL)  isValidateEmail: (NSString *)candidate {
    //判断用户输入的邮箱是否合法
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
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

@end
