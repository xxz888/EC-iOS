//
//  UIImage+mc.m
//  AFNetworking
//
//  Created by wza on 2020/7/2.
//

#import "UIImage+mc.h"

@implementation UIImage (mc)

+ (instancetype)mc_imageNamed:(NSString *)imgName {
    return [self imageNamed:imgName inBundle:[NSBundle OEMSDKBundle] compatibleWithTraitCollection:nil];
}

@end
