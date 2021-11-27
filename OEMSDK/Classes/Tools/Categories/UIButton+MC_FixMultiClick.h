//
//  UIButton+MC_FixMultiClick.h
//  Project
//
//  Created by Li Ping on 2019/5/31.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (MC_FixMultiClick)

@property (nonatomic, assign) NSTimeInterval mc_acceptEventInterval; // 重复点击的间隔，默认0.5，设置为0也可以忽略
@property (nonatomic, assign) BOOL mc_ignoreMultiClick; //  可以连续点击

@end

NS_ASSUME_NONNULL_END
