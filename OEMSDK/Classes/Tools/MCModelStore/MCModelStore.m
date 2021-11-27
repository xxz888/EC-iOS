//
//  MCModelStore.m
//  MCOEM
//
//  Created by wza on 2020/3/3.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCModelStore.h"
#import "MCRequestMannager.h"

static NSString *api_userinfo = @"/user/app/info/query";
static NSString *api_brandinfo = @"/user/app/brand/query/id";
static NSString *api_fenruninfo = @"/user/app/rebate/query/sumrebate";
static NSString *api_accountinfo = @"/user/app/account/query/";
static NSString *api_teamInfo = @"/user/app/query/userteam";


@implementation MCModelStore
static MCModelStore *_singleStore = nil;

+ (instancetype)shared {
    
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        if (_singleStore == nil) {
            _singleStore = [[self alloc] init];
        }
    });
    return _singleStore;
}


- (MCAppInfo *)appInfo {
    if (!_appInfo) {
        _appInfo = [[MCAppInfo alloc] init];
    }
    return _appInfo;
}
- (MCBrandConfiguration *)brandConfiguration {
    if (!_brandConfiguration) {
        _brandConfiguration = [[MCBrandConfiguration alloc] init];
    }
    return _brandConfiguration;
}

- (GVUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [GVUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (void)getInfos {
    [self reloadUserInfo:nil];
    [self reloadBrandInfo:nil];
}

- (void)reloadUserInfo:(void (^)(MCUserInfo *))handle {
    if (TOKEN) {
        [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"%@/%@",api_userinfo,TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull okResponse) {
            self.userInfo = [MCUserInfo mj_objectWithKeyValues:okResponse.result];
            self.userInfo.whether = okResponse.whether;
            MCModelStore.shared.preUserPhone = self.userInfo.preUserPhone;
            if (handle) {
                handle(self.userInfo);
            }
//            MCLog(@"获取个人信息成功");
        } other:^(MCNetResponse * _Nonnull resp) {
            
        }];
    }
    
}

/// 异步获取获取收益
/// @param handle handle
- (void)getSumRebate:(void (^_Nullable) (MCSumRebateModel *sumRebateModel))handle{
    [[MCSessionManager shareManager] mc_POST:api_fenruninfo parameters:@{@"user_id":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull okResponse) {
        MCSumRebateModel* model = [MCSumRebateModel mj_objectWithKeyValues:okResponse.result];
        if (handle) {
            handle(model);
        }
//        MCLog(@"获取收益成功");
    }];
}
- (void)getMyTeamInformation:(void (^)(MCTeamModel * teamModel))block {
    [[MCSessionManager shareManager] mc_POST:api_teamInfo parameters:@{@"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull okResponse) {
        MCTeamModel *model = [MCTeamModel mj_objectWithKeyValues:okResponse.result];
        block(model);
    }];
}
/// 异步获取获取用户账户信息（积分、余额、收益）
/// @param handle handle
- (void)getUserAccount:(void (^_Nullable) (MCAccountModel *accountModel))handle{
    
    NSString* url = [NSString stringWithFormat:@"%@%@",api_accountinfo,TOKEN];
    [[MCSessionManager shareManager] mc_GET:url parameters:@{} ok:^(MCNetResponse * _Nonnull okResponse) {
        MCAccountModel* model = [MCAccountModel mj_objectWithKeyValues:okResponse.result];
        if (handle) {
            handle(model);
        }
//        MCLog(@"获取账户信息（积分、余额、收益成功");
    }];
}

- (void)reloadBrandInfo:(void (^)(MCBrandInfo *))handle {
    [[MCSessionManager shareManager] mc_GET:api_brandinfo parameters:@{@"brand_id":self.brandConfiguration.brand_id} ok:^(MCNetResponse * _Nonnull okResponse) {
        self.brandInfo = [MCBrandInfo mj_objectWithKeyValues:okResponse.result];
        if (handle) {
            handle(self.brandInfo);
        }
//        MCLog(@"获取贴牌信息成功");
    }];
}
- (void)clearUserDefaults {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}



@end
