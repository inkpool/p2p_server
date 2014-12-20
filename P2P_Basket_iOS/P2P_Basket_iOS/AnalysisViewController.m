//
//  AnalysisViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "AnalysisViewController.h"

#define RCloseDuration 0.3f
#define ROpenDuration 0.4f
#define RContentScale 0.85f
#define RJudgeOffset 100.0f

@interface AnalysisViewController ()
{
    NSArray *pickerArray1;
    NSArray *pickerArray2;
    NSArray *pickerArray3;
    NSArray *buttonTitleArray;
    NSInteger flag1;
    NSInteger flag2;
    NSMutableArray *colorArray;
    float totalCapital;
    float maxCapital;
    NSInteger index1;
    NSInteger index2;
    UIPanGestureRecognizer *_panGestureRec;
    UIView *myContentView;
    float RContentOffset;
}
@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flag1 = -1;//记录用户点击选择的扇区
    flag2 = 0;//饼图刷新时不再变换颜色
    index1 = 0;//记录用户的选择（投资额，收益额），默认为0
    index2 = 0;//记录用户的选择(全部，1年内，半年内，1月内)，默认为0
    index3 = 0;//记录用户的选择(饼状图，柱状图)，默认为0
    colorArray = [[NSMutableArray alloc] init];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    [self initArray1];
    [self initArray2];
    RContentOffset = screen_width/3*2;
    //重新规定响应拖动事件的范围
    myContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 60+screen_width, screen_width, screen_height-screen_width-60)];
    [self.view addSubview:myContentView];
    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [myContentView addGestureRecognizer:_panGestureRec];//只有_mainContentView响应手指滑动事件，_mainContentView滑动时，_leftSideView会露出一部分（此时_leftSideView未被_mainContentView完全覆盖）
//    //显示当天年月日
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat : @"yyyy-MM-dd"];
//    NSString *nowDate = [formatter stringFromDate:[NSDate date]];
//    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+10, screen_width/2, 15)];
//    dateLabel.text = nowDate;
//    [self.view addSubview:dateLabel];
 
    //添加选择按钮
    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, screen_height/5*4+5, screen_width, 20)];
    chooseButton.tag = 101;
    [chooseButton setTitle:buttonTitleArray[0] forState:UIControlStateNormal];
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
    
    //创建画板
    self.hostView = [[CPTGraphHostingView alloc]initWithFrame:CGRectMake(0, 60, screen_width, screen_width)];
    
    //创建画布
    self.graph = [[CPTXYGraph alloc]initWithFrame:self.hostView.frame];
    //设置画布主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [self.graph applyTheme:theme];
    //画布与周围的距离
    self.graph.paddingBottom =10;
    self.graph.paddingLeft =5;
    self.graph.paddingRight =5;
    self.graph.paddingTop =10;
    //将画布的坐标轴设为空
    self.graph.axisSet.hidden = YES;
    
    //设置画板的画布
    self.hostView.hostedGraph = self.graph;
//    //设置画布标题的风格
//    CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
//    whiteText.color = [CPTColor blackColor];
//    whiteText.fontSize =18;
//    //whiteText.fontName =@"Helvetica-Bold";
//    self.graph.titleTextStyle = whiteText;
    //将画板加到视图上
    [self.view addSubview:self.hostView];
    //self.graph.title = chooseButton.titleLabel.text;
    
    //*************************************饼状图*************************************************
    //创建饼图对象
    piePlot = [[CPTPieChart alloc]initWithFrame:self.hostView.frame];
    //设置数据源
    piePlot.dataSource =self;
    //设置饼图半径
    piePlot.pieRadius = screen_width/3.8;
    //设置饼图的空心半径
    piePlot.pieInnerRadius = screen_width/8;
    //设置饼图表示符
    piePlot.identifier =@"pie chart";
    //饼图开始绘制的位置
    piePlot.startAngle = M_PI_4;
    //饼图绘制的方向（顺时针/逆时针）
    piePlot.sliceDirection = CPTPieDirectionCounterClockwise;
    //饼图的重心
    piePlot.centerAnchor =CGPointMake(0.5,0.5);
