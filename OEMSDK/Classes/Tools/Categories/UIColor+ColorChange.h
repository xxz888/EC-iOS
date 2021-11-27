//
//  UIColor+ColorChange.h
//  Project
//
//  Created by 熊凤伟 on 2017/12/25.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

/** 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB) */
+ (UIColor *)colorWithHexString: (NSString *)color;
/** 设置渐变色 */
+ (CAGradientLayer *)setGraduaChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
/** 从图片中获取颜色 */
+ (UIColor *)colorWithPicture:(UIImage *)image point:(CGPoint)point;
/** 根据图片获取图片的主色调 */
+ (UIColor *)getMainColorWitImage:(UIImage*)image;

@end
