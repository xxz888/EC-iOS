//
//  MCGradientView.h
//  Project
//
//  Created by Li Ping on 2019/8/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MCGradientView : UIView

/// 开始位置默认（0,0）
@property(nonatomic, assign) CGPoint startPoint;
/// 结束位置默认（1,0）
@property(nonatomic, assign) CGPoint endPoint;


/*======================设置两种颜色，或者设置主色调然后通过饱和度来跳转==================================*/
/// 开始颜色 默认比主题色稍浅的颜色
@property(nonatomic, strong) UIColor *startColor;
/// 结束颜色 默认比主体色稍深的颜色
@property(nonatomic, strong) UIColor *endColor;



/*======================设置两种颜色，或者设置主色调然后通过饱和度来跳转==================================*/
/// 主色调，设置该值时 startColor、endColor 就不要设置了
@property(nonatomic, strong) UIColor *mainColor;
/// 起始饱和度，默认0.8
@property(nonatomic, assign) CGFloat startSaturation;
/// 结束饱和度，默认1.1
@property(nonatomic, assign) CGFloat endSaturation;



/// 设置完属性后手动更新外观
- (void)reloadAppearance;

@end

NS_ASSUME_NONNULL_END
