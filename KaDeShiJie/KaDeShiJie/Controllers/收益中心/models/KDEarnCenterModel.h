//
//  KDEarnCenterModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/17.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDEarnCenterModel : NSObject

@property (nonatomic, copy) NSString *usableWithdrawAmount;
@property (nonatomic, copy) NSString *todayRebate;
@property (nonatomic, copy) NSString *monthRebate;

@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *rebateBalance;
@property (nonatomic, copy) NSString *activateCount;



/*
 "activateCount": 4,        //激活人数
 "totalAmount": 860.57,  //累积收益
 "balance": 0.69,             //分润余额
 "rebateBalance": 0.59,   //推广余额
 "todayRebate": 0,          //当日
 "monthRebate": 0         //当月
 **/
@end

NS_ASSUME_NONNULL_END
