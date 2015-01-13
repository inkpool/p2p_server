//
//  NewsDB.m
//  P2P_Basket_iOS
//
//  Created by xuxin on 15-1-6.
//  Copyright (c) 2015年 inkJake. All rights reserved.
//

#import "NewsDB.h"

@implementation NewsDB

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

- (NSInteger)insertNews:(long int)timeStamp withTitle:(NSString*)title withContent:(NSString*)content
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
    
    //组合而成的sql语句，占位符坑爹啊！
    NSString *sql=[[NSString alloc]initWithFormat:@"INSERT INTO newsT VALUES(%ld,\"%@\",\"%@\")",timeStamp,title,content];
    //编译SQL语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if( result != SQLITE_OK){
        return -1;
    }
    
    result = sqlite3_step(stmt);
    
    if(result!=SQLITE_DONE)
        return -1;
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    return 0;
}

//查询数据
- (NSMutableArray *)getAllNews {
    //检查有没有将数据库复制到沙盒library
    [self copyDatabaseIfNeeded];
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    NSMutableArray *newsArray = [[NSMutableArray alloc] init];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/p2p_basket.sqlite"];
    
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&sqlite);
    if (result != SQLITE_OK){
        NSLog(@"SQLite DB open error.");
        return NULL;
    }
    
    NSString *sql;
    //创建表的SQL语句
    sql=[[NSString alloc]initWithFormat:@"SELECT * FROM newsT"];
    //编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    //查询数据
    result = sqlite3_step(stmt);
    
    while (result == SQLITE_ROW) {
        long int timeStamp = sqlite3_column_int(stmt, 0);
        char *title = (char *)sqlite3_column_text(stmt, 1);
        char *content = (char *)sqlite3_column_text(stmt, 2);
        
        NSNumber *timeStampNumber = [[NSNumber alloc] initWithLong:timeStamp];
        NSString *titleString = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
        NSString *contentString = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:timeStampNumber,@"time_stamp",titleString,@"title",contentString,@"content", nil];
        [newsArray addObject:dic];
        
        result = sqlite3_step(stmt);
    }
    //NSLog(@"records:\n%@",records);
    
    //关闭数据库句柄
    sqlite3_finalize(stmt);
    
    //关闭数据库
    sqlite3_close(sqlite);
    
    return newsArray;
}

@end
