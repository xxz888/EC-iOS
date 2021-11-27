//
//  MCServiceAlert.h
//  Lianchuang_477
//
//  Created by wza on 2020/9/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCServiceAlert : NSObject

/// 下面弹出
/// @param types 同MCServiceStore中的
+ (void)showWithTypes:(NSArray *)types;
+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
