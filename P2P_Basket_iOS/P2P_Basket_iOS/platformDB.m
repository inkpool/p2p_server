//
//  platfromDB.m
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/23/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import "platformDB.h"

@implementation platformDB

-(NSString *)getDataBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES);
    NSString *dbPath = [paths objectAtIndex:0];
    return [dbPath stringByAppendingPathComponent:@"p2p_basket.sqlite"];
}

-(void)copyDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDataBasePath];
    NSLog(@"%@",dbPath);
    NSString *resPath;
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if(!success)
    {
        resPath = [[NSBundle mainBundle] pathForResource:@"p2p_basket" ofType:@"sqlite"];
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

-(NSMutableArray*)getField:(NSString *)field
{
    //检查有没有将数据库复制到沙盒library
    [self copyDatabaseIfNeeded];
    
    NSMutableArray * resultArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    NSLog(@"传入参数为%@",field);
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
        return resultArray;
    }
    
    //组合而成的sql语句，占位符坑爹啊！
    NSString *str1=@"SELECT DISTINCT ";
    NSString *tempsql =[str1 stringByAppendingString:field];
    NSString *sql=[tempsql stringByAppendingString:@" from productT"];
    
    //编译SQL语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if( result != SQLITE_OK){
        return resultArray;
    }
    
    
    //向SQL语句上的占位符绑定数据
    //sqlite3_bind_text(stmt, 1,"product",-1,nil);
    
    result = sqlite3_step(stmt);
    
    while(result== SQLITE_ROW){
        
        char *field_res = (char *)sqlite3_column_text(stmt, 0);
        
        NSString *field_NSres = [NSString stringWithCString:field_res encoding:NSUTF8StringEncoding];
        [resultArray addObject:field_NSres];
        
        NSLog(@"所查字段为 %@",field_NSres);
        
        result = sqlite3_step(stmt);
        
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    return resultArray;
}

-(NSMutableArray*)getProductFromOnePlatform:(NSString *)platform
{
    //检查有没有将数据库复制到沙盒library
    [self copyDatabaseIfNeeded];
    
    NSMutableArray * resultArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    NSLog(@"传入参数为%@",platform);
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
        return resultArray;
    }
    
    //组合而成的sql语句，占位符坑爹啊！
    NSString *str1=@"SELECT product FROM productT WHERE platform='";
    NSString *tempsql =[str1 stringByAppendingString:platform];
    NSString *sql = [tempsql stringByAppendingString:@"'"];
    
    //编译SQL语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if( result != SQLITE_OK){
        return resultArray;
    }
    
    
    //向SQL语句上的占位符绑定数据
    //sqlite3_bind_text(stmt, 1,"product",-1,nil);
    
    result = sqlite3_step(stmt);
    
    while(result== SQLITE_ROW){
        
        char *field_res = (char *)sqlite3_column_text(stmt, 0);
        
        NSString *field_NSres = [NSString stringWithCString:field_res encoding:NSUTF8StringEncoding];
        [resultArray addObject:field_NSres];
        
        NSLog(@"所查字段为 %@",field_NSres);
        
        result = sqlite3_step(stmt);
        
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    return resultArray;
}

-(NSMutableArray*)getRates:(NSString *)field1 secondPara:(NSString*)field2
{
    //检查有没有将数据库复制到沙盒library
    [self copyDatabaseIfNeeded];
    
    NSMutableArray * resultArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    NSLog(@"传入参数为%@ %@",field1,field2);
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
        return resultArray;
    }
    
    //组合而成的sql语句，占位符坑爹啊！
    NSString *sql=[[NSString alloc]initWithFormat:@"SELECT minRate,maxRate FROM productT WHERE platform=\"%@\" AND product=\"%@\"",field1,field2];
    NSLog(@"%@",sql);
    
    
    //编译SQL语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if( result != SQLITE_OK){
        return resultArray;
    }
    //向SQL语句上的占位符绑定数据
    //sqlite3_bind_text(stmt, 1,"product",-1,nil);
    
    result = sqlite3_step(stmt);
    
    while(result== SQLITE_ROW){
        //第一个值
        char *field_res = (char *)sqlite3_column_text(stmt, 0);
        NSString *field_NSres = [NSString stringWithCString:field_res encoding:NSUTF8StringEncoding];
        [resultArray addObject:field_NSres];
        NSLog(@"所查字段为 %@",field_NSres);
        
        //第二个值
        field_res = (char *)sqlite3_column_text(stmt, 1);
        field_NSres = [NSString stringWithCString:field_res encoding:NSUTF8StringEncoding];
        [resultArray addObject:field_NSres];
        NSLog(@"所查字段为 %@",field_NSres);
        
        result = sqlite3_step(stmt);
        
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    return resultArray;
    
}

-(NSMutableArray*)getDuration:(NSString *)field1 secondPara:(NSString*)field2
{
    //检查有没有将数据库复制到沙盒library
    [self copyDatabaseIfNeeded];
    
    NSMutableArray * resultArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    NSLog(@"传入参数为%@ %@",field1,field2);
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
        return resultArray;
    }
    
    //组合而成的sql语句，占位符坑爹啊！
    NSString *sql;
    sql=[sql initWithFormat:@"SELECT duration FROM productT WHERE platform=%@ AND product=%@",field1,field2];
    
    //编译SQL语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if( result != SQLITE_OK){
        return resultArray;
    }
    //向SQL语句上的占位符绑定数据
    //sqlite3_bind_text(stmt, 1,"product",-1,nil);
    
    result = sqlite3_step(stmt);
    
    while(result== SQLITE_ROW){
        //第一个值
        char *field_res = (char *)sqlite3_column_text(stmt, 0);
        NSString *field_NSres = [NSString stringWithCString:field_res encoding:NSUTF8StringEncoding];
        [resultArray addObject:field_NSres];
        NSLog(@"所查字段为 %@",field_NSres);
        
        
        result = sqlite3_step(stmt);
        
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    
    return resultArray;
    
}


@end
