//
//  LYImageMagnification.h
//  JFB
//
//  Created by xiong on 2017/10/25.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYImageMagnification : NSObject

/**
 *  浏览大图
 *
 *  @param currentImageview 当前图片
 *  @param alpha            背景透明度
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview alpha:(CGFloat)alpha;

@end
