//
//  FeedbackViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-14.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "FeedbackViewController.h"
#import "LeftSliderController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DejalActivityView.h"
#import "ALAlertBanner.h"


@interface FeedbackViewController ()
{
    CGFloat screen_width;
    CGFloat screen_height;
    BOOL flag1;//记录“建议”标签是否被点击
    BOOL flag2;
    BOOL flag3;
    int prewTag;
    float prewMoveY;
    int flag;
}
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    
    flag1 = FALSE;
    flag2 = FALSE;
    flag3 = FALSE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:)
name: UIKeyboardDidShowNotification object:nil];//接收到系统发出的消息UIKeyboardDidShowNotification时，就会调用keyboardDidShow方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];//接收到系统发出的消息UIKeyboardDidHideNotification时，就会调用keyboardDidHide方法
    
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:225.0/255.0 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//半透明
    //添加标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
    titleLabel.text = @"用户反馈";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.navigationItem.titleView = titleLabel;
    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //添加标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+10, 60, 15)];
    label.text = @"标签:";
    [self.view addSubview:label];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/4-25, 64+10+15, 50, 25)];
    [button1 setTitle:@"建议" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [button1 setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    button1.tag = 101;
    [button1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //给registerButton添加边框
    CALayer * buttonLayer1 = [button1 layer];
    [buttonLayer1 setMasksToBounds:YES];
    [buttonLayer1 setCornerRadius:5.0];
    [buttonLayer1 setBorderWidth:1.5];
    [buttonLayer1 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/2-25, 64+10+15, 50, 25)];
    [button2 setTitle:@"出错" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [button2 setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    button2.tag = 102;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //给registerButton添加边框
    CALayer * buttonLayer2 = [button2 layer];
    [buttonLayer2 setMasksToBounds:YES];
    [buttonLayer2 setCornerRadius:5.0];
    [buttonLayer2 setBorderWidth:1.5];
    [buttonLayer2 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/4*3-25, 64+10+15, 50, 25)];
    [button3 setTitle:@"帮助" forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:15];
    [button3 setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    button3.tag = 103;
    [button3 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    CALayer * buttonLayer3 = [button3 layer];
    [buttonLayer3 setMasksToBounds:YES];
    [buttonLayer3 setCornerRadius:5.0];
    [buttonLayer3 setBorderWidth:1.5];
    [buttonLayer3 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:button3];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//避免textView上面出现大段空白
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64+10+15+25+10, screen_width-20, screen_height/3.5)];
    myTextView.delegate = self;
    myTextView.scrollEnabled = YES;
    myTextView.text = @"感谢您对网贷篮子的支持，点此进行反馈...";
    myTextView.textColor = [UIColor grayColor];
    myTextView.font = [UIFont systemFontOfSize:14];
    myTextView.backgroundColor = [UIColor whiteColor];
    //设置圆边角
    myTextView.layer.borderColor = [UIColor grayColor].CGColor;
    myTextView.layer.borderWidth =1.0;
    myTextView.layer.cornerRadius =5.0;
    [self.view addSubview:myTextView];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screen_width, 30)];
//    [topView setBarStyle:UIBarStyleBlackTranslucent];
    [topView setBackgroundColor:[UIColor colorWithRed:201.0/255.0 green:205.0/255.0 blue:216.0/255.0 alpha:1]];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(1, 1, 28, 28);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [myTextView setInputAccessoryView:topView];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 124+screen_height/3.5+30, screen_width-20, 40)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:23];
    sendButton.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:74.0/255.0 blue:46.0/255.0 alpha:1];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    CALayer * buttonLayer4 = [sendButton layer];
//    [buttonLayer4 setMasksToBounds:YES];
//    [buttonLayer4 setCornerRadius:5.0];
//    [buttonLayer4 setBorderWidth:1.5];
//    [buttonLayer4 setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:sendButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}

#pragma mark -
#pragma mark ButtonPressedAction

- (void)backItemPressed
{
    NSLog(@"%@",myTextView.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonPressed:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 101:
            if (!flag1) {
                [button setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor]];
                flag1 = TRUE;
            }
            else {
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] CGColor]];
                flag1 = FALSE;
            }
            break;
        case 102:
            if (!flag2) {
                [button setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor]];
                flag2 = TRUE;
            }
            else {
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] CGColor]];
                flag2 = FALSE;
            }
            break;
        case 103:
            if (!flag3) {
                [button setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor]];
                flag3 = TRUE;
            }
            else {
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [button.layer setBorderColor:[[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] CGColor]];
                flag3 = FALSE;
            }
            break;
        default:
            break;
    }
}

