//
//  MCVerifyStore.h
//  MCOEM
//
//  Created by wza on 2020/5/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCVerifyStore : NSObject

/// 校验是否实名，是执行handler
/// @param handler 如果为nil则直接跳转实名
+ (void)verifyRealName:(nullable void(^)(MCUserInfo *userinfo))handler;


/// 版本号校验
+ (void)verifyVersionShowToast:(BOOL)show;


/// 对传入的字符串仅进行中文编码
/// @param url url
+ (NSString *)verifyURL:(NSString *)url;



@end

NS_ASSUME_NONNULL_END
