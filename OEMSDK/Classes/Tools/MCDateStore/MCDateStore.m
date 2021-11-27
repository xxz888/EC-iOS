//
//  MCDateStore.m
//  Project
//
//  Created by SS001 on 2019/6/10.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCDateStore.h"

@implementation MCDateStore


//传入今天的时间，返回明天的时间
+ (NSString *)GetTomorrowDay:(NSString *)aDateStr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *aDate = [dateFormatter dateFromString:aDateStr];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}


+ (NSString *) compareCurrentTime:(NSString *)str {
    
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <7){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else{
        result = [str substringToIndex:10];
    }
    
    return  result;
}

+ (NSString *)getDateWithNumber:(NSInteger)number
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:number];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getYear
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)getMonth
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    return [dateFormatter stringFromDate:date];
}
+ (NSInteger)getCurrentDay
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    return [[dateFormatter stringFromDate:date] integerValue];
}
+ (NSInteger)getCurrentHour
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    return [[dateFormatter stringFromDate:date] integerValue];
}
+ (NSString *)getUpperMonth:(NSInteger)month{
    if (month == 1) {
        return @"12";
    } else {
        return [NSString stringWithFormat:@"%02ld", month-1];
    }
}

+ (NSString *)getNextMonth:(NSInteger)month
{
    if (month == 12) {
        return @"01";
    } else {
        return [NSString stringWithFormat:@"%02ld", month+1];
    }
}
+ (NSString *)getUseYear:(NSInteger)month
{
    if (month == 12) {
        return [NSString stringWithFormat:@"%02ld", [[MCDateStore getYear] integerValue] + 1];
    } else {
        return [MCDateStore getYear];
    }
}
//传入今天的时间，返回明天的时间
+ (NSInteger)getNextDay:(NSInteger)day {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *aDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld", day]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"dd"];
    return [[dateday stringFromDate:beginningOfWeek] integerValue];
}

+(int)compareOneDay:(NSString *)billyyyyMMdd withAnotherDay:(NSString *)repayyyyMMdd{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:[dateFormatter dateFromString:billyyyyMMdd]];
    NSString *anotherDayStr = [dateFormatter stringFromDate:[dateFormatter dateFromString:repayyyyMMdd]];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //账单日在还款日之后
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    //账单日在还款日之前和还款日
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
             
}

//获取两个日期之间的所有日期，精确到天
+ (NSArray *)getDayArrayLeftDate:(NSString *)beginDateString rightDate:(NSString *)endDateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    // 计算两个时间的差值
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据 NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendarUnit unit = NSCalendarUnitDay;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:[dateFormatter dateFromString:beginDateString] toDate:[dateFormatter dateFromString:endDateString] options:0];
     
    // 两个日期之间所有天数组成的数组
    NSMutableArray *allDayArr = [NSMutableArray new];
    for (int i = 0 ; i < dateCom.day+1 ; i ++) {
        // n天后的天数
        int days = i;
        // 一天一共有多少秒
        NSTimeInterval oneDay = 24 * 60 * 60;
        // 指定的日期
        NSDate *appointDate = [NSDate dateWithTimeInterval:oneDay * days sinceDate:[dateFormatter dateFromString:beginDateString]];
        // 转字符串
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // @"yyyy-MM-dd"
        NSString *appointTime = [dateFormatter stringFromDate:appointDate];
        [allDayArr addObject:appointTime];
    }
    return allDayArr;
}
+(NSString *)getAfterDay:(NSInteger)days{
    //days n天后的天数
    NSTimeInterval oneDay = 24 * 60 * 60;  // 一天一共有多少秒
    NSDate * appointDate = [[NSDate date] initWithTimeIntervalSinceNow: oneDay * days];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:appointDate];
    return strDate;
}
+(BOOL)date:(NSString *)selectString isBetweenDate:(NSDate*)beginDate andDate:(NSString *)endString{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //选择的日
    NSDate * selectDate = [format dateFromString:selectString];
    //还款日
    NSDate * endDate = [format dateFromString:endString];
    if ([MCDateStore isToday:selectDate])
        return YES;
    if ([selectDate compare:beginDate] == NSOrderedAscending)
        return NO;
    if ([selectDate compare:endDate] == NSOrderedDescending)
        return YES;
    return YES;
}
//是否为今天
+ (BOOL)isToday:(NSDate *)date{
    //now: 2015-09-05 11:23:00
    //self 调用这个方法的对象本身

    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;

    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];

    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];

    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

@end