//    //设置饼图的阴影
//    self.piePlot.shadowColor = [UIColor blackColor].CGColor;
//    self.piePlot.shadowOffset = CGSizeMake(0.5, 0.5);
//    self.piePlot.shadowOpacity = 0.3f;
//    
//    // 3 - Create gradient
//    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
//    overlayGradient.gradientType = CPTGradientTypeRadial;
//    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
//    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
//    self.piePlot.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    //设置文字顺着图形的方向
    piePlot.labelRotationRelativeToRadius = YES;//文字是否顺着图形的方向
    //饼图的线条风格
    //self.piePlot.borderLineStyle = [CPTLineStyle lineStyle];
    //设置代理
    piePlot.delegate =self;
    //将饼图加到画布上
    [self.graph addPlot:piePlot];

    //显示比例
    UILabel *proportionLable = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-30, 60+screen_width/2-10, 60, 20)];
    proportionLable.tag = 102;
    proportionLable.font = [UIFont systemFontOfSize:20];
    proportionLable.textColor = [UIColor colorWithRed:40.0/255.0 green:72.0/255.0 blue:95.0/255.0 alpha:1.0];
    proportionLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:proportionLable];

    //****************************柱状图**************************************************
    // set up the plots
    barPlot=[CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:arc4random()%255/255.0  green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1] horizontalBars:NO];
    // set up line style
    CPTMutableLineStyle *barLineStyle=[[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor=[CPTColor blackColor];
    barLineStyle.lineWidth=1.0;
    // set up text style
    CPTMutableTextStyle *textLineStyle=[CPTMutableTextStyle textStyle];
    textLineStyle.color=[CPTColor blackColor];
    // 绘图空间 plot space
    self.plotSpace=(CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    // 绘图空间大小： Y ： 0-maxCapital ， x ： 0-[platformName count]
    self.plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([platformName count])];
    self.plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-130000.0f) length:CPTDecimalFromFloat(maxCapital+230000)];//这里设置成-130000到maxCapital+230000是为了显示x轴的label
    self.plotSpace.allowsUserInteraction = NO;
    
    // add plots to graph
    barPlot.dataSource=self;
    barPlot.delegate=self;  // 如果不需要柱状图的选择，这条语句是没必要的
//    self.barPlot.baseValue=CPTDecimalFromInt(0); // 设定基值，大于该值的从此点向上画，小于该值的反向绘制，即向下画
    barPlot.barWidth=CPTDecimalFromDouble(0.5); // 设定柱图的宽度(0.0~1.0)
    barPlot.barOffset=CPTDecimalFromDouble(0.5); // 柱图每个柱子开始绘制的偏移位置，我们让它绘制在刻度线中间，所以不偏移
    barPlot.lineStyle=barLineStyle;
    
    // 坐标系
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)self.graph.axisSet;
    // xAxis
    xAxis=axisSet.xAxis;
    CPTMutableLineStyle *xLineStyle=[[CPTMutableLineStyle alloc] init];
    xLineStyle.lineColor=[CPTColor blackColor];
    xLineStyle.lineWidth=1.0f;
    xAxis.axisLineStyle=xLineStyle;//x 轴：线型设置
    xAxis.labelingPolicy=CPTAxisLabelingPolicyNone;
    xAxis.axisConstraints=[CPTConstraints constraintWithLowerOffset:-0.0];//开始时不显示x轴的label
    xAxis.majorTickLineStyle=xLineStyle; //X轴大刻度线，线型设置
    xAxis.majorTickLength=[platformName count];  // 刻度线的长度
    xAxis.majorIntervalLength=CPTDecimalFromInt(1); // 间隔单位,和xMin~xMax对应
    // 小刻度线minor...
    xAxis.minorTickLineStyle=nil;
    xAxis.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
//    xAxis.title = @"平台" ;
    
    // yAxis
    CPTXYAxis *yAxis=axisSet.yAxis;
    yAxis.axisLineStyle=xLineStyle;
    yAxis.majorTickLineStyle=xLineStyle; //X轴大刻度线，线型设置
    yAxis.majorTickLength=maxCapital/50000;  // 刻度线的长度
    yAxis.majorIntervalLength=CPTDecimalFromInt(50000); // 间隔单位，和yMin～yMax对应
    // 小刻度线minor...
    yAxis.minorTickLineStyle=nil;  //  不显示小刻度线
    yAxis.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    
    // 设置X轴label
    NSMutableArray *labelArray = [NSMutableArray arrayWithCapacity:[platformName count]];
    float labelLocation = 0.5;
    for(NSString *label in platformName){
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:label textStyle:xAxis.labelTextStyle];
        newLabel.tickLocation = [[NSNumber numberWithFloat:labelLocation] decimalValue];
        newLabel.offset = xAxis.labelOffset+xAxis.majorTickLength;
        newLabel.rotation = M_PI/6;
        [labelArray addObject:newLabel];
        labelLocation += 1;
    }
    xAxis.axisLabels=[NSSet setWithArray:labelArray];
    [self.graph addPlot:barPlot];
    barPlot.hidden = YES;//初始显示饼状图，隐藏柱状图
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArray1 {
    pickerArray1 = [NSArray arrayWithObjects:@"投资额",@"收益额",nil];
    pickerArray2 = [NSArray arrayWithObjects:@"全部",@"1年内",@"半年内",@"1月内",nil];
    pickerArray3 = [NSArray arrayWithObjects:@"饼状图",@"柱状图",nil];
    buttonTitleArray = [NSArray arrayWithObjects:@"投资额饼状图(全部)",@"投资额饼状图(1年内)",
                        @"投资额饼状图(半年内)",@"投资额饼状图(1月内)",@"投资额柱状图(全部)",
                        @"投资额柱状图(1年内)",@"投资额柱状图(半年内)",@"投资额柱状图(1月内)",
                        
                        @"收益额饼状图(全部)",@"收益额饼状图(1年内)",@"收益额饼状图(半年内)",
                        @"收益额饼状图(1月内)",@"收益额柱状图(全部)",@"收益额柱状图(1年内)",
                        @"收益额柱状图(半年内)",@"收益额柱状图(1月内)",nil];
}

