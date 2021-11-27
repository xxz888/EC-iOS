//
//  MCServiceStore.h
//  MCOEM
//
//  Created by wza on 2020/4/2.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCServiceStore : NSObject

/// 跳转美洽客服页面
+ (void)pushMeiqiaVC;
/// 拨打电话
+ (void)callBrand;
/// 复制微信号并跳转
+ (void)jumpWeixin;
/// 复制QQ号并跳转
+ (void)jumpQQ;



+ (void)call:(NSString *)phone;



/// 弹出默认客服选项（0，1，2，3）
+ (void)popServiceSheet;
/// 弹出客服选项
/// @param type  0:美洽 1：电话客服 2：微信客服 3：QQ客服
+ (void)popServiceSheetTypes:(NSArray *)type;

@end

NS_ASSUME_NONNULL_END