- (void)dismissKeyBoard {
    [myTextView resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [myTextView resignFirstResponder];
}

- (void)sendButtonPressed {
    //服务器端字段：type content extra
    if (![myTextView.text isEqualToString:@""]) {
        LeftSliderController *leftSliderC = [LeftSliderController sharedViewController];
        if (leftSliderC->networkConnected) {//网络已连接
            UIView *viewToUse = self.view;
            [DejalBezelActivityView activityViewForView:viewToUse withLabel:@"发送中..." width:100];
            NSString *typeStr = @"建议";
            if (flag2) {
                typeStr = [NSString stringWithFormat:@"%@、出错",typeStr];
                
            }
            if (flag3) {
                typeStr = [NSString stringWithFormat:@"%@、帮助",typeStr];
            }
            NSString *contentStr = myTextView.text;
            NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
            //应用版本
            NSString *versionNum =[infoDict objectForKey:@"CFBundleVersion"];
            NSLog(@"应用版本：%@",versionNum);
            //设备名称
            NSString* deviceName = [[UIDevice currentDevice] systemName];
            NSLog(@"设备名称: %@",deviceName );
            //手机系统版本
            NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
            NSLog(@"手机系统版本: %@", phoneVersion);
            //手机型号
            NSString* phoneModel = [[UIDevice currentDevice] model];
            NSLog(@"手机型号: %@",phoneModel );
            //地方型号  （国际化区域名称）
            NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
            NSLog(@"国际化区域名称: %@",localPhoneModel);
            NSString *extraStr = [NSString stringWithFormat:@"应用版本：%@\n手机系统版本: %@\n手机型号: %@",versionNum,phoneVersion,phoneModel];
            NSLog(@"extraStr:%@",extraStr);
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //这个决定了下面responseObject返回的类型
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
            [manager POST:@"http://128.199.226.246/beerich/index.php/news/feedback"
               parameters:@{@"type":typeStr,@"content":contentStr,@"extra":extraStr}
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
                          else {
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
        
//        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
//        if (mailClass !=nil) {
//            if ([mailClass canSendMail]) {
//                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//                picker.mailComposeDelegate = self;
//                [picker setToRecipients:[NSArray arrayWithObjects:@"978717070@qq.com",
//                                         @"xuemochi@gmail.com", nil]];
//                NSMutableString *subjectString = [[NSMutableString alloc] initWithString:@"反馈："];
//                if (flag1) {
//                    [subjectString appendString:@" 建议 "];
//                }
//                if (flag2) {
//                    [subjectString appendString:@" 出错 "];
//                }
//                if (flag3) {
//                    [subjectString appendString:@" 帮助 "];
//                }
//                [picker setSubject:subjectString];
//                NSString *emailBody = myTextView.text;
//                [picker setMessageBody:emailBody isHTML:NO];
//                [self presentViewController:picker animated:YES completion:nil];
//            }
//            else{//设备不支持发动邮件功能
//                [self alertWithTitle:@"提示" msg:@"对不起，您还没有设置邮件账户！"];
//            }
//            
//        }
//        else {
//            [self alertWithTitle:@"提示" msg:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替！"];
//        }
    }
    else {//用户为输入反馈内容
        [self alertWithTitle:@"提示" msg:@"请输入反馈信息"];
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
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleNotify position:ALAlertBannerPositionTop title:@"发送成功！" subtitle:@"" tappedBlock:^(ALAlertBanner *alertBanner) {
                NSLog(@"tapped!");
                [alertBanner hide];
            }];
            banner.showAnimationDuration = 0.25;
            banner.hideAnimationDuration = 0.2;
            [banner show];
            break;
        }
        case 2:{//发送失败
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleFailure position:ALAlertBannerPositionTop title:@"发送失败！" subtitle:@"" tappedBlock:^(ALAlertBanner *alertBanner) {
                NSLog(@"tapped!");
                [alertBanner hide];
            }];
            banner.showAnimationDuration = 0.25;
            banner.hideAnimationDuration = 0.2;
            [banner show];
            break;
        }
        default:
            break;
    }
    return 0;
}

#pragma mark -
#pragma mark Notification

-(void) keyboardDidShow: (NSNotification *)notif {
    ////防止UITextView被键盘挡住
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    //防止UITextView被键盘挡住
    CGRect textFrame =  myTextView.frame;
    float textY = textFrame.origin.y+textFrame.size.height;
    float bottomY = self.view.frame.size.height-textY;
    if(bottomY>=keyboardSize.height)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
    {
        prewTag = -1;
        return;
    }
    prewTag = (int)myTextView.tag;
    float moveY = keyboardSize.height-bottomY;
    prewMoveY = moveY;
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=moveY;//view的Y轴上移
    frame.size.height +=moveY; //View的高度增加
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
    
}

-(void) keyboardDidHide: (NSNotification *)notif {
    /**
     结束编辑UITextView的方法，让原来的界面还原高度
     */
    if(prewTag == -1) //当编辑的View不是需要移动的View
    {
        return;
    }
    float moveY ;
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    if(prewTag == myTextView.tag) //当结束编辑的View的TAG是上次的就移动
    {   //还原界面
        moveY =  prewMoveY;
        frame.origin.y +=moveY;
        frame.size. height -=moveY;
        self.view.frame = frame;
    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [myTextView resignFirstResponder];
    
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

//- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
//    NSString *title = @"邮件发送提醒";
//    NSString *msg;
//    switch (result){
//        case MFMailComposeResultCancelled:
//            msg = @"邮件已被取消";
//            break;
//        case MFMailComposeResultSaved:
//            msg = @"邮件保存成功";
//            [self alertWithTitle:title msg:msg];
//            break;
//        case MFMailComposeResultSent:
//            msg = @"邮件发送成功";
//            [self alertWithTitle:title msg:msg];
//            break;
//        case MFMailComposeResultFailed:
//            msg =@"邮件发送失败";
//            [self alertWithTitle:title msg:msg];
//            break;
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}//邮箱关闭，MFMailComposeViewControllerDelegate协议要实现的方法

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
