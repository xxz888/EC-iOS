//
//  CalendarShowView.h
//  BQLCalendar
//
//  Created by sawu on 2018/8/29.
//  Copyright © 2018年 毕青林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QMWSMenuList.h"

@interface CalendarShowView : UIView<QMWSMenuList>

@property(nonatomic,copy) void(^selectItem)(NSInteger idx);

@property(nonatomic,copy) void(^viewTouch)();

@property(nonatomic,copy) NSString* state;

- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;

@end
