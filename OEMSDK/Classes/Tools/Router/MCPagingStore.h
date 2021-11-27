//
//  MCPagingStore.h
//  MCOEM
//
//  Created by wza on 2020/4/3.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCPagingStore : NSObject


/// 根据URL跳转
/// @param url MGJRouter里面注册的url
+ (void)pagingURL:( NSString * _Nullable )url;

/// 以push方式打开一个页面
/// @param url MGJRouter里面注册的url
/// @param info 参数
+ (void)pagingURL:(NSString *_Nullable)url withUerinfo:(NSDictionary *_Nullable)info;

/// present登录页
/// @param completion completion
+ (void)presentLoginViewController:(void(^ _Nullable)(void)) completion;

/// 跳转H5页面
/// @param title 标题
/// @param classification 分类
+ (void)pushWebWithTitle:(NSString *)title classification:(nullable NSString *)classification;

@end

NS_ASSUME_NONNULL_END