- (void)initArray2 {
    
    totalCapital = 0.0;
    maxCapital = 0.0;
    [platformTotalCapital removeAllObjects];
    platformTotalCapital = [NSMutableDictionary dictionary];
    long int timeStamp = [[NSDate date] timeIntervalSince1970];
    if (index2 == 0) {//全部
        timeStamp = 0;
    } else if (index2 == 1) {//1年内
        timeStamp -= 365*24*60*60;
    } else if (index2 == 2) {//半年内
        timeStamp -= 365*24*60*60/2;
    } else {//1月内
        timeStamp -= 30*24*60*60;
    }
    if (index1 == 0) {//投资额
        for (int i = 0; i < [records count]; i++) {
            //暂时以用户记录的时间（时间戳）为基准
            if ([[records[i] objectForKey:@"timeStamp"] intValue] >= timeStamp) {
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
            
        }//end for
    }
    else {//计算收益额
        for (int i = 0; i < [records count]; i++) {
            //暂时以用户记录的时间（时间戳）为基准
            if ([[records[i] objectForKey:@"timeStamp"] intValue] >= timeStamp) {
                if ([[records[i] objectForKey:@"state"] intValue] == 1) {//投资已处理，可计算收益
                    id oneValue = [platformTotalCapital objectForKey:[records[i] objectForKey:@"platform"]];
                    if (oneValue == nil) {
                        float num = [[records[i] objectForKey:@"capital"] floatValue]*[[records[i] objectForKey:@"minRate"] floatValue]/100;
                        totalCapital += num;
                        [platformTotalCapital setObject:[NSNumber numberWithFloat:num] forKey:[records[i] objectForKey:@"platform"]];
                    }
                    else {
                        float num = [[records[i] objectForKey:@"capital"] floatValue]*[[records[i] objectForKey:@"minRate"] floatValue]/100;
                        totalCapital +=  num;
                        num += [[platformTotalCapital objectForKey:[records[i] objectForKey:@"platform"]] floatValue];
                        [platformTotalCapital setObject:[NSNumber numberWithFloat:num] forKey:[records[i] objectForKey:@"platform"]];
                    }
                }
            }
        }//end for
    }
    platformName = [platformTotalCapital allKeys];
    for (int i = 0; i < [platformName count]; i++) {
        float num = [[platformTotalCapital objectForKey:platformName[i]] floatValue];
        if (maxCapital < num) {
            maxCapital = num;
        }
    }
}

- (void)chooseButtonPressed {
    myAlert=[UIAlertController alertControllerWithTitle:nil
                                                message:@"请选择\n\n\n\r\r\r\r\r\r\r"
                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIPickerView *pickView=[[UIPickerView alloc]initWithFrame:CGRectMake(-10, 0, 0, 0)];
    pickView.showsSelectionIndicator = YES;
    
    [myAlert.view addSubview:pickView];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        UIButton *chooseButton = (UIButton *)[self.view viewWithTag:101];
        index1 = [pickView selectedRowInComponent:0];//（投资额，收益额）
        index3 = [pickView selectedRowInComponent:2];//(饼状图，柱状图)
        index2 = [pickView selectedRowInComponent:1];//(全部，1年内，半年内，1月内)
        [chooseButton setTitle:[buttonTitleArray objectAtIndex:index1*8+index3*4+index2] forState:UIControlStateNormal];
        if (index3 == 0) {//饼状图
            UILabel *proportionLable = (UILabel *)[self.view viewWithTag:102];
            piePlot.hidden = NO;
            proportionLable.hidden = NO;
            barPlot.hidden = YES;
            self.graph.axisSet.hidden = YES;
            self.plotSpace.allowsUserInteraction = NO;
            xAxis.axisConstraints=[CPTConstraints constraintWithLowerOffset:-0.0];//不显示x轴的label
            [self initArray2];
            [piePlot reloadData];
        }
        else {//柱状图
            UILabel *proportionLable = (UILabel *)[self.view viewWithTag:102];
            proportionLable.hidden = YES;
            piePlot.hidden = YES;
            barPlot.hidden = NO;
            self.graph.axisSet.hidden = NO;
            self.plotSpace.allowsUserInteraction = YES;
            xAxis.axisConstraints = nil;//显示x轴label
            [self initArray2];
            // 重新显示X轴label
            NSMutableArray *labelArray = [NSMutableArray arrayWithCapacity:[platformName count]];
            float labelLocation = 0.5;
            for(NSString *label in platformName){
                CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:label textStyle:xAxis.labelTextStyle];
                newLabel.tickLocation = [[NSNumber numberWithFloat:labelLocation] decimalValue];
                newLabel.offset = xAxis.labelOffset+xAxis.majorTickLength;
                newLabel.rotation = M_PI/6;
                [labelArray addObject:newLabel];
                labelLocation += 1;
            }
            xAxis.axisLabels=[NSSet setWithArray:labelArray];
            [barPlot reloadData];
        }
        
    }];
    
    [myAlert addAction:cancelAction];
    [myAlert addAction:destructiveAction];
    
    pickView.delegate = self;
    
    [self presentViewController:myAlert animated:YES completion:nil];
}

