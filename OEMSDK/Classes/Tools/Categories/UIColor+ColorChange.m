//
//  UIColor+ColorChange.m
//  Project
//
//  Created by 熊凤伟 on 2017/12/25.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "UIColor+ColorChange.h"

@implementation UIColor (ColorChange)

+ (UIColor *)colorWithHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
/** 设置渐变色 */
+ (CAGradientLayer *)setGraduaChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    // 渐变色数组
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    // 设置渐变色的方向，左上点(0,0)，右下点(1,1)
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    // 设置渐变色变化点(0~1)
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}
/** 从图片中获取颜色 */
+ (UIColor *)colorWithPicture:(UIImage *)image point:(CGPoint)point {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8 *data = CFDataGetBytePtr(pixelData);
    
    NSUInteger width = image.size.width;
    int pixelInfo = ((width * point.y) + point.x) * 4;
    
    CGFloat red   = (CGFloat)data[pixelInfo] / 255.0f;
    CGFloat green = (CGFloat)data[pixelInfo + 1] / 255.0f;
    CGFloat blue  = (CGFloat)data[pixelInfo + 2] / 255.0f;
    CGFloat alpha = (CGFloat)data[pixelInfo + 3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
/** 根据图片获取图片的主色调 */
+ (UIColor *)getMainColorWitImage:(UIImage *)image {
    
    if (image == nil) {
        return MAINCOLOR;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(image.size.width, image.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL) return nil;
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha>0) {//去除透明
                if (red==255&&green==255&&blue==255) {//去除白色
                }else{
                    NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
                
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    
    int r = [MaxColor[0] intValue];
    int g = [MaxColor[1] intValue];
    int b = [MaxColor[2] intValue];
    
    if(r*0.299 + g*0.578 + b*0.114 >= 192){ //浅色
        return MAINCOLOR;
    }else{  //深色
        
    }
    return [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

@end
















