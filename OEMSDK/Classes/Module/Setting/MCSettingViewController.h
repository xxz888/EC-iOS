//
//  MCSettingViewController.h
//  MCOEM
//
//  Created by wza on 2020/4/15.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"

extern NSString * _Nonnull const MCSettingItemVersionCheck; //版本更新
extern NSString * _Nonnull const MCSettingItemVoice;        //语音播报
extern NSString * _Nonnull const MCSettingItemClearCache;   //清除缓存
extern NSString * _Nonnull const MCSettingItemCountSafe;    //账户安全
extern NSString * _Nonnull const MCSettingItemAboutUs;      //关于我们


NS_ASSUME_NONNULL_BEGIN



@interface MCSettingViewController : MCBaseViewController

/// 通过包含项的数组来实例化，MCBrandConfiguration中默认是（版本更新、清除缓存、账户安全、关于我们）
/// @param items items
- (instancetype)initWithSettingItems:(nullable NSArray<NSString *>*)items;

@end

NS_ASSUME_NONNULL_END
