//
//  AddViewController.m
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/16/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    UIButton *item = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [item setTitle:@"返回" forState:UIControlStateNormal];
    [item setFrame:CGRectMake(0, 0, 60, 35)];
    [item addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    self.navigationItem.leftBarButtonItem = rightItem;
    
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    baseView.backgroundColor = [UIColor whiteColor];
    self.view = baseView;

    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    
    //获取navigationbar 的高度
    CGFloat naviHeight=self.navigationController.navigationBar.frame.size.height;
    
    //计算Label宽高
    CGFloat labelHeight=(screen_height-naviHeight)/11;
    CGFloat labelWidth=screen_width/3;
    
    
    UILabel *platformLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10, labelWidth, labelHeight)];
    //platformLabel.textAlignment=NSTextAlignmentCenter;
    platformLabel.text=@"投资平台\n";
    [self.view addSubview:platformLabel];
    
    UILabel *cateLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight, labelWidth, labelHeight)];
    cateLabel.text=@"投资类型\n";
    [self.view addSubview:cateLabel];
    
    UILabel *principalLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight*2, labelWidth, labelHeight)];
    principalLabel.text=@"本金数量\n";
    [self.view addSubview:principalLabel];
    
    UILabel *anualPercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight*3, labelWidth, labelHeight)];
    anualPercentLabel.text=@"年化收益率\n";
    [self.view addSubview:anualPercentLabel];
    
    UILabel *methodLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight*4, labelWidth, labelHeight)];
    methodLabel.text=@"计息方式\n";
    [self.view addSubview:methodLabel];
    
    UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight*5, labelWidth, labelHeight)];
    startLabel.text=@"计息时间\n";
    [self.view addSubview:startLabel];
    
    UILabel *endLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight*6, labelWidth, labelHeight)];
    endLabel.text=@"到期时间\n";
    [self.view addSubview:endLabel];
    
    //放置textField
    UIPickerView *platformPick=[[UIPickerView alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10, labelWidth, labelHeight)];
    UITextField *platformField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10, labelWidth, labelHeight)];
    platformField.placeholder=@"点击选择";
    [platformField setInputView:platformPick];
    platformField.inputAccessoryView=self.toolbarItems;
    [self.view addSubview:platformField];
    
    
    
    
    
    
    //放置按钮
    CGFloat buttonWidth=screen_width/2;
    CGFloat buttonHeight=buttonWidth/16*5;
    
    UIButton *confrimButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confrimButton setTitle:@"确认" forState:UIControlStateNormal];
    [confrimButton setFrame:CGRectMake(0, screen_height-buttonHeight, screen_width, buttonHeight)];
    [confrimButton addTarget:self action:@selector(confirmPressed) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:confrimButton];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)confirmPressed{

}

-(void)cancelPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
