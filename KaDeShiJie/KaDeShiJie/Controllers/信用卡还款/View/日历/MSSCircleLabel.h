//
//  MSSCircleLabel.h
//  MSSCalendar
//
//  Created by 于威 on 16/4/4.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    MSSCircleLabelTypeNormal,
    MSSCircleLabelTypeSelected,
    MSSCircleLabelTypeZhangdan,
    MSSCircleLabelTypeHuankuan,
} MSSCircleLabelType;

@interface MSSCircleLabel : UILabel

@property (nonatomic,assign)MSSCircleLabelType type;


@property(nonatomic, assign) NSInteger currentMonth;

@end
