//
//  AnalysisViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-12-25.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "AnalysisViewController.h"

//#define PIE_HEIGHT 280

@interface AnalysisViewController ()
{
    NSMutableDictionary *platformTotalCapital;//记录各个平台在投总额
    int rateStatistics[8];
    int termStructure[8];
    int remainingTime[7];
    NSArray *platformName;//所有的平台名称
    NSMutableArray *platformTotalCapitalArray;
    NSMutableArray *rateStatisticsArray;
    NSMutableArray *termStructureArray;
    NSMutableArray *remainingTimeArray;
    NSMutableArray *colorArray1;
    NSMutableArray *colorArray2;
    NSMutableArray *colorArray3;
    CGRect pieFrame;
}
@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screen_width = size.width;
    CGFloat screen_height = size.height;
    CGFloat pieHeight = screen_width/4*3;
    self.view.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    flag = 0;
    [self initArray];
    
    //add shadow img
    pieFrame = CGRectMake((self.view.frame.size.width - pieHeight) / 2, screen_height/6, pieHeight, pieHeight);
    
    UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
    UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
    shadowImgView.frame = CGRectMake(0, pieFrame.origin.y + pieHeight*0.92, screen_width, shadowImg.size.height/2);
    [self.view addSubview:shadowImgView];
    
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    myPieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:platformTotalCapitalArray withColor:colorArray1];
    myPieChartView.delegate = self;
    [self.pieContainer addSubview:myPieChartView];
    [self.view addSubview:self.pieContainer];
    
    //add selected view
    UIImageView *selView = [[UIImageView alloc]init];
    selView.tag = 1001;
    selView.image = [UIImage imageNamed:@"select.png"];
    selView.frame = CGRectMake((self.view.frame.size.width - selView.image.size.width/2)/2, self.pieContainer.frame.origin.y + self.pieContainer.frame.size.height, selView.image.size.width/2, selView.image.size.height/2);
    [self.view addSubview:selView];
    
    self.selLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, selView.image.size.width/2, 21)];
    self.selLabel.backgroundColor = [UIColor clearColor];
    self.selLabel.textAlignment = NSTextAlignmentCenter;
    self.selLabel.font = [UIFont systemFontOfSize:17];
    self.selLabel.textColor = [UIColor colorWithRed:1.0/255.0 green:65.0/255.0 blue:128.0/255.0 alpha:1];
    [selView addSubview:self.selLabel];
    [myPieChartView setTitleText:@"平台在投总额"];
}

