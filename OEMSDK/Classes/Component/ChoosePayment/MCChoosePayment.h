//
//  MCChoosePayment.h
//  Project
//
//  Created by Li Ping on 2019/6/3.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCPaymentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MCChoosePaymentType) {
    MCChoosePaymentAliPay = 1,
    MCChoosePaymentWXPay,
    MCChoosePaymentYinlian,
    MCChoosePaymentBalance
};

@interface MCChoosePayment : NSObject

//代付
+ (void)payForWithAmount:(double)amount productId:(NSString *)product_id productName:(NSString *)name couponId:(NSString *)coupon_id payForPhone:(NSString *)payForPhone;


//从接口获取支付方式
+ (void)popAlertBeforeShowWithAmount:(double)amount productId:(NSString *)product_id productName:(NSString *)name couponId:(nullable NSString *)coupon_id;

//指定方式
+ (void)popAlertBeforeShowWithTypes:(NSArray<NSNumber *>*)types amount:(double)amount productId:(NSString *)product_id productName:(NSString *)name couponId:(nullable NSString *)coupon_id;






@end














@interface MCChoosePaymentController : UIViewController

@property(nonatomic, copy) NSString *payForPhone;

- (instancetype)initWithTypes:(NSArray<MCPaymentModel*>*)types amount:(double)amount productId:(NSString*)product_id couponId:(NSString *)coupon_id;

@end


NS_ASSUME_NONNULL_END
