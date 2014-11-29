//
//  recordDB.m
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/29/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import "recordDB.h"

@implementation recordDB
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

-(NSInteger)insertRecord:(NSString*)platform secondPara:(NSString*)product thirdPara:(float)capital forthPara:(float)minRate
fifthPara:(float)maxRate sixthPara:(NSInteger)calType seventhPara:(NSString*)startDate eighthPara:(NSString*)endDate
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
    NSString *sql=[[NSString alloc]initWithFormat:@"INSERT INTO recordT VALUES(NULL,\"%@\",\"%@\",%f,%f,%f,%ld,\"%@\",\"%@\")",platform,product,capital,minRate,maxRate,calType,startDate,endDate];
    
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
@end


//insert into recordT values(null,'人人贷','U计划A',10000,7,14,1,'2014-1-1','2014-7-1');









