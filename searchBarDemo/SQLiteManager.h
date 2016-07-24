//
//  SQLiteManager.h
//  searchBarDemo
//
//  Created by zhuchenglong on 16/7/6.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface SearchResultModel : NSObject
//@property(nonatomic,strong)NSString *content;
//@property(nonatomic,strong)NSString *pinyin;
//@end




@interface SQLiteManager : NSObject
//插入数据
+(void)insertDataWithTableName:(NSString *)tableName dataArray:(NSArray *)dataArray;

//查询数据
+(NSArray *)queryDataWithTableName:(NSString *)tableName keyword:(NSString *)keyword;

//清空所有数据
+ (void)clearAllDataWithTableName:(NSString *)tableName;

@end
