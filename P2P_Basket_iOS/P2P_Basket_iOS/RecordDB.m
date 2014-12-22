//
//  recordDB.m
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/29/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import "RecordDB.h"
#import <sqlite3.h>

@implementation RecordDB
- (NSString *)getDataBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES);
    NSString *dbPath = [paths objectAtIndex:0];
    return [dbPath stringByAppendingPathComponent:@"p2p_basket.sqlite"];
}

- (void)copyDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDataBasePath];
//    NSLog(@"%@",dbPath);
    NSString *resPath;
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if(!success)
    {
        resPath = [[NSBundle mainBundle] pathForResource:@"p2p_basket" ofType:@"sqlite"];
        NSLog(@"resPath:\n%@",resPath);
        success = [fileManager copyItemAtPath:resPath toPath:dbPath error:&error];
        if(!success)
        {
            NSLog(@"Failed to copy");
        }
        else
        {
            NSLog(@"successfully copied");
        }
    }
    else
    {
        NSLog(@"File already exists.");
    }
}

- (NSInteger)insertRecord:(NSString*)platform secondPara:(NSString*)product thirdPara:(float)capital forthPara:(float)minRate
fifthPara:(float)maxRate sixthPara:(NSString*)calType seventhPara:(NSString*)startDate eighthPara:(NSString*)endDate
{
    //检查有没有将数据库复制到沙盒library
    [self copyDatabaseIfNeeded];

    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt=nil;
    
    //数据库路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/p2p_basket.sqlite"];
    
    //查看沙盒路径
    //NSLog(@"%@",NSHomeDirectory());
    
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK)
    {
        NSLog(@"SQLite DB open error.");
        return -1;
    }
    
    NSInteger state = 0;
    long int timeStamp = [[NSDate date] timeIntervalSince1970];
    int isDeleted = 0;
    //组合而成的sql语句，占位符坑爹啊！
    NSString *sql=[[NSString alloc]initWithFormat:@"INSERT INTO recordT VALUES(NULL,\"%@\",\"%@\",%f,%f,%f,\"%@\",\"%@\",\"%@\",%ld,%d,%d)",platform,product,capital,minRate,maxRate,calType,startDate,endDate,timeStamp,state,isDeleted];
    //编译SQL语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if( result != SQLITE_OK){
        return -1;
    }
    
    
    //向SQL语句上的占位符绑定数据
    //sqlite3_bind_text(stmt, 1,"product",-1,nil);
    
    result = sqlite3_step(stmt);
    
    if(result!=SQLITE_DONE)
        return -1;
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);

    return 0;
}

//查询数据
- (NSMutableArray *)getAllRecord:(BOOL) flag {
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    NSMutableArray *records = [[NSMutableArray alloc] init];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/p2p_basket.sqlite"];
    
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&sqlite);
    if (result != SQLITE_OK){
        NSLog(@"SQLite DB open error.");
        return NULL;
    }
    
    NSString *sql;
    //创建表的SQL语句
    if (flag) {//读取所有的投资记录
        sql = @"SELECT * FROM recordT";
    } else {//读取未被删除的投资记录
        sql = @"SELECT * FROM recordT WHERE isDeleted = 0";
    }
    //编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    //查询数据
    result = sqlite3_step(stmt);
    
    while (result == SQLITE_ROW) {
        
        char *platform = (char *)sqlite3_column_text(stmt, 1);
        char *product = (char *)sqlite3_column_text(stmt, 2);
        float capital = sqlite3_column_double(stmt, 3);
        float minRate = sqlite3_column_double(stmt, 4);
        float maxRate = sqlite3_column_double(stmt, 5);
        char *calType = (char *)sqlite3_column_text(stmt, 6);
        char *startDate = (char *)sqlite3_column_text(stmt, 7);
        char *endDate = (char *)sqlite3_column_text(stmt, 8);
        long int timeStamp = sqlite3_column_int(stmt, 9);
        int state = sqlite3_column_int(stmt, 10);
        int isDeleted = sqlite3_column_int(stmt, 11);
        
        NSString *platformString = [NSString stringWithCString:platform encoding:NSUTF8StringEncoding];
        NSString *productString = [NSString stringWithCString:product encoding:NSUTF8StringEncoding];
        NSNumber *capitalNumber = [[NSNumber alloc] initWithFloat:capital];
        NSNumber *minRateNumber = [[NSNumber alloc] initWithFloat:minRate];
        NSNumber *maxRateNumber = [[NSNumber alloc] initWithFloat:maxRate];
        NSString *calTypeString = [NSString stringWithCString:calType encoding:NSUTF8StringEncoding];
        NSString *startDateString = [NSString stringWithCString:startDate encoding:NSUTF8StringEncoding];
        NSString *endDateString = [NSString stringWithCString:endDate encoding:NSUTF8StringEncoding];
        NSNumber *timeStampNumber = [[NSNumber alloc] initWithInt:timeStamp];
        NSNumber *stateNumber = [[NSNumber alloc] initWithInt:state];
        NSNumber *isDeletedNumber = [[NSNumber alloc] initWithInt:isDeleted];
        
        //NSLog(@"平台：%@\n产品：%@\n金额：%@\n最小利率：%@\n最大利率：%@\n类型：%@\n开始时间：%@\n结束时间：%@\n\n\n",platformString,productString,capitalNumber,minRateNumber,maxRateNumber,calTypeNumber,startDateString,endDateString);
        NSDictionary *investment = [NSDictionary dictionaryWithObjectsAndKeys:platformString,@"platform",productString,@"product",capitalNumber,@"capital",minRateNumber,@"minRate",maxRateNumber,@"maxRate",calTypeString,@"calType",startDateString,@"startDate",endDateString,@"endDate",timeStampNumber,@"timeStamp",stateNumber,@"state",isDeletedNumber,@"isDeleted",nil];
        [records addObject:investment];
        
        result = sqlite3_step(stmt);
    }
    //NSLog(@"records:\n%@",records);
    
    //关闭数据库句柄
    sqlite3_finalize(stmt);
    
    //关闭数据库
    sqlite3_close(sqlite);
    
    return records;
}

//标记投资为已删除
- (BOOL) updateRecord:(long int)timeStamp{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/p2p_basket.sqlite"];
    
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&sqlite);
    if (result != SQLITE_OK){
        NSLog(@"SQLite DB open error.");
        return NO;
    }

    //创建表的SQL语句
    NSString *sql = @"UPDATE recordT set isDeleted = 1 where timeStamp = ?";
    //编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    sqlite3_bind_int(stmt, 1, timeStamp);
    
    //删除数据
    result = sqlite3_step(stmt);
    
    if( result == SQLITE_ERROR){
        NSLog(@"删除失败");
        sqlite3_close(sqlite);
        return NO;
    }
    //关闭数据库句柄
    sqlite3_finalize(stmt);
    //关闭数据库
    sqlite3_close(sqlite);
    return YES;
}

@end


//insert into recordT values(null,'人人贷','U计划A',10000,7,14,1,'2014-1-1','2014-7-1');









