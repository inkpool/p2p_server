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
    [formatter setDateFormat : @"yyyy-M-d"];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArray {
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

@end