#pragma mark - CPTPlotDelegate
#pragma ===========================CPTPlotDelegate========================
//返回扇形或柱数目
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [platformName count];
}
//返回每个扇形的比例或柱对应的值
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    float num = [[platformTotalCapital valueForKey:platformName[idx]] floatValue];
    if ([plot isKindOfClass:[CPTPieChart class]]) {//饼状图
        return [NSNumber numberWithFloat:num / totalCapital];
    } else {//柱状图
        switch (fieldEnum) {
                //x 轴坐标（柱子位置）
            case CPTBarPlotFieldBarLocation:
                return [NSDecimalNumber numberWithUnsignedInteger:idx];    // X轴上的数值表示
                break;
            case CPTBarPlotFieldBarTip:
                return [platformTotalCapital valueForKey:platformName[idx]];
                break;
            default:
                break;
        }
    }
    return 0;
}
//凡返回每个扇形或柱的标题
- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    CPTTextLayer *label;
    if ([plot isKindOfClass:[CPTPieChart class]]) {
        label = [[CPTTextLayer alloc]initWithText:[NSString stringWithFormat:@"%@",platformName[idx]]];
        CPTMutableTextStyle *text = [ label.textStyle mutableCopy];
        text.color = [CPTColor whiteColor];
    } else {
        label = [[CPTTextLayer alloc]initWithText:[NSString stringWithFormat:@"%.f",[[platformTotalCapital objectForKey:platformName[idx]] floatValue]]];
        CPTMutableTextStyle *text = [ label.textStyle mutableCopy];
        text.color = [CPTColor whiteColor];
    }
    
    return label;
}

#pragma ===========CPTPieChart CPTBarPlot  Delegate========================
//选中某个扇形时的操作
- (void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx
{
    UILabel *proportionLable = (UILabel *)[self.view viewWithTag:102];
    float num = [[platformTotalCapital valueForKey:platformName[idx]] floatValue];
    proportionLable.text = [NSString stringWithFormat:@"%.1f%%",num/totalCapital*100];
    flag1 = idx;
    [plot reloadData];
}


//对于饼图，我们可以把某块扇形“切除”下来，以此突出该扇形区域。这需要实现数据源方法radialOffsetForPieChart:recordIndex: 方法。以下代码将饼图中第2块扇形“剥离”10个像素点
-(CGFloat)radialOffsetForPieChart:(CPTPieChart*)piePlot recordIndex:(NSUInteger)index{
    if (index == flag1) {
        return 5;
    }
    return 0;
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    CPTColor *color;
    if (flag2 < [platformTotalCapital count]) {
        color = [CPTColor colorWithComponentRed:arc4random()%255/255.0  green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        [colorArray addObject:color];
        flag2++;
    } else {
        color = colorArray[index];
    }
    return [CPTFill fillWithColor:color];
}

#pragma mark - PickerView Delegate
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch(component)
    {
        case 0:return [pickerArray1 count];
        case 1:return [pickerArray2 count];
        case 2:return [pickerArray3 count];
        default:return 0;
    }
    
}

//设置当前行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch(component)
    {
        case 0:return [pickerArray1 objectAtIndex:row];
        case 1:return [pickerArray2 objectAtIndex:row];
        case 2:return [pickerArray3 objectAtIndex:row];
        default:return nil;
    }
}

