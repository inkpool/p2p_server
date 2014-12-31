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
fifthPara:(float)maxRate sixthPara:(NSString*)calType seventhPara:(NSString*)startDate eighthPara:(NSString*)endDate ninthPara:(NSString*)userName
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
//    if (maxRate == 0) {
//        maxRate = 100.0;
//    }
    NSLog(@"%.2f,%.2f",minRate,maxRate);
    //组合而成的sql语句，占位符坑爹啊！
    NSString *sql=[[NSString alloc]initWithFormat:@"INSERT INTO recordT VALUES(NULL,\"%@\",\"%@\",%f,%f,%f,\"%@\",\"%@\",\"%@\",%ld,%d,%d,\"%@\")",platform,product,capital,minRate,maxRate,calType,startDate,endDate,timeStamp,state,isDeleted,userName];
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
- (NSMutableArray *)getAllRecord:(BOOL) flag withUserName:(NSString*)userName{
    //检查有没有将数据库复制到沙盒library
    [self copyDatabaseIfNeeded];
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
        sql=[[NSString alloc]initWithFormat:@"SELECT * FROM recordT WHERE userName = \"%@\"",userName];
    } else {//读取未被删除的投资记录
        sql=[[NSString alloc]initWithFormat:@"SELECT * FROM recordT WHERE isDeleted = 0 AND userName = \"%@\"",userName];
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
        NSNumber *timeStampNumber = [[NSNumber alloc] initWithLong:timeStamp];
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
- (BOOL) updateRecord:(long int)timeStamp withUserName:(NSString*)userName{
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
    NSString *sql = [[NSString alloc]initWithFormat:@"UPDATE recordT set isDeleted = 1 where timeStamp = ? AND userName = \"%@\"",userName];
    //编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    sqlite3_bind_int64(stmt, 1, timeStamp);
    
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

//覆盖本地记录
- (BOOL) coverLocalRecord:(NSString*)platform secondPara:(NSString*)product thirdPara:(float)capital forthPara:(float)minRate fifthPara:(float)maxRate sixthPara:(NSString*)calType seventhPara:(NSString*)startDate eighthPara:(NSString*)endDate ninthPara:(long int)timeStamp tenthPara:(int)state eleventhPara:(int)isDeleted withUserName:(NSString*)userName {
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/p2p_basket.sqlite"];
    BOOL flag = TRUE;
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&sqlite);
    if (result != SQLITE_OK){
        NSLog(@"SQLite DB open error.");
        return NO;
    }
    
    NSString *sql = [[NSString alloc]initWithFormat:@"SELECT * FROM recordT WHERE timeStamp = ? AND userName = \"%@\"",userName];
    //编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    sqlite3_bind_int64(stmt, 1, timeStamp);
    //查询数据
    result = sqlite3_step(stmt);
    if (result != SQLITE_ROW) {
        NSLog(@"云端新的投资记录");
        //插入从云上下载的新的投资记录
        BOOL isOK = [self insertRecordFromCloud:platform secondPara:product thirdPara:capital forthPara:minRate fifthPara:maxRate sixthPara:calType seventhPara:startDate eighthPara:endDate ninthPara:timeStamp tenthPara:state eleventhPara:isDeleted withUserName:userName];
        sqlite3_close(sqlite);
        return isOK;
    }
    else {
        //判断记录是否已存在且相同
        char *localPlatform = (char *)sqlite3_column_text(stmt, 1);
        char *localProduct = (char *)sqlite3_column_text(stmt, 2);
        float localCapital = sqlite3_column_double(stmt, 3);
        float localMinRate = sqlite3_column_double(stmt, 4);
        float localMaxRate = sqlite3_column_double(stmt, 5);
        char *localCalType = (char *)sqlite3_column_text(stmt, 6);
        char *localStartDate = (char *)sqlite3_column_text(stmt, 7);
        char *localEndDate = (char *)sqlite3_column_text(stmt, 8);
        int localState = sqlite3_column_int(stmt, 10);
        int localIsDeleted = sqlite3_column_int(stmt, 11);
        if (localIsDeleted != isDeleted) {
            flag = FALSE;
        }
        if (flag && localState != state) {
            flag = FALSE;
        }
        if (flag && ![[NSString stringWithCString:localPlatform encoding:NSUTF8StringEncoding] isEqualToString:platform]) {
            flag = FALSE;
        }
        if (flag && ![[NSString stringWithCString:localProduct encoding:NSUTF8StringEncoding] isEqualToString:product]) {
            flag = FALSE;
        }
        if (flag && localCapital != capital) {
            flag = FALSE;
        }
        if (flag && localMinRate != minRate) {
            flag = FALSE;
        }
        if (flag && localMaxRate != maxRate) {
            flag = FALSE;
        }
        if (flag && ![[NSString stringWithCString:localCalType encoding:NSUTF8StringEncoding] isEqualToString:calType]) {
            flag = FALSE;
        }
        if (flag && ![[NSString stringWithCString:localStartDate encoding:NSUTF8StringEncoding] isEqualToString:startDate]) {
            flag = FALSE;
        }
        if (flag && ![[NSString stringWithCString:localEndDate encoding:NSUTF8StringEncoding] isEqualToString:endDate]) {
            flag = FALSE;
        }
    }
    if (!flag) {
        //云上下载的投资记录和本地的内容不同，要覆盖本地的
        BOOL isOK = [self updateRecordFromCloud:platform secondPara:product thirdPara:capital forthPara:minRate fifthPara:maxRate sixthPara:calType seventhPara:startDate eighthPara:endDate ninthPara:timeStamp tenthPara:state eleventhPara:isDeleted withUserName:userName];
        sqlite3_close(sqlite);
        return isOK;
    }
    //关闭数据库句柄
    sqlite3_finalize(stmt);
    //关闭数据库
    sqlite3_close(sqlite);
    return YES;
}

- (BOOL)insertRecordFromCloud:(NSString*)platform secondPara:(NSString*)product thirdPara:(float)capital forthPara:(float)minRate fifthPara:(float)maxRate sixthPara:(NSString*)calType seventhPara:(NSString*)startDate eighthPara:(NSString*)endDate ninthPara:(long int)timeStamp tenthPara:(int)state eleventhPara:(int)isDeleted withUserName:(NSString*)userName
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt=nil;
    
    //数据库路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/p2p_basket.sqlite"];
    
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK)
    {
        NSLog(@"SQLite DB open error.");
        return NO;
    }
    
    //组合而成的sql语句，占位符坑爹啊！
    NSString *sql=[[NSString alloc]initWithFormat:@"INSERT INTO recordT VALUES(NULL,\"%@\",\"%@\",%f,%f,%f,\"%@\",\"%@\",\"%@\",%ld,%d,%d,\"%@\")",platform,product,capital,minRate,maxRate,calType,startDate,endDate,timeStamp,state,isDeleted,userName];
    //编译SQL语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if( result != SQLITE_OK){
        return NO;
    }
    
    result = sqlite3_step(stmt);
    
    if(result!=SQLITE_DONE)
        return NO;
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    return YES;
}

