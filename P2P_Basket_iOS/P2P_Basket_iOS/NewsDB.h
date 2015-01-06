//
//  NewsDB.h
//  P2P_Basket_iOS
//
//  Created by xuxin on 15-1-6.
//  Copyright (c) 2015年 inkJake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface NewsDB : NSObject

- (void)copyDatabaseIfNeeded;
- (NSInteger)insertNews:(long int)timeStamp withTitle:(NSString*)title withContent:(NSString*)content;
- (NSMutableArray *)getAllNews;

@end