- (void)initArray {
//    [platformTotalCapital removeAllObjects];
    platformName = nil;
    platformTotalCapital = [NSMutableDictionary dictionary];
    remainingTime[0] = termStructure[0] = rateStatistics[0] = 0;
    remainingTime[1] = termStructure[1] = rateStatistics[1] = 0;
    remainingTime[2] = termStructure[2] = rateStatistics[2] = 0;
    remainingTime[3] = termStructure[3] = rateStatistics[3] = 0;
    remainingTime[4] = termStructure[4] = rateStatistics[4] = 0;
    remainingTime[5] = termStructure[5] = rateStatistics[5] = 0;
    remainingTime[6] = termStructure[6] = rateStatistics[6] = 0;
                       termStructure[7] = rateStatistics[7] = 0;
    
    for (int i = 0; i < [unExpireRecord count]; i++) {
        //计算各个平台在投总额
        id oneValue = [platformTotalCapital objectForKey:[unExpireRecord[i] objectForKey:@"platform"]];
        if (oneValue == nil) {
            NSNumber *num = [unExpireRecord[i] objectForKey:@"capital"];
            [platformTotalCapital setObject:num forKey:[unExpireRecord[i] objectForKey:@"platform"]];
        }
        else {
            float num = [[unExpireRecord[i] objectForKey:@"capital"] floatValue];
            num += [[platformTotalCapital objectForKey:[unExpireRecord[i] objectForKey:@"platform"]] floatValue];
            [platformTotalCapital setObject:[NSNumber numberWithFloat:num] forKey:[unExpireRecord[i] objectForKey:@"platform"]];
        }
        
        //收益率分析节点统计（分析节点6%、8%、10%、12%、15%、20%、25%）
        float rate;
        if ([[unExpireRecord[i] objectForKey:@"maxRate"] floatValue] != 100.0) {
            rate = [[unExpireRecord[i] objectForKey:@"maxRate"] floatValue];
        } else {
            rate = [[unExpireRecord[i] objectForKey:@"minRate"] floatValue];
        }
        if (rate <= 6.0) {
            rateStatistics[0]++;
        } else if (rate <= 8.0) {
            rateStatistics[1]++;
        } else if (rate <= 10.0) {
            rateStatistics[2]++;
        } else if (rate <= 12.0) {
            rateStatistics[3]++;
        } else if (rate <= 15.0) {
            rateStatistics[4]++;
        } else if (rate <= 20.0) {
            rateStatistics[5]++;
        } else if (rate <= 25.0) {
            rateStatistics[6]++;
        } else {
            rateStatistics[7]++;
        }
        
        //期限结构(一个月、三个月、半年、九个月、一年、一年半、二年)
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-M-d"];
        NSDate *startDate = [formatter dateFromString:[unExpireRecord[i] objectForKey:@"startDate"]];
        NSDate *endDate = [formatter dateFromString:[unExpireRecord[i] objectForKey:@"endDate"]];
        NSCalendar*calendar = [NSCalendar currentCalendar];
        NSDateComponents *startComps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: startDate];
        NSDateComponents *endComps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: endDate];
        int months;
        months = (int)([endComps year]*12+[endComps month]+[endComps day]/30-[startComps year]*12-[startComps month]-[startComps day]/30);
        if (months <= 1) {
            termStructure[0]++;
        } else if (months <= 3) {
            termStructure[1]++;
        } else if (months <= 6) {
            termStructure[2]++;
        } else if (months <= 9) {
            termStructure[3]++;
        } else if (months <= 12) {
            termStructure[4]++;
        } else if (months <= 18) {
            termStructure[5]++;
        } else if (months <= 24) {
            termStructure[6]++;
        } else {
            termStructure[7]++;
        }
        
        //回款时间(一周、一个月、三个月、半年、九个月、一年)
        NSDate *nowDate = [NSDate date];
        NSDateComponents *nowComps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: nowDate];
        if ([endComps year]!=[nowComps year] || [endComps month]!=[nowComps month]) {
            months = (int)([endComps year]*12+[endComps month]+[endComps day]/30-[nowComps year]*12-[nowComps month]-[nowComps day]/30);
            if (months <= 1) {
                remainingTime[1]++;
            } else if (months <= 3) {
                remainingTime[2]++;
            } else if (months <= 6) {
                remainingTime[3]++;
            } else if (months <= 9) {
                remainingTime[4]++;
            } else if (months <= 12) {
                remainingTime[5]++;
            } else {
                remainingTime[6]++;
            }
        }
        else {
            int days = (int)([endComps day]-[nowComps day]);
            if (days <= 7) {
                remainingTime[0]++;
            } else {
                remainingTime[1]++;
            }
        }
        
        //平台余额
        
    }//end for
    if ([unExpireRecord count] != 0) {
        platformName = [platformTotalCapital allKeys];
        platformTotalCapitalArray = [NSMutableArray arrayWithCapacity:[platformName count]];
        colorArray1 = [NSMutableArray arrayWithCapacity:[platformName count]];
        for (int i = 0; i < [platformName count]; i++) {
            [platformTotalCapitalArray insertObject:[platformTotalCapital objectForKey:platformName[i]] atIndex:i];
            [colorArray1 addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]];
        }
        
        rateStatisticsArray = [NSMutableArray arrayWithCapacity:8];
        termStructureArray = [NSMutableArray arrayWithCapacity:8];
        colorArray2 = [NSMutableArray arrayWithCapacity:8];
        for (int i = 0; i < 8; i++) {
            [rateStatisticsArray insertObject:[[NSNumber alloc] initWithInt:rateStatistics[i]] atIndex:i];
            [termStructureArray insertObject:[[NSNumber alloc] initWithInt:termStructure[i]] atIndex:i];
            [colorArray2 addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]];
        }
        
        remainingTimeArray = [NSMutableArray arrayWithCapacity:7];
        colorArray3 = [NSMutableArray arrayWithCapacity:7];
        for (int i = 0; i < 7; i++) {
            [remainingTimeArray insertObject:[[NSNumber alloc] initWithInt:remainingTime[i]] atIndex:i];
            [colorArray3 addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]];
        }
    }
    else {
        platformTotalCapitalArray = [NSMutableArray arrayWithCapacity:1];
        [platformTotalCapitalArray insertObject:[[NSNumber alloc] initWithInt:1] atIndex:0];
        colorArray1 = [NSMutableArray arrayWithCapacity:1];
        [colorArray1 addObject:[UIColor grayColor]];
        rateStatisticsArray = [NSMutableArray arrayWithCapacity:1];
        termStructureArray = [NSMutableArray arrayWithCapacity:1];
        colorArray2 = [NSMutableArray arrayWithCapacity:1];
        [rateStatisticsArray insertObject:[[NSNumber alloc] initWithInt:1] atIndex:0];
        [termStructureArray insertObject:[[NSNumber alloc] initWithInt:1] atIndex:0];
        [colorArray2 addObject:[UIColor grayColor]];
        remainingTimeArray = [NSMutableArray arrayWithCapacity:1];
        colorArray3 = [NSMutableArray arrayWithCapacity:1];
        [remainingTimeArray insertObject:[[NSNumber alloc] initWithInt:1] atIndex:0];
        [colorArray3 addObject:[UIColor grayColor]];
    }
    
}

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
//    NSLog(@"selectedFinish11111");
    if ([unExpireRecord count] != 0) {
        switch (flag) {
            case 0:
                self.selLabel.text = [NSString stringWithFormat:@"%@:%.2f%%",platformName[index],per*100];
                break;
            case 1:
                switch (index) {
                    case 0:
                        self.selLabel.text = [NSString stringWithFormat:@"0%%~6%%:%.2f%%",per*100];
                        break;
                    case 1:
                        self.selLabel.text = [NSString stringWithFormat:@"6%%~8%%:%.2f%%",per*100];
                        break;
                    case 2:
                        self.selLabel.text = [NSString stringWithFormat:@"8%%~10%%:%.2f%%",per*100];
                        break;
                    case 3:
                        self.selLabel.text = [NSString stringWithFormat:@"10%%~12%%:%.2f%%",per*100];
                        break;
                    case 4:
                        self.selLabel.text = [NSString stringWithFormat:@"12%%~15%%:%.2f%%",per*100];
                        break;
                    case 5:
                        self.selLabel.text = [NSString stringWithFormat:@"15%%~20%%:%.2f%%",per*100];
                        break;
                    case 6:
                        self.selLabel.text = [NSString stringWithFormat:@"20%%~25%%:%.2f%%",per*100];
                        break;
                    case 7:
                        self.selLabel.text = [NSString stringWithFormat:@"25%%以上:%.2f%%",per*100];
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                switch (index) {
                    case 0:
                        self.selLabel.text = [NSString stringWithFormat:@"0~1个月:%.2f%%",per*100];
                        break;
                    case 1:
                        self.selLabel.text = [NSString stringWithFormat:@"1~3个月:%.2f%%",per*100];
                        break;
                    case 2:
                        self.selLabel.text = [NSString stringWithFormat:@"3~6个月:%.2f%%",per*100];
                        break;
                    case 3:
                        self.selLabel.text = [NSString stringWithFormat:@"6~9个月:%.2f%%",per*100];
                        break;
                    case 4:
                        self.selLabel.text = [NSString stringWithFormat:@"9个月~1年:%.2f%%",per*100];
                        break;
                    case 5:
                        self.selLabel.text = [NSString stringWithFormat:@"1年~1年半:%.2f%%",per*100];
                        break;
                    case 6:
                        self.selLabel.text = [NSString stringWithFormat:@"1年半~2年:%.2f%%",per*100];
                        break;
                    case 7:
                        self.selLabel.text = [NSString stringWithFormat:@"2年以上:%.2f%%",per*100];
                        break;
                    default:
                        break;
                }
                break;
            case 3:
                switch (index) {
                    case 0:
                        self.selLabel.text = [NSString stringWithFormat:@"0~1周:%.2f%%",per*100];
                        break;
                    case 1:
                        self.selLabel.text = [NSString stringWithFormat:@"1周~1个月:%.2f%%",per*100];
                        break;
                    case 2:
                        self.selLabel.text = [NSString stringWithFormat:@"1个月~3个月:%.2f%%",per*100];
                        break;
                    case 3:
                        self.selLabel.text = [NSString stringWithFormat:@"3个月~6个月:%.2f%%",per*100];
                        break;
                    case 4:
                        self.selLabel.text = [NSString stringWithFormat:@"6个月~9个月:%.2f%%",per*100];
                        break;
                    case 5:
                        self.selLabel.text = [NSString stringWithFormat:@"9个月~1年:%.2f%%",per*100];
                        break;
                    case 6:
                        self.selLabel.text = [NSString stringWithFormat:@"1年以上:%.2f%%",per*100];
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    else {//无数据
        switch (flag) {
            case 0:
                self.selLabel.text = @"无数据";
                break;
            case 1:
                self.selLabel.text = @"无数据";
                break;
            case 2:
                self.selLabel.text = @"无数据";
                break;
            case 3:
                self.selLabel.text = @"无数据";
                break;
            default:
                break;
        }
    }
    
    NSLog(@"%ld",(long)index);
//    NSLog(@"selectedFinish22222");
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    NSLog(@"onCenterClick111111");
    myPieChartView.delegate = nil;
    [myPieChartView removeFromSuperview];
    flag++;
    if (flag > 3) {
        flag = 0;
    }
    switch (flag) {
        case 0:
            myPieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:platformTotalCapitalArray withColor:colorArray1];
            [myPieChartView setTitleText:@"平台在投总额"];
//            [self.pieChartView setAmountText:@"-2456.0"];
            break;
        case 1:
            myPieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:rateStatisticsArray withColor:colorArray2];
            [myPieChartView setTitleText:@"收益率"];
//            [self.pieChartView setAmountText:@"+567.23"];
            break;
        case 2:
            myPieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:termStructureArray withColor:colorArray2];
            [myPieChartView setTitleText:@"期限结构"];
//            [self.pieChartView setAmountText:@"+567.23"];
            break;
        case 3:
            myPieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:remainingTimeArray withColor:colorArray3];
            [myPieChartView setTitleText:@"回款时间"];
//            [self.pieChartView setAmountText:@"+567.23"];
            break;
        default:
            break;
    }
    [self.pieContainer addSubview:myPieChartView];
    myPieChartView.delegate = self;
    [myPieChartView reloadChart];
    NSLog(@"onCenterClick22222");
}

