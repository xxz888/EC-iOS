//
//  MCPayStore.h
//  MCOEM
//
//  Created by wza on 2020/5/7.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCPayStore : NSObject

+ (void)weixinPayWithAmount:(NSString *)amount productId:(NSString *)product_id orderDesc:(NSString *)order_desc channelTag:(NSString *)channelTag couponId:(nullable NSString *)coupon_id;
+ (void)aliPayWithAmount:(NSString *)amount productId:(NSString *)product_id orderDesc:(NSString *)order_desc channelTag:(NSString *)channelTag couponId:(nullable NSString *)coupon_id;
+ (void)yinlianPayWithAmount:(NSString *)amount productId:(NSString *)product_id orderDesc:(NSString *)order_desc channelTag:(NSString *)channelTag bankCard:(NSString *)bank_card couponId:(nullable NSString *)coupon_id;
+ (void)balancePayWithAmount:(NSString *)amount productId:(NSString *)product_id orderDesc:(NSString *)order_desc channelTag:(NSString *)channelTag couponId:(nullable NSString *)coupon_id;

@end

NS_ASSUME_NONNULL_END
