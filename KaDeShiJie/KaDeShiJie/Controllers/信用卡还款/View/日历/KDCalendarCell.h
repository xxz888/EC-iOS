//
//  KDCalendarCell.h
//  MCExample
//
//  Created by wza on 2020/9/23.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSCircleLabel.h"
#import "MSSCalendarHeaderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDCalendarCell : UICollectionViewCell

@property(nonatomic, strong) MSSCircleLabel *cLab;

@property(nonatomic, strong) MSSCalendarModel *model;
@property(nonatomic, assign) NSInteger repaymentMonth;
@property(nonatomic, assign) NSInteger currentMonth;
@property(nonatomic, assign) NSInteger repaymentDay;
@property(nonatomic, assign) NSInteger selectCurrent;


@end

NS_ASSUME_NONNULL_END
