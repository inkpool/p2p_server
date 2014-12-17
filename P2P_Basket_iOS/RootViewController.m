//
//  RootViewController.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 14-11-10.
//  Copyright (c) 2014年 inkJake. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LeftSliderController.h"
#import "AddViewController.h"
#include "RecordDB.h"
#import "HomeViewController.h"
#import "FlowViewController.h"
#import "AnalysisViewController.h"
#import "PlatformViewController.h"

#define RCloseDuration 0.3f
#define ROpenDuration 0.4f
#define RContentScale 0.85f
#define RJudgeOffset 100.0f

@interface RootViewController ()
{
    UIView *_mainContentView;
    UIView *_leftSideView;
    NSInteger ifActivated;
    UITapGestureRecognizer *_tapGestureRec;
    UIPanGestureRecognizer *_panGestureRec;
    NSMutableArray *expireRecord;//已到期的投资记录
    NSMutableArray *expiringRecord;//即将到期的投资记录
    float RContentOffset;
    CGFloat screen_width;
}

@end

static RootViewController *sharedRC;
@implementation RootViewController

+ (id)sharedRootController
{//单例
    return sharedRC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    
    RContentOffset = screen_width/3*2;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRC = self;
    });
    
    ifActivated=0;
    
    [self initRecord];
    
    //初始化，初始化结束后，_mainContentView位于_leftSideView的上层（覆盖），所以最先显示_mainContentView
    [self initSubviews];
    [self initChildControllers];
    
//    _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];//只要点击了self.view（即屏幕上的任何一点），_mainContentView就会完全覆盖_leftSideView
//    [self.view addGestureRecognizer:_tapGestureRec];
    
//    _tapGestureRec.enabled = NO;//未显示_leftSideView，不响应用户普通的点击事件
    
    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [_mainContentView addGestureRecognizer:_panGestureRec];//只有_mainContentView响应手指滑动事件，_mainContentView滑动时，_leftSideView会露出一部分（此时_leftSideView未被_mainContentView完全覆盖）
    
}


#pragma mark -
#pragma mark Intialize Method

- (void)initRecord {
    //1、初始化record，即从数据库recordT表中读出用户所有的投资记录
    //2、找出所有已经到期和即将到期的投资
    
    //读取数据库表recordT中用户的所有投资记录
    RecordDB *recordDB = [[RecordDB alloc] init];
    [recordDB copyDatabaseIfNeeded];
    records = [recordDB getAllRecord];
    expireRecord = [[NSMutableArray alloc] init];
    expiringRecord = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-M-d"];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowComps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: nowDate];
    
    NSDate *endDate;
    NSDateComponents *endComps;
    NSInteger flag1;
    NSInteger flag2;
    for (int i = 0; i < [records count]; i++) {
        endDate = [formatter dateFromString:[records[i] objectForKey:@"endDate"]];
        endComps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: endDate];
        
        flag1 = ([nowComps year]-[endComps year])*10000 + ([nowComps month]-[endComps month])*100 + ([nowComps day]-[endComps day]);
        flag2 = ([nowComps year]-[endComps year])*10000 + ([nowComps month]-[endComps month])*100 + ([nowComps day]+10-[endComps day]);//小于10天即为即将到期
        if (flag1 > 0) {
            if ([[records[i] objectForKey:@"state"] integerValue] == 0) {
                [expireRecord addObject:records[i]];//已到期，需要处理
            }
        }
        if (flag1 < 0 && flag2 > 0) {
            [expiringRecord addObject:records[i]];//即将到期
        }
    }

}


- (void)initSubviews {
//self.view显示最上层的view，通过设置最上层的view，实现主界面和slider view的切换
    
    UIView *lv = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:lv];
    _leftSideView = lv;
    
    UIView *mv = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mv];
    _mainContentView = mv;
}

- (void)initChildControllers {
    //初始化“更多”功能界面所在的ViewController
    LeftSliderController *leftSC = [[LeftSliderController alloc] init];
    leftSC->records = records;
    [self addChildViewController:leftSC];
    [_leftSideView addSubview:leftSC.view];
    
    //初始化NavigationController，以显示“主页”、“流水”等tab view
    nc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"navigationController"];
    [self addChildViewController:nc];//添加子视图控制器（添加后，才能响应tabBarController控制的视图中的点击事件）
    [_mainContentView addSubview:nc.view];

    //NavigationItem：点击左按钮，显示“更多”功能界面；点击右按钮，显示添加“新的投资”的界面
    UITabBarController *tbc = [nc.childViewControllers firstObject];
    tbc.delegate = self;
    //向HomeViewController、FlowViewController传递数据库中用户所有的投资记录
    HomeViewController *homeViewController = tbc.viewControllers[0];
    homeViewController->records = records;
    homeViewController->expireRecord = expireRecord;
    homeViewController->expiringRecord = expiringRecord;
    FlowViewController *flowViewController = tbc.viewControllers[3];
    flowViewController->records = records;
    AnalysisViewController *analysisViewController = tbc.viewControllers[2];
    analysisViewController->records = records;
    analysisViewController->_mainContentView = _mainContentView;
    PlatformViewController *platformViewController = tbc.viewControllers[1];
    platformViewController->records = records;
    platformViewController->platformSet = [NSMutableSet set];
    for (int i = 0; i < [records count]; i++) {
        //platformSet保存用户投资过的平台的名称,set是单值对象的集合，自动删除重复的对象
        [platformViewController->platformSet addObject:[records[i] objectForKey:@"platform"]];
    }
    
    
    [tbc.navigationItem.leftBarButtonItem setAction:@selector(leftBarButtonItemPressed)];
    
    [tbc.navigationItem.rightBarButtonItem setAction:@selector(rightBarButtonItemPressed)];
}

