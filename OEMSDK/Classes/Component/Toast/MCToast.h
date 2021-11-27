//
//  MCToast.h
//  MCOEM
//
//  Created by wza on 2020/3/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MCToastPosition) {
    MCToastPositionTop,         //顶部
    MCToastPositionCenter,      //中间
    MCToastPositionBottom       //底部
};

@interface MCToast : NSObject

/// 展示Toast 默认在底部
/// @param message msg
+ (void)showMessage:(NSString *)message;

/// 展示Toast
/// @param message msg
/// @param position 位置
+ (void)showMessage:(NSString *)message position:(MCToastPosition) position;

@end

NS_ASSUME_NONNULL_END
