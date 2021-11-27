//
//  MCModelStore.h
//  MCOEM
//
//  Created by wza on 2020/3/3.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCAppInfo.h"
#import "MCUserInfo.h"
#import "MCBrandConfiguration.h"
#import "GVUserDefaults+MCOEM.h"
#import "MCTeamModel.h"
#import "MCBrandInfo.h"
#import "MCSumRebateModel.h"
#import "MCAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

#define SharedConfig MCModelStore.shared.brandConfiguration
#define SharedAppInfo MCModelStore.shared.appInfo
#define SharedBrandInfo MCModelStore.shared.brandInfo
#define SharedUserInfo MCModelStore.shared.userInfo
#define SharedDefaults MCModelStore.shared.userDefaults

@interface MCModelStore : NSObject

+ (instancetype) shared;

/// 异步获取 用户、贴牌信息
- (void)getInfos;

/// 异步获取用户信息，并同步本地的
/// @param handle handle
- (void)reloadUserInfo:(void (^_Nullable) (MCUserInfo *userInfo))handle;

/// 异步获取获取收益
/// @param handle handle
- (void)getSumRebate:(void (^_Nullable) (MCSumRebateModel *sumRebateModel))handle;
- (void)getMyTeamInformation:(void(^)(MCTeamModel *model))block;
/// 异步获取获取用户账户信息（积分、余额、收益）
/// @param handle handle
- (void)getUserAccount:(void (^_Nullable) (MCAccountModel *accountModel))handle;

/// 异步获取贴牌信息，并同步本地的
/// @param handle handle
- (void)reloadBrandInfo:(void (^_Nullable) (MCBrandInfo *brandInfo))handle;

/// 清空NSUserdefault
- (void)clearUserDefaults;

//  单例保存这些信息
/// app信息
@property (nonatomic, strong) MCAppInfo *appInfo;
/// 用户信息
@property (nonatomic, strong) MCUserInfo *userInfo;
/// 配置信息
@property (nonatomic, strong) MCBrandConfiguration *brandConfiguration;
/// 贴牌信息
@property(nonatomic, strong) MCBrandInfo *brandInfo;
/// NSUserdefault
@property (nonatomic, strong) GVUserDefaults *userDefaults;

/// 推荐人号码
@property(nonatomic, copy) NSString *preUserPhone;

@property(nonatomic, assign) BOOL updateViewIsShow;

@end

NS_ASSUME_NONNULL_END