#pragma mark -
#pragma mark UIViewPassValueDelegate
- (void)refreshTableView {
    //添加新的投资后刷新主页和流水界面
    [self initRecord];
    //NSLog(@"records:%@",records);
    UITabBarController *tbc = [nc.childViewControllers firstObject];
    HomeViewController *homeViewController = tbc.viewControllers[0];
    homeViewController->records = records;
    homeViewController->expireRecord = expireRecord;
    homeViewController->expiringRecord = expiringRecord;
    [homeViewController->tableView reloadData];
    
    UILabel *label1 = (UILabel *)[homeViewController.view viewWithTag:111];
    label1.text = [NSString stringWithFormat:@"%ld",[homeViewController->expiringRecord count]];
    UILabel *label2 = (UILabel *)[homeViewController.view viewWithTag:112];
    label2.text = [NSString stringWithFormat:@"%ld",[homeViewController->expireRecord count]];
    
    FlowViewController *flowViewController = tbc.viewControllers[3];
    flowViewController->records = records;
    
    if (flowViewController->button_flag == 0) {
        flowViewController->sortedRecord = flowViewController->records;
    }
    else if (flowViewController->button_flag == 101) {//按投资时间降序
        if ([[flowViewController->triangle_flag valueForKey:[NSString stringWithFormat:@"%ld",flowViewController->button_flag*10]] isEqualToString:@"1"]) {
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
            flowViewController->sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
            //NSLog(@"sortedRecord:%@",sortedRecord);
        }
        else {//按投资时间升序
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
            flowViewController->sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
        }
    }
    else if (flowViewController->button_flag == 102) {//按投资金额降序
        if ([[flowViewController->triangle_flag valueForKey:[NSString stringWithFormat:@"%ld",flowViewController->button_flag*10]] isEqualToString:@"1"]) {
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"capital" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
            flowViewController->sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
            
        }
        else {//按投资金额升序
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"capital" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
            flowViewController->sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
        }
    }
    else {//按年化收益率降序
        if ([[flowViewController->triangle_flag valueForKey:[NSString stringWithFormat:@"%ld",flowViewController->button_flag*10]] isEqualToString:@"1"]) {
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"maxRate" ascending:NO];
            NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"minRate" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,secondDescriptor,nil];
            flowViewController->sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
            
        }
        else {//按年化收益率升序
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"maxRate" ascending:YES];
            NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"minRate" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,secondDescriptor,nil];
            flowViewController->sortedRecord = [records sortedArrayUsingDescriptors:sortDescriptors];
        }
    }
    
    [flowViewController->tableView reloadData];
}

#pragma mark -
#pragma mark Actions
- (void)leftBarButtonItemPressed {
    
    if(ifActivated==0)
    {
        //NSLog(@"left");
        CGAffineTransform conT = [self transform];

        [self configureViewShadow];//设置阴影
        
        [UIView animateWithDuration:ROpenDuration
                         animations:^{
                             //UIView有个transform的属性，通过设置该属性，我们可以实现调整该view在其superView中的大小和位置,
                             //具体来说，Transform(变化矩阵)是一种3×3的矩阵,通过这个矩阵我们可以对一个坐标系统进行缩放，平移，旋转
                             //以及这两者的任意组合操作。
                             _mainContentView.transform = conT;
                         }
                         completion:^(BOOL finished) {
                             _tapGestureRec.enabled = YES;//开启响应点击屏幕时间，执行closeSideBar方法的手势
                         }];
        ifActivated=1;
    }
    else
    {
        [self closeSideBar];
        ifActivated=0;
    }

}

- (void)rightBarButtonItemPressed {
    
    //添加“新建投资”页面
    AddViewController *aDV = [[AddViewController alloc]init];
    aDV->delegate = self;
    [nc pushViewController:aDV animated:YES];
}

- (void)closeSideBar
{
    CGAffineTransform oriT = CGAffineTransformIdentity;//当你改变过一个view.transform属性或者view.layer.transform的时候需要恢复默认状态的话，记得先把他们重置可以使用view.transform = CGAffineTransformIdentity
    [UIView animateWithDuration:RCloseDuration
                     animations:^{
                         _mainContentView.transform = oriT;
                     }
                     completion:^(BOOL finished) {
                         _tapGestureRec.enabled = NO;
                     }];
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
            
            _tapGestureRec.enabled = YES;
            return;
        }
        else//还显示mainContentView
        {
            //当你改变过一个view.transform属性或者view.layer.transform的时候需要恢复默认状态的话，记得先把他们重置可以使用view.transform = CGAffineTransformIdentity
            CGAffineTransform oriT = CGAffineTransformIdentity;
            [UIView beginAnimations:nil context:nil];
            _mainContentView.transform = oriT;
            [UIView commitAnimations];
            
            _tapGestureRec.enabled = NO;
        }
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

#pragma mark -
#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //点击进入分析界面后，柱状图可以拖动，为了避免和_panGestureRec冲突，分析界面不要响应拖动事件，而在分析界面内重新规定
    if ([viewController isKindOfClass:[AnalysisViewController class]]) {
        
        [_mainContentView removeGestureRecognizer:_panGestureRec];
    } else {
        [_mainContentView addGestureRecognizer:_panGestureRec];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
