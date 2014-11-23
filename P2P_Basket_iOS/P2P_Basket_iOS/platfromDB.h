//
//  platfromDB.h
//  P2P_Basket_iOS
//
//  Created by inkJake on 11/23/14.
//  Copyright (c) 2014 inkJake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface platfromDB : NSObject
-(NSMutableArray*)getFields:(NSString *)field;
-(NSMutableArray*)getProductFromOnePlatform:(NSString *)field;

@end
