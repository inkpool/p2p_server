//
//  AnalysisViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "AnalysisViewController.h"

@interface AnalysisViewController ()
{
    NSArray *pickerArray1;
    NSArray *pickerArray2;
    NSArray *platformName;
    NSInteger flag;
    float totalCapital;
}
@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flag = -1;//记录用户点击选择的扇区
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    [self initArray];
    
//    //显示当天年月日
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat : @"yyyy-MM-dd"];
//    NSString *nowDate = [formatter stringFromDate:[NSDate date]];
//    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+10, screen_width/2, 15)];
//    dateLabel.text = nowDate;
//    [self.view addSubview:dateLabel];

    
    
    
    //添加选择按钮
    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/3, screen_height/5*4+5, screen_width/3, 20)];
    chooseButton.tag = 101;
    [chooseButton setTitle:@"平台占比" forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:40.0/255.0 green:131.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [chooseButton addTarget:self action:@selector(chooseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseButton];
    
    //添加分割线、向下箭头
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, screen_height/5*4-5, screen_width, 2)];
    line1.image = [UIImage imageNamed:@"horiz_line"];
    [self.view addSubview:line1];
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, screen_height/5*4+35, screen_width, 2)];
    line2.image = [UIImage imageNamed:@"horiz_line"];
    [self.view addSubview:line2];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-60, screen_height/5*4+8, 25, 15)];
    arrow.image = [UIImage imageNamed:@"arrow"];
    [self.view addSubview:arrow];
    
    
    //*************************************显示饼状图*************************************************
    //创建画布
    self.graph = [[CPTXYGraph alloc]initWithFrame:self.view.bounds];
    //设置画布主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [self.graph applyTheme:theme];
    //画布与周围的距离
    self.graph.paddingBottom =10;
    self.graph.paddingLeft =5;
    self.graph.paddingRight =5;
    self.graph.paddingTop =10;
    //将画布的坐标轴设为空
    self.graph.axisSet =nil;
    
    //创建画板
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:CGRectMake(0, 60, screen_width, screen_width)];
    //设置画板的画布
    hostView.hostedGraph = self.graph;
    //设置画布标题的风格
    CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
    whiteText.color = [CPTColor blackColor];
    whiteText.fontSize =18;
    //whiteText.fontName =@"Helvetica-Bold";
    self.graph.titleTextStyle = whiteText;
    //self.graph.title = chooseButton.titleLabel.text;
    
    //创建饼图对象
    self.piePlot = [[CPTPieChart alloc]initWithFrame:hostView.frame];
    //设置数据源
    self.piePlot.dataSource =self;
    //设置饼图半径
    self.piePlot.pieRadius = screen_width/3.8;
    //设置饼图的空心半径
    self.piePlot.pieInnerRadius = screen_width/8;
    //设置饼图表示符
    self.piePlot.identifier =@"pie chart";
    //饼图开始绘制的位置
    self.piePlot.startAngle = M_PI_4;
    //饼图绘制的方向（顺时针/逆时针）
    self.piePlot.sliceDirection = CPTPieDirectionCounterClockwise;
    //饼图的重心
    self.piePlot.centerAnchor =CGPointMake(0.5,0.5);
    //设置饼图的阴影
    self.piePlot.shadowColor = [UIColor blackColor].CGColor;
    self.piePlot.shadowOffset = CGSizeMake(0.5, 0.5);
    self.piePlot.shadowOpacity = 0.3f;
    
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    self.piePlot.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    
    //设置文字顺着图形的方向
    self.piePlot.labelRotationRelativeToRadius = YES;//文字是否顺着图形的方向
    
    //饼图的线条风格
    //self.piePlot.borderLineStyle = [CPTLineStyle lineStyle];
    //设置代理
    self.piePlot.delegate =self;
    
    //将饼图加到画布上
    [self.graph addPlot:self.piePlot];
    
    //将画板加到视图上
    [self.view addSubview:hostView];

    //显示比例
    UILabel *proportionLable = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-30, 60+screen_width/2-10, 60, 20)];
    proportionLable.tag = 102;
    proportionLable.font = [UIFont systemFontOfSize:20];
    proportionLable.textColor = [UIColor colorWithRed:40.0/255.0 green:72.0/255.0 blue:95.0/255.0 alpha:1.0];
    proportionLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:proportionLable];

    
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
    
    platformName = [platformTotalCapital allKeys];
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

#pragma mark - CPTPlotDelegate
#pragma ===========================CPTPlotDelegate========================
//返回扇形数目
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [platformName count];
}
//返回每个扇形的比例
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    float num = [[platformTotalCapital valueForKey:platformName[idx]] floatValue];
    return [NSNumber numberWithFloat:num / totalCapital];
}
//凡返回每个扇形的标题
- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    CPTTextLayer *label = [[CPTTextLayer alloc]initWithText:[NSString stringWithFormat:@"%@",platformName[idx]]];
    CPTMutableTextStyle *text = [ label.textStyle mutableCopy];
    text.color = [CPTColor whiteColor];
    return label;
}

#pragma ===========CPTPieChart   Delegate========================
//选中某个扇形时的操作
- (void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx
{
    UILabel *proportionLable = (UILabel *)[self.view viewWithTag:102];
    float num = [[platformTotalCapital valueForKey:platformName[idx]] floatValue];
    proportionLable.text = [NSString stringWithFormat:@"%.1f%%",num/totalCapital*100];
    flag = idx;
    [plot reloadData];
}


//对于饼图，我们可以把某块扇形“切除”下来，以此突出该扇形区域。这需要实现数据源方法radialOffsetForPieChart:recordIndex: 方法。以下代码将饼图中第2块扇形“剥离”10个像素点
-(CGFloat)radialOffsetForPieChart:(CPTPieChart*)piePlot recordIndex:(NSUInteger)index{
    if (index == flag) {
        return 5;
    }
    return 0;
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