#pragma mark -
#pragma mark Transform

- (CGAffineTransform)transform
{
    CGFloat translateX = RContentOffset;
    
    //CGAffineTransformMakeTranslation：移动，创建一个平移的变化
    //它将返回一个CGAffineTransform类型的仿射变换，这个函数的两个参数指定x和y方向上以点为单位的平移量。
    //假设是一个视图，那么它的起始位置 x 会加上tx , y 会加上 ty
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    
    //CGAffineTransformMakeScale：缩放，创建一个给定比例放缩的变换
    //假设是一个图片视图引用了这个变换，那么图片的宽度就会变为 width*sx ，对应高度变为 hight * sy。
    CGAffineTransform scaleT = CGAffineTransformMakeScale(1.0, RContentScale);//RContentScale = 0.83f
    
    //CGAffineTransformConcat 通过两个已经存在的放射矩阵生成一个新的矩阵t' = t1 * t2
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    return conT;
}

- (void)configureViewShadow//设置阴影
{
    CGFloat shadowW = -2.0f;
    _mainContentView.layer.shadowOffset = CGSizeMake(shadowW, 1.0);//设置阴影的偏移量
    _mainContentView.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    _mainContentView.layer.shadowOpacity = 0.8f;//设置阴影的不透明度
}


- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    static CGFloat currentTranslateX;
    
    if (panGes.state == UIGestureRecognizerStateBegan)
    {
        currentTranslateX = _mainContentView.transform.tx;//获取开始拖动时_mainContentView的x坐标
    }
    if (panGes.state == UIGestureRecognizerStateChanged)
    {
        /*
         让view跟着手指移动
         
         1.获取每次系统捕获到的手指移动的偏移量translation
         2.根据偏移量translation算出当前view应该出现的位置
         3.设置view的新frame
         4.将translation重置为0（十分重要。否则translation每次都会叠加，很快你的view就会移除屏幕！）
         */
        //CGPoint translation = [gestureRecognizer translationInView:self.view];
        //view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x, gestureRecognizer.view.center.y + translation.y);
        //[gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];//  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加，很快你的view就会移除屏幕！
        
        CGFloat transX = [panGes translationInView:_mainContentView].x;//在x轴上，手指移动的偏移量
        transX = transX + currentTranslateX;//此时_mainContentView(中心点)在x上的坐标
        
        CGFloat sca;//mainContentView的缩放比例
        if (transX > 0)
        {
            [self configureViewShadow];//设置阴影
            
            if (_mainContentView.frame.origin.x < RContentOffset)
            {
                sca = 1 - (_mainContentView.frame.origin.x/RContentOffset) * (1-RContentScale);
            }
            else
            {
                sca = RContentScale;//当mainContentView偏移超过RContentOffset时，缩小比例固定为RContentScale
            }
        }
        else {
            sca = 1.0;
            transX = _mainContentView.transform.tx;
        }
        CGAffineTransform transS = CGAffineTransformMakeScale(1.0, sca);
        CGAffineTransform transT = CGAffineTransformMakeTranslation(transX, 0);
        
        CGAffineTransform conT = CGAffineTransformConcat(transT, transS);
        
        _mainContentView.transform = conT;
    }
    else if (panGes.state == UIGestureRecognizerStateEnded)//手势结束
    {
        CGFloat panX = [panGes translationInView:_mainContentView].x;
        CGFloat finalX = currentTranslateX + panX;
        if (finalX > RJudgeOffset)// 手指滑动的偏移量不需要达到RContentOffset（220），只要到RJudgeOffset（100），就可以显示leftSliderView
        {
            CGAffineTransform conT = [self transform];
            [UIView beginAnimations:nil context:nil];
            _mainContentView.transform = conT;
            [UIView commitAnimations];
            
            return;
        }
        else//还显示mainContentView
        {
            //当你改变过一个view.transform属性或者view.layer.transform的时候需要恢复默认状态的话，记得先把他们重置可以使用view.transform = CGAffineTransformIdentity
            CGAffineTransform oriT = CGAffineTransformIdentity;
            [UIView beginAnimations:nil context:nil];
            _mainContentView.transform = oriT;
            [UIView commitAnimations];
            
        }
    }
}



@end
