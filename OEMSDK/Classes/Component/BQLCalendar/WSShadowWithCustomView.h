//
//  WSShadowWithCustomView.h
//  UITabbarController
//
//  Created by Apple on 2017/6/23.
//  Copyright © 2017年 qinmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QMWSMenuList.h"
@interface WSShadowWithCustomView : NSObject
/*!
	@method
	@abstract 将给定的自定义view添加到window，如果带有回掉请务必设置代理，视图tag为1002切勿重复
	@param customerview 自定义视图
	@discussion 回掉请务必设置代理
 */
+(void)showShadow:(UIView<QMWSMenuList>*)customerview withAlpha:(CGFloat)alpha withClips:(CGFloat)radius withFram:(CGRect)annifram;
+(void)hideShadow;
@end
