//
//  NSString+category.h
//  FuzzySearch
//
//  Created by GM on 16/6/23.
//  Copyright © 2016年 GM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (category)

//获取汉字转成拼音字符串
+ (NSString *)transformToPinyin:(NSString *)aString;

@end
