//
//  KDCalendarView.h
//  MCExample
//
//  Created by wza on 2020/9/23.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OEMSDK/OEMSDK.h>
#import "MSSCalendarHeaderModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^SureBlock)(NSMutableArray<MSSCalendarModel *>* models);

@interface KDCalendarView : UIView

@property(nonatomic, copy) SureBlock confirmBlock;

@property(nonatomic, strong) QMUIModalPresentationViewController *modalVC;
//还款月
@property (nonatomic, assign) NSInteger repaymentMonth;
//账单月
@property (nonatomic, assign) NSInteger billMonth;
//还款日
@property (nonatomic, assign) NSInteger repaymentDay;
//账单日
@property (nonatomic, assign) NSInteger billDay;
//至少需要的天数
@property (nonatomic, assign) NSInteger needDayCount;
@property (weak, nonatomic) IBOutlet UILabel *needDayLbl;
@property(nonatomic, assign) NSInteger selectCurrent;

@end

NS_ASSUME_NONNULL_END
