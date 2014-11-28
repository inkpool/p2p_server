//
//  AddViewController.m
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/16/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import "AddViewController.h"
#import "platformDB.h"

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
    
    //全局按钮，用来关闭键盘
    UIButton *windowButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    [windowButton addTarget:self action:@selector(DoneEditing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:windowButton];
    
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
    
    UILabel *anualPercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight*2, labelWidth, labelHeight)];
    anualPercentLabel.text=@"年化收益率\n";
    [self.view addSubview:anualPercentLabel];
    
    UILabel *principalLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight*3, labelWidth, labelHeight)];
    principalLabel.text=@"本金数量\n";
    [self.view addSubview:principalLabel];
    
    
    
    
    
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
    platformField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10, labelWidth, labelHeight)];
    platformField.placeholder=@"点击选择";
    //tag值为101，以后textField为100+N递增
    //pickerView为200+N递增
    platformField.tag=101;
    platformField.delegate=self;
    [self.view addSubview:platformField];
    
    //放置textField
    productField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10+labelHeight, labelWidth, labelHeight)];
    productField.placeholder=@"点击选择";
    //tag值为101，以后textField为100+N递增
    //pickerView为200+N递增
    productField.tag=102;
    productField.delegate=self;
    [self.view addSubview:productField];
    
     minRateField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10+labelHeight*2, labelWidth, labelHeight)];
    minRateField.tag=103;
    minRateField.placeholder=@"最低利率";
    minRateField.delegate=self;
    [self.view addSubview:minRateField];
    
     maxRateField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth*2, naviHeight+screen_width/10+labelHeight*2, labelWidth, labelHeight)];
    maxRateField.tag=104;
    maxRateField.placeholder=@"最高利率";
    maxRateField.delegate=self;
    [self.view addSubview:maxRateField];
    
    
    
    
    
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


#pragma mark - TextField Delegate
//点击textField之后的处理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextTag=textField.tag;
    //NSLog(@"current %ld",currentTextTag);
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    
    NSLog(@"textFieldShouldBeginEditing");
    
    UIPickerView *pickView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, screen_height*0.8, screen_width, screen_height*0.2)];
    pickView.backgroundColor=[UIColor grayColor];
    pickView.showsSelectionIndicator = YES;
    
    
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, screen_height*0.8, screen_width,30)];
    toolBar.backgroundColor=[UIColor greenColor];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.tag=888;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target: self action: @selector(donePressed:)];
    
    UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target: self action: @selector(newPressed:)];

    switch (textField.tag) {
        case 101:
        {
            NSLog(@"1111");
            pickView.tag=201;
            rightButton.tag=301;
            leftButton.tag=301;
            //查询数据，赋值pick数组
            platformDB *myPlatformDB = [[platformDB alloc]init];
            NSMutableArray *platformMutableArray=[myPlatformDB getField:@"platform"];
            platformArray = [platformMutableArray copy];
            pickView.delegate=self;
            [self.view addSubview:pickView];
            UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            NSArray *toolbarItems = [NSArray arrayWithObjects:leftButton,spaceItem, rightButton, nil];
            [toolBar setItems:toolbarItems];
            [self.view addSubview:toolBar];

        }
        break;
        case 102:
        {
            NSLog(@"textField值为%@",platformField.text);
            pickView.tag=202;
            rightButton.tag=302;
            leftButton.tag=302;
            if(platformField.text.length==0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请先选择平台。"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
            else{
                platformDB *myPlatformDB = [[platformDB alloc]init];
                NSMutableArray *productMutableArray=[myPlatformDB getProductFromOnePlatform:platformField.text];
                productArray = [productMutableArray copy];
                pickView.delegate=self;
                [self.view addSubview:pickView];
                UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                NSArray *toolbarItems = [NSArray arrayWithObjects:leftButton,spaceItem, rightButton, nil];
                [toolBar setItems:toolbarItems];
                [self.view addSubview:toolBar];
            }
        }
        break;
        case 103:
        {
            if(productField.text.length==0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请先填写产品。"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                return NO;
            }
            textField.keyboardType=UIKeyboardTypeDecimalPad;
            return YES;
        }
        break;
        case 104:
        {
            textField.keyboardType=UIKeyboardTypeDecimalPad;
            return YES;
        }
        break;
            
        default:NSLog(@"2222");break;
    }
    
    return NO;
    // [textField becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSLog(@"textFieldDidEndEditing : %@", textField.text);
    

}

-(void)DoneEditing
{
    NSLog(@"textFieldDoen.....");
    
    UITextField *currentTextField=(UITextField *)[self.view viewWithTag:currentTextTag];
    [currentTextField resignFirstResponder];
}

#pragma mark - PickerView Delegate
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch(pickerView.tag)
    {
        case 201:return [platformArray count];
        case 202:return [productArray count];
        default:return 0;
    }
    
}

//设置当前行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch(pickerView.tag)
    {
        case 201:return [platformArray objectAtIndex:row];
        case 202:return [productArray objectAtIndex:row];
        default:return nil;
    }
}

#pragma mark - Button Pressed

-(void)addPressed:(id)sender{
    NSInteger i = [sender tag];
    UIPickerView *pickerView=(UIPickerView*)[self.view viewWithTag:i-100];
    NSInteger row =[pickerView selectedRowInComponent:0];
    NSString *selected = [platformArray objectAtIndex:row];
    UITextField *intoTextField=(UITextField*)[self.view viewWithTag:101];
    intoTextField.text=selected;
    [pickerView removeFromSuperview];
}

-(void)donePressed:(id)sender{
    NSLog(@"Done pressed.");
    NSInteger i = [sender tag]; //30x是按钮的tag
    UIPickerView *pickerView=(UIPickerView*)[self.view viewWithTag:i-100];
    NSInteger row =[pickerView selectedRowInComponent:0];
    if(i==(long)301)
    {
        NSString *selected = [platformArray objectAtIndex:row];
        UITextField *intoTextField=(UITextField*)[self.view viewWithTag:i-200];
        intoTextField.text=selected;
    }
    
    if(i==(long)302)
    {
        NSString *selected = [productArray objectAtIndex:row];
        UITextField *intoTextField=(UITextField*)[self.view viewWithTag:i-200];
        intoTextField.text=selected;
        
        platformDB *myPlatformDB = [[platformDB alloc]init];
        NSMutableArray *rateMutableArray=[myPlatformDB getRates:platformField.text secondPara:productField.text];
        NSArray *rateArray = [rateMutableArray copy];
        if([[rateArray objectAtIndex:0] isEqualToString:[rateArray objectAtIndex:1]])
        {
            minRateField.text=[rateArray objectAtIndex:0];
        }else{
            minRateField.text=[rateArray objectAtIndex:0];
            maxRateField.text=[rateArray objectAtIndex:1];
        }
        
        NSLog(@"min%@,max%@",[rateArray objectAtIndex:0],[rateArray objectAtIndex:1]);

    }
    
    
    
    //获得toolbar
    UIToolbar *toolBar=(UIToolbar*)[self.view viewWithTag:888];
    
    //完成功能，消除pickerView和toolbar
    [pickerView removeFromSuperview];
    [toolBar removeFromSuperview];
    
    
}

-(void)newPressed:(id)sender{
    NSLog(@"New pressed.");
    
}


-(void)confirmPressed{

}

-(void)cancelPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
