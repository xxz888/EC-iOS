//
//  NSString+HXString.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/22.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HXString)
//查找和替换
-(NSString *) replaceAll:(NSString *)str target:(NSString *)target;
//对应位置插入
-(NSString *) insertAt:(NSString *)str post:(NSUInteger)post;
//字符串查找
-(NSUInteger) indexOf:(NSString *)str;
//尾部位置追加
-(NSString *) append:(NSString *)str;
//头部位置插入
-(NSString *) concate:(NSString *)str;
//对应字符分割
-(NSArray *) split:(NSString *)split;
//去除多余的空白字符
-(NSString *) trim;
//去除多余的特定字符
-(NSString *) trim:(NSString *)trim;
//去除左边多余的空白字符
-(NSString *) trimLeft;
//去除左边多余的特定字符
-(NSString *) trimLeft:(NSString *)trim;
//去除右边多余的空白字符
-(NSString *) trimRight;
//去除右边多余的特定字符
-(NSString *) trimRight:(NSString *)trim;

//取得字符串的左边特定字符数
-(NSString *) left:(NSUInteger)num;
//取得字符串的右边特定字符数
-(NSString *) right:(NSUInteger)num;
//取得字符串的左边右边特定字符数
-(NSString *) left:(NSUInteger) left right:(NSUInteger) right;
//取得字符串的右边左边特定字符数
-(NSString *) right:(NSUInteger) right left:(NSUInteger) left;

/**
 * 是否包含 emoji 表情
 */
-(BOOL)containsEmoji;

/**
 * 是否包含某个字符串
 */
- (BOOL)contains:(NSString *)text;

/**
 * text 为nil 替换为当前字符
 * IIF(text == nil, self, text)
 */
- (NSString *)nilForReplace:(NSString *)text;

/**
 * 是否为空 包括 nil, NSNull, @""
 */
+ (BOOL)isEmpty:(NSString *)text;

/**
 * 判断是否为NSString,并判断是否相同字符串
 */
- (BOOL)equalToString:(id)source;

/**
 * 判断是否为Dictionary,并判断是否相同字符串
 */
- (BOOL)equalToDictionaryTag:(NSString *)tag source:(id)source;

/**
 * 如果为空替换
 */
- (NSString *)emptyForReplace:(NSString *)text;

/**
 * 是否为空格
 */
+ (BOOL)isSpace:(NSString *)text;


+ (NSString *)toJSONData:(id)theData;
+ (id)toArrayOrNSDictionary:(NSString *)jsonData;
@end

NS_ASSUME_NONNULL_END
