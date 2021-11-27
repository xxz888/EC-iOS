//
//  MCDateStore.h
//  Project
//
//  Created by SS001 on 2019/6/10.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDateStore : NSObject


/**
 根据传入的时间，计算明天的时间

 @param aDateStr 时间 格式：2019-06-10
 @return 返回时间 格式：2019-06-10
 */
+ (NSString *)GetTomorrowDay:(NSString *)aDateStr;



/**
 yyyy-MM-dd HH:mm:ss 转换成 几分钟、小时、天前，超过6天显示日期

 @param str yyyy-MM-dd HH:mm:ss 格式字符串
 @return string
 */
+ (NSString *) compareCurrentTime:(NSString *)str;

+ (NSString *)getDateWithNumber:(NSInteger)number;

+ (NSString *)getYear;
+ (NSString *)getMonth;
// 获取当前几号
+ (NSInteger)getCurrentDay;
+ (NSInteger)getCurrentHour;
+ (NSString *)getUpperMonth:(NSInteger)month;
+ (NSString *)getNextMonth:(NSInteger)month;
+ (NSInteger)getNextDay:(NSInteger)day;
+ (NSString *)getUseYear:(NSInteger)month;
//比较两个日期
+(int)compareOneDay:(NSString *)billyyyyMMdd withAnotherDay:(NSString *)repayyyyMMdd;
//获取两个日期之间的所有日期，精确到天
+ (NSArray *)getDayArrayLeftDate:(NSString *)aLeftDateStr rightDate:(NSString *)aRightDateStr;
//计算今天后的第n天是几号
+(NSString *)getAfterDay:(NSInteger)days;
+(BOOL)date:(NSString *)selectString isBetweenDate:(NSDate*)beginDate andDate:(NSString *)endString;
@end

NS_ASSUME_NONNULL_END
