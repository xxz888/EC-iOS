//
//  NSString+Size.m
//  Project
//
//  Created by 熊凤伟 on 2018/1/19.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

/**
 *  给定高度，字体，返回宽度
 *
 *  @param height 固定高度
 *  @param font  字体
 */
- (CGSize)sizeWithpreferHeight:(CGFloat)height font:(UIFont *)font{
    if (!font) {
        return CGSizeZero;
    }
    NSDictionary *dict=@{NSFontAttributeName : font};
    return [self sizeWithpreferHeight:height attribute:dict];
}
- (CGSize)sizeWithpreferHeight:(CGFloat)height attribute:(NSDictionary *)attr{
    CGRect rect=[self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attr context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}
/**
 *  给定宽度，字体，返回高度
 *
 *  @param width PreferWidth
 *  @param font  字体
 */
- (CGSize)sizeWithPreferWidth:(CGFloat)width font:(UIFont *)font{
    if (!font) {
        return CGSizeZero;
    }
    NSDictionary *dict=@{NSFontAttributeName : font};
    return [self sizeWithPreferWidth:width attribute:dict];
}
- (CGSize)sizeWithPreferWidth:(CGFloat)width attribute:(NSDictionary *)attr{
    CGRect rect=[self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attr context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}
/**
 获取字符串高度
 
 @param width 宽度
 @param font 字体
 @return 返回高度
 */
+ (CGFloat)stringHeightWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}
/**
 获取字符串宽度
 
 @param font 字体
 @return 返回宽度
 */
+ (CGFloat)stringWidthWithString:(NSString *)string font:(UIFont *)font {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}

@end
