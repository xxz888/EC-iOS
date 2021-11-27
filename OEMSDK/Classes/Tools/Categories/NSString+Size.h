//
//  NSString+Size.h
//  Project
//
//  Created by 熊凤伟 on 2018/1/19.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

/**
 *  给定宽度，字体，返回高度
 *
 *  @param width PreferWidth
 *  @param font  字体
 */
- (CGSize)sizeWithPreferWidth:(CGFloat)width font:(UIFont *)font;

/**
 *  给定高度，字体，返回宽度
 *
 *  @param height 固定高度
 *  @param font  字体
 */
- (CGSize)sizeWithpreferHeight:(CGFloat)height font:(UIFont *)font;
/**
 获取字符串高度
 
 @param width 宽度
 @param font 字体
 @return 返回高度
 */
+ (CGFloat)stringHeightWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font;
/**
 获取字符串宽度
 
 @param font 字体
 @return 返回宽度
 */
+ (CGFloat)stringWidthWithString:(NSString *)string font:(UIFont *)font;

@end
