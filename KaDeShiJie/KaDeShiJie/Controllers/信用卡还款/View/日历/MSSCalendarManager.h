//
//  MSSCalendarManager.h
//  MSSCalendar
//
//  Created by 于威 on 16/4/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MSSCalendarViewControllerType)
{
    MSSCalendarViewControllerLastType = 0,// 只显示当前月之前
    MSSCalendarViewControllerMiddleType,// 前后各显示一半
    MSSCalendarViewControllerNextType// 只显示当前月之后
};

@interface MSSCalendarManager : NSObject

- (instancetype)initWithShowChineseHoliday:(BOOL)showChineseHoliday showChineseCalendar:(BOOL)showChineseCalendar startDate:(NSInteger)startDate;
// 获取数据源
- (NSArray *)getCalendarDataSoruceWithLimitMonth:(NSInteger)limitMonth type:(MSSCalendarViewControllerType)type;


/// 根据目标月份获取 上月、当月、下月 三个月的数据
/// @param targetMonth 三个月数据
- (NSArray *)getCalendarDataSoruceWithTargetMonth:(NSInteger)targetMonth;


@property (nonatomic,strong)NSIndexPath *startIndexPath;

@end
