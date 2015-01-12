//
//  AddViewController.m
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/16/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import "AddViewController.h"
#import "platformDB.h"
#import "RecordDB.h"
#import "LeftSliderController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //navigationItem左按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    UIButton *item = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [item setTitle:@"返回" forState:UIControlStateNormal];
//    [item setFrame:CGRectMake(0, 0, 60, 35)];
//    [item addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:item];
//    self.navigationItem.leftBarButtonItem = rightItem;
    
    
    
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
    CGFloat labelWidth=(screen_width-screen_width/10)/3;
    
    
    UILabel *platformLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10, labelWidth, labelHeight)];
    //platformLabel.textAlignment=NSTextAlignmentCenter;
    platformLabel.text=@"投资平台\n";
    [self.view addSubview:platformLabel];
    
    UILabel *cateLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight, labelWidth, labelHeight)];
    cateLabel.text=@"投资类型\n";
    [self.view addSubview:cateLabel];
    
    UILabel *anualPercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/10, naviHeight+screen_width/10+labelHeight*2, labelWidth, labelHeight)];
    anualPercentLabel.text=@"年收益率\n";
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
    
    minRateField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10+labelHeight*2, labelWidth/3*2, labelHeight)];
    
    minRateField.tag=103;
    minRateField.placeholder=@"最低利率";
    minRateField.delegate=self;
    [self.view addSubview:minRateField];
    
    UILabel *minRateLabel=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth+labelWidth/3*2, naviHeight+screen_width/10+labelHeight*2, labelWidth/3, labelHeight)];
    minRateLabel.text=@"% ~";
    minRateLabel.tag=403;
    [self.view addSubview:minRateLabel];
    
    maxRateField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth*2, naviHeight+screen_width/10+labelHeight*2, labelWidth/3*2, labelHeight)];
    maxRateField.tag=104;
    maxRateField.placeholder=@"最高利率";
    maxRateField.delegate=self;
    [self.view addSubview:maxRateField];
    
    UILabel *maxRateLabel=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth*2+labelWidth/3*2, naviHeight+screen_width/10+labelHeight*2, labelWidth/3, labelHeight)];
    maxRateLabel.text=@"%";
    maxRateLabel.tag=404;
    [self.view addSubview:maxRateLabel];
    
    capitalField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10+labelHeight*3, labelWidth, labelHeight)];
    capitalField.tag=105;
    capitalField.placeholder=@"点击输入";
    capitalField.delegate=self;
    [self.view addSubview:capitalField];
    
    cal_typeField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10+labelHeight*4, labelWidth, labelHeight)];
    cal_typeField.tag=106;
    cal_typeField.placeholder=@"点击选择";
    cal_typeField.delegate=self;
    [self.view addSubview:cal_typeField];
    
    startimeField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10+labelHeight*5, labelWidth, labelHeight)];
    startimeField.tag=107;
    startimeField.placeholder=@"点击选择";
    startimeField.delegate=self;
    [self.view addSubview:startimeField];
    
    endtimeField=[[UITextField alloc]initWithFrame:CGRectMake(screen_width/10+labelWidth, naviHeight+screen_width/10+labelHeight*6, labelWidth, labelHeight)];
    endtimeField.tag=108;
    endtimeField.placeholder=@"点击选择";
    endtimeField.delegate=self;
    [self.view addSubview:endtimeField];
    
    
    
    
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
//    CGRect rect = [[UIScreen mainScreen] bounds];
//    CGSize size = rect.size;
//    CGFloat screen_width = size.width;
//    CGFloat screen_height = size.height;
    
    NSLog(@"textFieldShouldBeginEditing");
    
    myAlert=[UIAlertController alertControllerWithTitle:nil
                                                message:@"请选择\n\n\n\r\r\r\r\r\r\r"
                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIPickerView *pickView=[[UIPickerView alloc]initWithFrame:CGRectMake(-15, 0, 0, 0)];
    pickView.showsSelectionIndicator = YES;
    
    [myAlert.view addSubview:pickView];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
    }];
    
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        
        NSLog(@"The \"Okay/Cancel\" alert action sheet's destructive action occured.");
        switch (textField.tag) {
            case 101:
                textField.text=[platformArray objectAtIndex:[pickView selectedRowInComponent:0]];
                break;
            case 102:
            {
                textField.text=[productArray objectAtIndex:[pickView selectedRowInComponent:0]];
                platformDB *myPlatformDB = [[platformDB alloc]init];
                NSMutableArray *rateMutableArray=[myPlatformDB getRates:platformField.text secondPara:productField.text];
                NSArray *rateArray = [rateMutableArray copy];
                if([[rateArray objectAtIndex:0] isEqualToString:[rateArray objectAtIndex:1]])
                {
                    if([[rateArray objectAtIndex:0] isEqualToString:@"0.0"])
                    {
                        minRateField.text=@"";
                        minRateField.placeholder=@"请输入";
                    }
                    else
                    {
                        minRateField.text=[rateArray objectAtIndex:0];
                    }
                    
                    minRateField.textAlignment=NSTextAlignmentCenter;
                    [maxRateField removeFromSuperview];
                    UILabel *minLabel=(UILabel*)[self.view viewWithTag:403];
                    minLabel.text=@"%";
                    UILabel *maxLabel=(UILabel*)[self.view viewWithTag:404];
                    maxLabel.text=nil;
                }else{
                    [self.view addSubview:maxRateField];
                    minRateField.text=[rateArray objectAtIndex:0];
                    minRateField.textAlignment=NSTextAlignmentCenter;
                    maxRateField.text=[rateArray objectAtIndex:1];
                    maxRateField.textAlignment=NSTextAlignmentCenter;
                    UILabel *minLabel=(UILabel*)[self.view viewWithTag:403];
                    minLabel.text=@"%~";
                    UILabel *maxLabel=(UILabel*)[self.view viewWithTag:404];
                    maxLabel.text=@"%";
                }
                //自动填写开始时间和结束时间
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                NSDate *curDate = [NSDate date];//获取当前日期
                [formater setDateFormat:@"yyyy-MM-dd"];//这里去掉 具体时间 保留日期
                NSString * curTime = [formater stringFromDate:curDate];
                startimeField.text=curTime;
                
                //获取预设投资时间
                NSInteger duration=[[myPlatformDB getDuration:platformField.text secondPara:productField.text]intValue];
                
                NSCalendar *gregorian = [[NSCalendar alloc]
                                         initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setMonth:duration];
                // Calculate when, according to Tom Lehrer, World War III will end
                NSDate *endDate = [gregorian dateByAddingComponents:offsetComponents
                                                                    toDate:curDate options:0];
                endtimeField.text=[formater stringFromDate:endDate];
            }
            break;
            case 106:
            {
                textField.text=[cal_typeArray objectAtIndex:[pickView selectedRowInComponent:0]];
            }
            break;
            case 107:
            {
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy-MM-dd"];
                textField.text=[formater stringFromDate:startTimePicker.date];
            }
            break;
            case 108:
            {
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy-MM-dd"];
                textField.text=[formater stringFromDate:endTimePicker.date];
            }
            break;
            default:break;
        }

    }];
    
    [myAlert addAction:cancelAction];
    [myAlert addAction:destructiveAction];
    

    switch (textField.tag) {
        case 101:
        {
            NSLog(@"1111");
            pickView.tag=201;
            //查询数据，赋值pick数组
            platformDB *myPlatformDB = [[platformDB alloc]init];
            NSMutableArray *platformMutableArray=[myPlatformDB getField:@"platform"];
            platformArray = [platformMutableArray copy];
            pickView.delegate=self;
            [self presentViewController:myAlert animated:YES completion:nil];
        }
        break;
        case 102:
        {
            NSLog(@"textField值为%@",platformField.text);
            pickView.tag=202;
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
                [self presentViewController:myAlert animated:YES completion:nil];
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
        case 105:
        {
            textField.keyboardType=UIKeyboardTypeDecimalPad;
            return YES;
        }
        break;
        case 106:
        {
            cal_typeArray=[NSArray arrayWithObjects:@"到期还本息",@"按月还本息",@"按月只还息", nil];
            pickView.tag=206;
            pickView.delegate=self;
            [self presentViewController:myAlert animated:YES completion:nil];
            return NO;
        }
        break;
        case 107:
        {
            
            startTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0,0.0,0.0)];
            startTimePicker.datePickerMode=UIDatePickerModeDate;
            [myAlert.view addSubview:startTimePicker];
            [self presentViewController:myAlert animated:YES completion:nil];
            
            return NO;
            
        }
        break;
        case 108:
        {
            endTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0,0.0,0.0)];
            endTimePicker.datePickerMode=UIDatePickerModeDate;
            
            [myAlert.view addSubview:endTimePicker];
            [self presentViewController:myAlert animated:YES completion:nil];
            return NO;
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
    
    UIView *currentView=[self.view viewWithTag:currentTextTag];
    [currentView resignFirstResponder];
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
        case 206:return [cal_typeArray count];
        default:return 0;
    }
    
}

//设置当前行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch(pickerView.tag)
    {
        case 201:return [platformArray objectAtIndex:row];
        case 202:return [productArray objectAtIndex:row];
        case 206:return [cal_typeArray objectAtIndex:row];
        default:return nil;
    }
}

#pragma mark - Button Pressed

-(void)confirmPressed{
    LeftSliderController *leftSliderC = [LeftSliderController sharedViewController];
    RecordDB *myRecordDB = [[RecordDB alloc]init];
    if ([maxRateField.text floatValue] != 0) {
        [myRecordDB insertRecord:platformField.text secondPara:productField.text thirdPara:[capitalField.text floatValue] forthPara:[minRateField.text floatValue] fifthPara:[maxRateField.text floatValue] sixthPara:cal_typeField.text seventhPara:startimeField.text eighthPara:endtimeField.text ninthPara:leftSliderC->loggedOnUser];
    }
    else {
        [myRecordDB insertRecord:platformField.text secondPara:productField.text thirdPara:[capitalField.text floatValue] forthPara:0.0 fifthPara:[minRateField.text floatValue] sixthPara:cal_typeField.text seventhPara:startimeField.text eighthPara:endtimeField.text ninthPara:leftSliderC->loggedOnUser];
    }
    [delegate refresh1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
