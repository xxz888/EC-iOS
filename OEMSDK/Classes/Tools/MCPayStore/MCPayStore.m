//
//  MCPayStore.m
//  MCOEM
//
//  Created by wza on 2020/5/7.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCPayStore.h"
#import "MCWebViewController.h"
 
@implementation MCPayStore

+ (void)weixinPayWithAmount:(NSString *)amount productId:(NSString *)product_id orderDesc:(NSString *)order_desc channelTag:(NSString *)channelTag couponId:(NSString *)coupon_id {
    [self WXALIWithAmount:amount productId:product_id orderDesc:order_desc channelTag:channelTag couponId:coupon_id];
}
+ (void)aliPayWithAmount:(NSString *)amount productId:(NSString *)product_id orderDesc:(NSString *)order_desc channelTag:(NSString *)channelTag couponId:(NSString *)coupon_id {
    [self WXALIWithAmount:amount productId:product_id orderDesc:order_desc channelTag:channelTag couponId:coupon_id];
}
+ (void)yinlianPayWithAmount:(NSString *)amount productId:(NSString *)product_id orderDesc:(NSString *)order_desc channelTag:(NSString *)channelTag bankCard:(NSString *)bank_card couponId:(NSString *)coupon_id {
    
    NSString *phone      = SharedUserInfo.phone;
    NSDictionary *gatheringDic = @{@"amount":[NSString stringWithFormat:@"%.2f", amount.floatValue], @"order_desc":order_desc, @"phone":phone, @"channe_tag":channelTag, @"bank_card":bank_card, @"brand_id":SharedConfig.brand_id,@"product_id":product_id};
    
    NSMutableDictionary *md = [[NSMutableDictionary alloc] initWithDictionary:gatheringDic];
    if (coupon_id && coupon_id.length > 0) {
        [md setObject:coupon_id forKey:@"coupon_id"];
        [md setObject:@"2" forKey:@"difference"];
    }
    
    [MCSessionManager.shareManager mc_POST:@"" parameters:md ok:^(MCNetResponse * _Nonnull resp) {
        if (resp.result && [resp.result isKindOfClass:[NSString class]]) {
            [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp.result}];
        } else {
            [MCToast showMessage:@"支付出错，请稍后再试"];
        }
    }];
    
    
}
+ (void)balancePayWithAmount:(NSString *)amount productId:(NSString *)product_id orderDesc:(NSString *)order_desc channelTag:(NSString *)channelTag couponId:(nullable NSString *)coupon_id {
    QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"温馨提示" message:@"您确认使用账户余额进行升级?" preferredStyle:QMUIAlertControllerStyleAlert];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"考虑一下" style:QMUIAlertActionStyleCancel handler:nil]];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        
        NSString *phone      = SharedUserInfo.phone;
        NSDictionary *gatheringDic = @{@"amount":[NSString stringWithFormat:@"%.2f", amount.floatValue],
                                       @"order_desc":order_desc,
                                       @"phone":phone,
                                       @"channe_tag":channelTag,
                                       @"brandId":SharedConfig.brand_id,
                                       @"product_id":product_id};
        
        NSMutableDictionary *md = [[NSMutableDictionary alloc] initWithDictionary:gatheringDic];
        if (coupon_id && coupon_id.length > 0) {
            [md setObject:coupon_id forKey:@"coupon_id"];
            [md setObject:@"2" forKey:@"difference"];
        }
        
        [MCSessionManager.shareManager mc_POST:@"/facade/app//purchase/" parameters:md ok:^(MCNetResponse * _Nonnull resp) {
            [MCToast showMessage:resp.messege];
        }];
        
    }]];
    [alert showWithAnimated:YES];
}






+ (void)WXALIWithAmount:(NSString *)amount productId:(NSString *)product_id orderDesc:(NSString *)order_desc channelTag:(NSString *)channelTag couponId:(NSString *)coupon_id {
    
    NSString *url = [NSString stringWithFormat:@"%@/v1.0/facade/app/purchase/aliandwx?brandId=%@&phone=%@&amount=%.2f&order_desc=%@&product_id=%@&channe_tag=%@&token=%@", SharedDefaults.host, SharedConfig.brand_id, SharedUserInfo.phone, amount.floatValue, order_desc, product_id, channelTag, TOKEN];
    NSMutableString *mu = [NSMutableString stringWithString:url];
    if (coupon_id && coupon_id.length > 0) {
        [mu appendString:[NSString stringWithFormat:@"&coupon_id=%@&difference=%@",coupon_id,@"2"]];
    }
    
    [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":mu}];
}

@end
