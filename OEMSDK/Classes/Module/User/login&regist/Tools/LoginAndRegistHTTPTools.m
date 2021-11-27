//
//  LoginAndRegistHTTPTools.m
//  MCOEM
//
//  Created by SS001 on 2020/3/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "LoginAndRegistHTTPTools.h"
#import "MCApp.h"
#import <JPush/JPUSHService.h>

@implementation LoginAndRegistHTTPTools

+ (void)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd remberPwd:(BOOL)remberPwd result:(nonnull CallBack)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];
    [params setValue:pwd forKey:@"password"];
    [params setValue:MCModelStore.shared.brandConfiguration.brand_id forKey:@"brand_id"];
    [[MCSessionManager shareManager] mc_POST:@"/user/app/login" parameters:params ok:^(MCNetResponse * _Nonnull okResponse) {
        // 1.保存账号密码
        MCModelStore.shared.userDefaults.phone = phone;
        MCModelStore.shared.userDefaults.pwd = remberPwd ? pwd : @"";
        
        // 2.保存登录信息
        NSDictionary *result = okResponse.result;
        TOKEN = result[@"userToken"];
        MCModelStore.shared.preUserPhone = result[@"preUserPhone"];
        
//        // 3.改变是否是第一次启动
//        MCModelStore.shared.userDefaults.not_first_launch = YES;
//        // 4.获取贴牌信息
//        [self getBrandInfo];
        
        
        [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
            
            // 5.绑定推送别名
            NSString *userid = [NSString stringWithFormat:@"%@",userInfo.userid];
            [MCApp setJPushAlias:userid];
            [MCApp setJAnalyticsIdentifyAccount:userInfo];
            
            if (callback) {
                callback(YES);
            } else {
                if (BCFI.block_login) {
                    BCFI.block_login(okResponse);
                } else {
                    SharedDefaults.not_auto_logonin = YES;
                    [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
                }
            }
        }];
        
        
    }];
}

+ (void)getBrandInfo{
    [MCModelStore.shared reloadBrandInfo:nil];
}
+ (void)setupPushAlias
{
    NSString *alias = MCModelStore.shared.userInfo.userid;
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        MCLog(@"iAlias:%@",iAlias);
    } seq:999];
}

/** 发送验证码 */
+ (void)getSMS:(NSString *)phone
{
    NSDictionary *params = @{@"phone":phone, @"brand_id":MCModelStore.shared.brandConfiguration.brand_id};
    [[MCSessionManager shareManager] mc_GET:@"/notice/app/sms/send" parameters:params ok:^(MCNetResponse * _Nonnull okResponse) {
        
    }];
}

+ (void)registWithParams:(NSDictionary *)params result:(CallBack)callback
{
    [[MCSessionManager shareManager] mc_POST:@"/user/app/register" parameters:params ok:^(MCNetResponse * _Nonnull okResponse) {
        if ([okResponse.code isEqualToString:@"000000"]) {
            callback(YES);
        }
    }];
}

/** 发送绑卡确认验证码 */
+ (void)getBindCardSMS:(MCBankCardModel *)cardModel result:(GetBindCardSMSCallBack)callBack{
    NSDictionary *params =
    @{
        @"bankName":cardModel.bankName,
        @"bankCard":cardModel.cardNo,
        @"userName":cardModel.userName,
        @"idCard":cardModel.idcard,
        @"phone":cardModel.phone,
        @"orderCode":cardModel.orderCode,
        @"expiredTime":cardModel.expiredTime,
        @"securityCode":cardModel.securityCode,
     };
    
    
    [[MCSessionManager shareManager] mc_POST:@"/paymentgateway/topup/dy/bindCardMsg" parameters:params ok:^(MCNetResponse * _Nonnull okResponse) {
        if (callBack) {
            callBack(okResponse.messege);
        }
    }];
}
@end
