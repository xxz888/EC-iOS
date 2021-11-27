//
//  UIImage+mc.h
//  AFNetworking
//
//  Created by wza on 2020/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (mc)


/// 从OEMSDK bundle中取图片
/// @param imgName 图片
+ (instancetype)mc_imageNamed:(NSString *)imgName;

@end

NS_ASSUME_NONNULL_END
