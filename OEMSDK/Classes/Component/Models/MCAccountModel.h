//
//  MCAccountModel.h
//  Project
//
//  Created by Li Ping on 2019/7/30.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 账户模型，获取用户账户信息
 */
@interface MCAccountModel : NSObject

/**
 实名状态，0-审核中，1-已实名，2-实名失败，3-未实名
 */
@property (nonatomic, copy) NSString *realnameStatus;

/**
 实名状态（审核中，已实名，实名失败，未实名）
 */
@property (nonatomic, copy) NSString *realnameStatusName;
/**
 余额
 */
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *brandId;

/**
 积分
 */
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *freezeBalance;
@property (nonatomic, copy) NSString *freezerebateBalance;

/**
 收益余额
 */
@property (nonatomic, copy) NSString *rebateBalance;

/**
 总收益
 */
@property (nonatomic, copy) NSString *sumRebate;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *ID;

@end

NS_ASSUME_NONNULL_END
