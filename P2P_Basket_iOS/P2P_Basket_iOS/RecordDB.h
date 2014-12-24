//
//  recordDB.h
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/29/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface RecordDB : NSObject
-(NSString *)getDataBasePath;
-(void)copyDatabaseIfNeeded;
-(NSInteger)insertRecord:(NSString*)platform secondPara:(NSString*)product thirdPara:(float)capital forthPara:(float)minRate
               fifthPara:(float)maxRate sixthPara:(NSString*)calType seventhPara:(NSString*)startDate eighthPara:(NSString*)endDate;
- (NSMutableArray *)getAllRecord:(BOOL) flag;
- (BOOL) updateRecord:(long int)timeStamp;
- (BOOL) coverLocalRecord:(NSString*)platform secondPara:(NSString*)product thirdPara:(float)capital forthPara:(float)minRate fifthPara:(float)maxRate sixthPara:(NSString*)calType seventhPara:(NSString*)startDate eighthPara:(NSString*)endDate ninthPara:(long int)timeStamp tenthPara:(int)state eleventhPara:(int)isDeleted;
@end

