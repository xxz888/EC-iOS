//
//  MCSumRebateModel.h
//  Project
//
//  Created by Li Ping on 2019/6/28.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 收益模型
 */
@interface MCSumRebateModel : NSObject

/**
 当月收益
 */
@property (nonatomic, copy) NSString *monthRebate;

/**
 昨日收益
 */
@property (nonatomic, copy) NSString *yesterdayRebate;

/**
 全部收益
 */
@property (nonatomic, copy) NSString *allRebate;

/**
 今日收益
 */
@property (nonatomic, copy) NSString *todayRebate;

@end

NS_ASSUME_NONNULL_END
