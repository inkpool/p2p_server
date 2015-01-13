//
//  platfromDB.h
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/23/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface platformDB : NSObject
-(NSString *)getDataBasePath;
-(void)copyDatabaseIfNeeded;
-(NSMutableArray*)getField:(NSString *)field;
-(NSMutableArray*)getProductFromOnePlatform:(NSString *)field;
-(NSString*)getDuration:(NSString*)platform secondPara:(NSString*)product;
-(NSString*)getCalType:(NSString*)platform secondPara:(NSString*)product;
//获取利率，最高利率和最低利率，传入参数为平台和产品名称
-(NSMutableArray*)getRates:(NSString *)field1 secondPara:(NSString*)field2;


@end
