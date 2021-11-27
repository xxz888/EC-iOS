//
//  LoginAndRegistHTTPTools.h
//  MCOEM
//
//  Created by SS001 on 2020/3/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CallBack)(BOOL result);
typedef void(^GetBindCardSMSCallBack)(NSString * result);

@interface LoginAndRegistHTTPTools : NSObject

+ (void)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd remberPwd:(BOOL)remberPwd result:(CallBack)callback;

/** 发送验证码 */
+ (void)getSMS:(NSString *)phone;

+ (void)registWithParams:(NSDictionary *)params result:(CallBack)callback;

+ (void)getBrandInfo;

/** 发送绑卡确认验证码 */
+ (void)getBindCardSMS:(MCBankCardModel *)cardModel result:(GetBindCardSMSCallBack)callBack;
@end

NS_ASSUME_NONNULL_END
