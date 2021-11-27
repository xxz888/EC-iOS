//
//  UIImage+ChangeColor.h
//  SmallGowildClient
//
//  Created by Teehom on 16/3/25.
//  Copyright © 2016年 Teehom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GradientType) {
    GradientFromTopToBottom = 1,            //从上到下
    GradientFromLeftToRight,                //从做到右
    GradientFromLeftTopToRightBottom,       //从左上到右下
    GradientFromLeftBottomToRightTop        //从左下到右上
};

@interface UIImage (Color)

/** 修改图片颜色 */
- (UIImage *)imageWithColor:(UIColor *)color;
/** 修改图片大小 */
- (UIImage *)scaleToSize:(CGSize)newsize;

/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize        要生成的图片的大小
 *  @param colorArr         渐变颜色的数组
 *  @param percents         渐变颜色的占比数组
 *  @param gradientType     渐变色的类型
 */
- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colorArr percentage:(NSArray *)percents gradientType:(GradientType)gradientType;
/**
 *  @brief  根据颜色生成纯色图片
 *
 *  @param color 颜色
 *
 *  @return 纯色图片
 */
+ (UIImage *)LY_imageWithColor:(UIColor *)color;
/**
 *  @brief  取图片某一点的颜色
 *
 *  @param point 某一点
 *
 *  @return 颜色
 */
- (UIColor *)LY_colorAtPoint:(CGPoint )point;
//more accurate method ,colorAtPixel 1x1 pixel
/**
 *  @brief  取某一像素的颜色
 *
 *  @param point 一像素
 *
 *  @return 颜色
 */
- (UIColor *)LY_colorAtPixel:(CGPoint)point;
/**
 *  @brief  返回该图片是否有透明度通道
 *
 *  @return 是否有透明度通道
 */
- (BOOL)LY_hasAlphaChannel;

/**
 *  @brief  获得灰度图
 *
 *  @param sourceImage 图片
 *
 *  @return 获得灰度图片
 */
+ (UIImage*)LY_covertToGrayImageFromImage:(UIImage*)sourceImage;

@end
