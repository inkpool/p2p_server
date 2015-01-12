//
//  MoreViewController.h
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/15/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *newsArray;
    UITableView *myTableView;
}
@end