- (void)reloadData {
//    NSLog(@"reloadData111111");
    [self initArray];
    myPieChartView.delegate = nil;
    [myPieChartView removeFromSuperview];
    [self.pieContainer removeFromSuperview];
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    switch (flag) {
        case 0:
            myPieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:platformTotalCapitalArray withColor:colorArray1];
            [myPieChartView setTitleText:@"平台在投总额"];
            //            [self.pieChartView setAmountText:@"-2456.0"];
            break;
        case 1:
            myPieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:rateStatisticsArray withColor:colorArray2];
            [myPieChartView setTitleText:@"收益率"];
            //            [self.pieChartView setAmountText:@"+567.23"];
            break;
        case 2:
            myPieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:termStructureArray withColor:colorArray2];
            [myPieChartView setTitleText:@"期限结构"];
            //            [self.pieChartView setAmountText:@"+567.23"];
            break;
        case 3:
            myPieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:remainingTimeArray withColor:colorArray3];
            [myPieChartView setTitleText:@"回款时间"];
            //            [self.pieChartView setAmountText:@"+567.23"];
            break;
        default:
            break;
    }
    [self.pieContainer addSubview:myPieChartView];
    [self.view addSubview:self.pieContainer];
    myPieChartView.delegate = self;
    UIImageView *selView = (UIImageView*)[self.view viewWithTag:1001];
    [self.view bringSubviewToFront:selView];
    //    [myPieChartView reloadChart];
//    NSLog(@"reloadData22222");
}

- (void)viewDidAppear:(BOOL)animated
{
    [myPieChartView reloadChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