- (BOOL) updateRecordFromCloud:(NSString*)platform secondPara:(NSString*)product thirdPara:(float)capital forthPara:(float)minRate fifthPara:(float)maxRate sixthPara:(NSString*)calType seventhPara:(NSString*)startDate eighthPara:(NSString*)endDate ninthPara:(long int)timeStamp tenthPara:(int)state eleventhPara:(int)isDeleted withUserName:(NSString*)userName
{
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
    NSString *sql = @"update recordT set platform = ? and product = ? and capital = ? and minRate = ? and maxRate = ? and calType = ? and startDate = ? and endDate = ? and state = ? and isDeleted = ? WHERE timeStamp = ? AND userName = ?";
    //编译SQL语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"Error: failed to update:testTable");
        sqlite3_close(sqlite);
        return NO;
    }
    
    sqlite3_bind_text(stmt, 1, [platform UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [product UTF8String], -1, NULL);
    sqlite3_bind_double(stmt,3,capital);
    sqlite3_bind_double(stmt,4,minRate);
    sqlite3_bind_double(stmt,5,maxRate);
    sqlite3_bind_text(stmt, 6, [calType UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 7, [startDate UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 8, [endDate UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 10, state);
    sqlite3_bind_int(stmt, 11, isDeleted);
    sqlite3_bind_int64(stmt, 9, timeStamp);
    sqlite3_bind_text(stmt, 12, [userName UTF8String], -1, NULL);
    
    result = sqlite3_step(stmt);
    
    if( result == SQLITE_ERROR){
        NSLog(@"更新失败");
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









