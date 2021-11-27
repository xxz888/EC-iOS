//
//  MCImageStore.h
//  MCImageStore
//
//  Created by Li Ping on 2019/5/18.
//  Copyright © 2019 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MCImageStore : NSObject


/**
 创建圆角图片

 @param image image
 @param radius radius
 @return image
 */
+ (UIImage*)creatImage:(UIImage *)image cornerRadius:(CGFloat)radius;

/**
 绘制占位图

 @param size 尺寸
 @return 图片
 */
+ (UIImage *)placeholderImageWithSize:(CGSize)size;

/**
 获取appicon
 
 @return app icon
 */
+ (UIImage *)getAppIcon;

/**
 传入一个带矩形透明区域的图片、分享链接 ，创建分享图片

 @param image 图片
 @param url 分享链接
 @return 带二维码的图片
 */
+ (UIImage *)creatShareImageWithImage:(UIImage *)image shareUrlString:(NSString *)url;


/// 传入一个带矩形透明区域的图片 ，创建分享图片
/// @param image 图片
+ (UIImage *)creatShareImageWithImage:(UIImage *)image;

/**
 根据图片获取主题色,默认颜色 groupTableViewBackgroundColor

 @param image 图片
 @return 颜色
 */
+ (UIColor *)getThemeColorOfImage:(UIImage *)image;


/**
 根据银行卡logo获取银行卡背景色,如果获取的颜色较浅，则返回主题色（用于）

 @param logo logo
 @return color
 */
+ (UIColor *)getBankThemeColorWithLogo:(UIImage *)logo;


/**
 压缩图片

 @param image 原图
 @param kb 期望的大小（单位kb）
 @return 新图
 */
+ (UIImage *)compressImageSize:(UIImage *)image toKByte:(NSUInteger)kb;


/**
 根据view获取截图

 @param view view
 @return image
 */
+ (UIImage *)screenShotWithView:(UIView *)view;


/**
 根据坐标获取截图

 @param rect 坐标
 @return image
 */
+ (UIImage *)screenShotWithFrame:(CGRect)rect;


/**
 剪裁图片

 @param image 图片
 @param rect 坐标
 @return 新图片
 */
+ (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect;



/**
 将图片绘制在目标图片上

 @param image 图片
 @param targetImage 目标图片
 @param rect 坐标
 @return 新的图片
 */
+ (UIImage *)addImage:(UIImage *)image on:(UIImage *)targetImage frame:(CGRect)rect;



/**
 将UIView转换成UIImage

 @param view UIView
 @return UIImage
 */
+ (UIImage *)convertViewToImage:(UIView *)view;




/**
 混合压缩图片，压缩到目标大小以下（KB）

 @param image 愿图片
 @param maxLength 目标大小（KB）
 @return 压缩后图片
 */
+ (UIImage *)compressImage:(UIImage *)image WithLength:(NSUInteger)maxLength;


/// 创建二维码
/// @param str str
/// @param size 尺寸
+ (UIImage *)creatQrcodeImageWithUrlString:(NSString *)str width:(CGFloat)size;


+ (UIImage *)creatShareImageWithImageFenXiang:(UIImage *)image;


+ (CGRect)getAlphaFrameInImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
