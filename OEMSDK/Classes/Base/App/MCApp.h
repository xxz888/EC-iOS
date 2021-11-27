//
//  MCApp.h
//  MCOEM
//
//  Created by wza on 2020/3/11.
//  Copyright © 2020 MingChe. All rights reserved.
//  提供app一些初始化的方法。

#import <Foundation/Foundation.h>
#import <JAnalytics/JANALYTICSService.h>
#import "MCUserInfo.h"
#import "MCAppDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCApp : NSObject

//初始化
+ (void)setup:(UIApplication *)application options:(NSDictionary *)launchOptions appDelegate:(MCAppDelegate*)appDelegate;


/// 随机一个host，并保存到NSUserdefault
+ (void)randomHost;


//极光推送设置别名，登录后调用
+ (void)setJPushAlias:(NSString *)alias;
//删除极光推送别名，退出登录调用
+ (void)deleteJPushAlias;

//设置极光统计用户信息，登录、实名后调用
+ (void)setJAnalyticsIdentifyAccount:(MCUserInfo *)userInfo;
//解绑极光统计用户，退出登录调用
+ (void)detachJAnalyticsAccount;


/// 用户登录，操作有：记录用户信息、设置极光别名、绑定极光统计用户
//+ (void)userLogin;
/// 退出登录，操作有：清空用户信息、删除极光推送别名、解绑极光统计用户
+ (void)userLogout;

@end

NS_ASSUME_NONNULL_END
