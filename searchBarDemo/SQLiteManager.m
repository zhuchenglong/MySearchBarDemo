//
//  SQLiteManager.m
//  searchBarDemo
//
//  Created by zhuchenglong on 16/7/6.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import "SQLiteManager.h"
#import "FMDB.h"
#import "NSString+category.h"
#import "DataModel.h"

@implementation SQLiteManager
static FMDatabase *database;


//创建表格
+(BOOL)creatTableWithName:(NSString *)tableName{

    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path = [NSString stringWithFormat:@"%@.sqlite",tableName];
    
    NSString *sqlitePath = [documentPath stringByAppendingPathComponent:path];
    
    //创建数据库文件
    database = [FMDatabase databaseWithPath:sqlitePath];
    
    //打开数据库
    if ([database open]){
        
        //创建表
        NSString *creatStr = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key,dataContent text,pinyin text)",tableName];
        BOOL isSucess = [database executeUpdate:creatStr];
        if (isSucess) {
            NSLog(@"创建表格成功");
        }else{
            NSLog(@"创建表格失败");
        }
    }
    //关闭数据库
    [database close];
    
   return YES;
}

//插入数据
+(void)insertDataWithTableName:(NSString *)tableName dataArray:(NSArray *)dataArray{
    
    if ([SQLiteManager creatTableWithName:tableName]) {
        
        if ([database open]){
            
            for (DataModel *model in dataArray) {
                
                NSString *pinyin = [NSString transformToPinyin:model.content];
                
                //这里%@中如果是插入的字符串，一定要加''，否则数值类型错误
                NSString *update = [NSString stringWithFormat:@"insert into %@(dataContent,pinyin) values('%@','%@')",tableName,model.content,pinyin];
                
                BOOL isSucess = [database executeUpdate:update];
                
                if (isSucess){
                    NSLog(@"插入数据成功");
                }else{
                    NSLog(@"插入数据失败");
                }
            }
        }
    }
}

//查询数据
+(NSArray *)queryDataWithTableName:(NSString *)tableName keyword:(NSString *)keyword{
    
    
    NSMutableArray *resultArray = [NSMutableArray array];
    NSString *selectResult;
    if (keyword.length != 0 || keyword){
        
        selectResult = [NSString stringWithFormat:@"select * from %@ where pinyin like '#%%%@%%'",tableName, keyword];
    }else{
        selectResult = [NSString stringWithFormat:@"select * from %@",tableName];
    }

   
    if ([database open]) {
        
        // 先清空数组
        [resultArray removeAllObjects];
        
        //执行循环查询操作
        FMResultSet *resultSet = [database executeQuery:selectResult];

        while ([resultSet next]){
            
            DataModel *model = [DataModel new];
            model.content = [resultSet stringForColumn:@"dataContent"];
            model.pinyin = [resultSet stringForColumn:@"pinyin"];
           
            [resultArray addObject:model];
            
            }
        }
    
    [database close];
    
    return resultArray;
}

//清空所有数据

//清空数据
+ (void)clearAllDataWithTableName:(NSString *)tableName{
    
    if ([database open])
    {
        //不能直接在executeUpdate以%@的形式写
        NSString *deleteData = [NSString stringWithFormat:@"delete from %@",tableName];
        
        BOOL isSucess = [database executeUpdate:deleteData];
        if (isSucess)
        {
            NSLog(@"清除数据成功");
        }else{
             NSLog(@"清除失败%@",[database lastError]);
        
        }
    }
    
    //关闭数据库
    [database close];
}


@end
