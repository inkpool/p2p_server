//
//  AnalysisViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "AnalysisViewController.h"
#import "Example2PieView.h"
#import "MyPieElement.h"
#import "PieLayer.h"

@interface AnalysisViewController ()
{
    NSArray *pickerArray1;
    NSArray *pickerArray2;
}
@property (nonatomic, weak) IBOutlet Example2PieView* pieView;
@end

@implementation AnalysisViewController
@synthesize pieView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    [self initArray];
    
    //显示当天年月日
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSString *nowDate = [formatter stringFromDate:[NSDate date]];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+10, screen_width/2, 15)];
    dateLabel.text = nowDate;
    
    pieView.frame = CGRectMake(5, 70, screen_width-10, screen_width-10);
    
    NSArray *keys = [platformTotalCapital allKeys];
    for (int i = 0; i < [platformTotalCapital count]; i++) {
        MyPieElement* elem = [MyPieElement pieElementWithValue:[[platformTotalCapital valueForKey:keys[i]] floatValue] color:[self randomColor]];
        NSString *titleText = [NSString stringWithFormat:@"%@", keys[i]];
        elem.title = titleText;
        [pieView.layer addValues:@[elem] animated:NO];
    }
    
    //mutch easier do this with array outside
    pieView.layer.transformTitleBlock = ^(PieElement* elem){
        return [(MyPieElement*)elem title];
    };
    pieView.layer.showTitles = ShowTitlesAlways;
    
    [self.view addSubview:pieView];
    [self.view addSubview:dateLabel];
    
    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/3, screen_height/5*4, screen_width/3, 20)];
    chooseButton.tag = 101;
    [chooseButton setTitle:@"平台占比" forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [chooseButton addTarget:self action:@selector(chooseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArray {
    pickerArray1 = [NSArray arrayWithObjects:@"平台占比",@"收益额占比",@"收益率占比",nil];
    pickerArray2 = [NSArray arrayWithObjects:@"1月内",@"半年内",@"1年内",@"全部",nil];
    
    totalCapital = 0.0;
    platformTotalCapital = [NSMutableDictionary dictionary];
    for (int i = 0; i < [records count]; i++) {
        id oneValue = [platformTotalCapital objectForKey:[records[i] objectForKey:@"platform"]];
        if (oneValue == nil) {
            totalCapital += [[records[i] objectForKey:@"capital"] floatValue];
            NSNumber *num = [records[i] objectForKey:@"capital"];
            [platformTotalCapital setObject:num forKey:[records[i] objectForKey:@"platform"]];
        }
        else {
            float num = [[records[i] objectForKey:@"capital"] floatValue];
            totalCapital +=  num;
            num += [[platformTotalCapital objectForKey:[records[i] objectForKey:@"platform"]] floatValue];
            [platformTotalCapital setObject:[NSNumber numberWithFloat:num] forKey:[records[i] objectForKey:@"platform"]];
        }
    }
}

- (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)chooseButtonPressed {
    myAlert=[UIAlertController alertControllerWithTitle:nil
                                                message:@"请选择\n\n\n\r\r\r\r\r\r\r"
                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIPickerView *pickView=[[UIPickerView alloc]initWithFrame:CGRectMake(-10, 0, 0, 0)];
    pickView.showsSelectionIndicator = YES;
    
    [myAlert.view addSubview:pickView];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
    }];
    
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        UIButton *chooseButton = (UIButton *)[self.view viewWithTag:101];
        [chooseButton setTitle:[pickerArray1 objectAtIndex:[pickView selectedRowInComponent:0]] forState:UIControlStateNormal];
    }];
    
    [myAlert addAction:cancelAction];
    [myAlert addAction:destructiveAction];
    
    pickView.delegate=self;
    
    [self presentViewController:myAlert animated:YES completion:nil];
}

#pragma mark - PickerView Delegate
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch(component)
    {
        case 0:return [pickerArray1 count];
        case 1:return [pickerArray2 count];
        default:return 0;
    }
    
}

//设置当前行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch(component)
    {
        case 0:return [pickerArray1 objectAtIndex:row];
        case 1:return [pickerArray2 objectAtIndex:row];
        default:return nil;
    }
}


@end
