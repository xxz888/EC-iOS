//
//  KDBindChannelManager.m
//  OEMSDK
//
//  Created by apple on 2020/12/16.
//

#import "KDBindChannelManager.h"
@implementation KDBindChannelManager
+ (instancetype)sharedConfig {
    static dispatch_once_t oneceToken;
    static KDBindChannelManager * provinceCityManager = nil;
    dispatch_once(&oneceToken, ^{
        if (provinceCityManager == nil) {
            provinceCityManager = [[self alloc] init];
        }
    });
    return provinceCityManager;
}


#pragma mark -----------------------多通道设置，获取所有信用卡信息---------------------
-(void)getAllXinYongKaList{
    kWeakSelf(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [[MCSessionManager manager] mc_POST:@"/creditcardmanager/app/get/creditcard/by/userid/new" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        NSArray * directModelArray = [KDDirectRefundModel1 mj_objectArrayWithKeyValuesArray:resp.result];
        for (KDDirectRefundModel1 * model in directModelArray) {
            if ([model.cardNo isEqualToString:weakself.creditCardNumber]) {
                weakself.directRefundModel = model;
                break;
            }
        }
        [weakself requestAllChuXuKaList];
    }];
}
#pragma mark -----------------------多通道设置，获取所有储蓄卡信息---------------------
- (void)requestAllChuXuKaList {
    kWeakSelf(self);
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/user/app/bank/query/userid/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (MCBankCardModel *model in temArr) {
            if ([model.nature containsString:@"借"]) {
                if (model.idDef) {
                    weakself.mcBankCardmodel = model;
                    break;
                }
            }
        }
        [weakself isChannelBind];
    }];
}
#pragma mark -----------------------多通道设置，查询是否有可绑定的通道---------------------
-(void)isChannelBind{
    if (self.directRefundModel && self.mcBankCardmodel) {
        NSDictionary * dic = @{
                               @"bankCard":self.directRefundModel.cardNo,
                               @"idCard":SharedUserInfo.idcard,
                               @"phone":self.directRefundModel.phone,
                               @"userName":self.directRefundModel.userName,
                               @"bankName":self.directRefundModel.bankName,
                               @"expiredTime":self.directRefundModel.expiredTime,
                               @"securityCode":self.directRefundModel.securityCode,
                               
                               @"dbankCard":self.mcBankCardmodel.cardNo,
                               @"dphone":self.mcBankCardmodel.phone,
                               @"dbankName":self.mcBankCardmodel.bankName,
                               
                               @"userId":SharedUserInfo.userid,
                               @"loginPhone":SharedUserInfo.phone
                            };
        kWeakSelf(self);
        [[MCSessionManager shareManager] mc_POST:@"/paymentgateway/isChannelBind" parameters:dic ok:^(MCNetResponse * _Nonnull resp) {
            //查询是否有多通道
            if (resp.result && [resp.result allKeys] != 0) {
                weakself.getSmsUrl = resp.result[@"getSmsUrl"];
                weakself.confirmSmsUrl = resp.result[@"confirmSmsUrl"];
                weakself.channelTag = resp.result[@"channelTag"];
                [weakself channelAction];
            }else{
                [weakself saveSuccessJumpVC];
            }
        }other:^(MCNetResponse * _Nonnull resp) {
         
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }else{
        [self saveSuccessJumpVC];
    }

}

#pragma mark -----------------------多通道设置，公用参数方法---------------------
-(NSMutableDictionary *)getSameParamers{
    NSDictionary * dic = @{@"bankCard":self.directRefundModel.cardNo,
                           @"idCard":SharedUserInfo.idcard,
                           @"phone":self.directRefundModel.phone,
                           @"userName":self.directRefundModel.userName,
                           @"bankName":self.directRefundModel.bankName,
                           @"expiredTime":self.directRefundModel.expiredTime,
                           @"securityCode":self.directRefundModel.securityCode,
                           @"channelTag":self.channelTag,
                           @"userId":SharedUserInfo.userid,
                           };
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
#pragma mark -----------------------多通道设置，发送按钮方法---------------------
-(void)sendSms{
    kWeakSelf(self);
    if (self.getSmsUrl.length == 0) {
        [MCToast showMessage: @"此卡已绑定该通道"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //如果绑定完所有卡，就跳转列表界面
            [weakself saveSuccessJumpVC];
        });
        return;
    }
    [[MCSessionManager shareManager] mc_POST:self.getSmsUrl parameters:[self getSameParamers] ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.messege isEqualToString:@"绑卡成功"]) {
            [MCToast showMessage:@"此卡已绑定该通道"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //如果绑定完所有卡，就跳转列表界面
                [weakself saveSuccessJumpVC];
            });
        }
    }];
}
#pragma mark -----------------------多通道设置，确认按钮方法---------------------
-(void)confirmSms{
    if (self.commonAlert.codeTf.text.length == 0) {
        [MCToast showMessage: @"请填写验证码"];
        return;
    }
    if (self.confirmSmsUrl.length == 0) {
        [MCToast showMessage: @"请先获取验证码"];
        return;
    }
    kWeakSelf(self);
    NSMutableDictionary * dic = [self getSameParamers];
    [dic setValue:self.commonAlert.codeTf.text forKey:@"smsCode"];
    NSString * confirmUrl = [self.confirmSmsUrl replaceAll:@"/v1.0" target:@""];
    [[MCSessionManager shareManager] mc_POST:confirmUrl parameters:dic ok:^(MCNetResponse * _Nonnull resp) {
            [weakself saveSuccessJumpVC];
    }];
}
#pragma mark -----------------------多通道设置方法---------------------
- (void)channelAction{
    kWeakSelf(self);
    if (!self.commonAlert) {
        self.commonAlert = [KDChannelView newFromNib];
    }
    if (!self.presentAlert) {
        self.presentAlert = [[QMUIModalPresentationViewController alloc]init];
    }
    self.presentAlert.contentView = self.commonAlert;
    self.presentAlert.dimmingView.userInteractionEnabled = NO;
    [self.presentAlert showWithAnimated:YES completion:nil];
    self.commonAlert.closeBtn.hidden = NO;
    self.commonAlert.closeActionBlock = ^{
        [weakself saveSuccessJumpVC];
    };
    self.commonAlert.sendBtnActionBlock = ^{
        [weakself sendSms];
    };
    self.commonAlert.bindBtnActionBlock = ^{
        [weakself confirmSms];
    };
}
#pragma mark ---------------空卡鉴权成功后，跳转空卡列表界面,信用卡鉴权成功，要查询是否有其它通道可绑定 111-------------------
-(void)saveSuccessJumpVC{
    if (self.presentAlert) {
        [self.presentAlert hideWithAnimated:YES completion:nil];
    }
    //这里是确认收款后，跳转收款界面，多做了一个判断防止闪退
    if ([[MCLATESTCONTROLLER.navigationController viewControllers] count] > 1) {
        [MCLATESTCONTROLLER.navigationController popToViewController:[MCLATESTCONTROLLER.navigationController viewControllers][1] animated:YES];
    }else{
        [MCLATESTCONTROLLER.navigationController popToRootViewControllerAnimated:YES];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MCToast showMessage:@"计划制定成功"];
    });
}
@end
