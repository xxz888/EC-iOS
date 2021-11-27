//
//  KDLoginTool.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/26.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDLoginTool : NSObject

+ (instancetype)shareInstance;
//isHandLogin YES 手动登录  NO自动登录
- (void)getChuXuCardData:(BOOL)isHandLogin;
- (void)requestPlatform:(BOOL)isHandLogin;
@end

NS_ASSUME_NONNULL_END
