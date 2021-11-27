//
//  KDProfitDirectPushModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/18.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDProfitDirectPushModel : NSObject
/** 分润金额 */
@property (nonatomic, assign) CGFloat rebate;
/** 交易金额 */
@property (nonatomic, assign) CGFloat tradeAmount;
@property (nonatomic, strong) NSString *tradeTime;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *status;


@end

NS_ASSUME_NONNULL_END
