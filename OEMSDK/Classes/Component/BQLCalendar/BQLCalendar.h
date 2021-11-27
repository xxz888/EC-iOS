//
//  BQLCalendar.h
//  BQLCalendar
//
//  Created by 毕青林 on 16/3/18.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^calendarBlock)(NSString *date);

@interface BQLCalendar : UIView

@property (nonatomic, copy) calendarBlock block;


- (void)initSign:(NSArray *)signArray Touch:(calendarBlock )block withWantMonth:(NSString*)formatDate;

// sign today
- (void)signToday;

@end
