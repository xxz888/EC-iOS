//
//  MCImageStore.m
//  MCImageStore
//
//  Created by Li Ping on 2019/5/18.
//  Copyright © 2019 MingChe. All rights reserved.
//

#import "MCImageStore.h"

typedef struct {
    Byte A;
    Byte R;
    Byte G;
    Byte B;
}Color;

@implementation MCImageStore

+ (UIImage *)creatShareImageWithImage:(UIImage *)image shareUrlString:(NSString *)url {
    
    //  压缩图片尺寸
    image = [MCImageStore compressImage:image];
    
    CGRect rect = [MCImageStore getAlphaFrameInImage:image];
    
    // 去掉二维码区域的黑边
    CGFloat m = 1.5;
    CGRect newRect = CGRectMake(rect.origin.x - m, rect.origin.y - m, rect.size.width + 2*m, rect.size.height + 2*m);
    
    UIImage *codeImg = [MCImageStore creatQrcodeImageWithUrlString:url width:rect.size.width];
    CGFloat logoW = rect.size.width/5;
    CGFloat logoH = rect.size.height/5;
    CGRect logoRect = CGRectMake(rect.size.width/2 - logoW/2, rect.size.height/2 - logoH/2, logoW, logoH);
    
    UIImage *icon = [MCImageStore getAppIcon];
    UIImage *codeImgWithLogo = [MCImageStore addImage:[MCImageStore creatImage:icon cornerRadius:10] on:codeImg frame:logoRect];
    
    image = [MCImageStore addImage:codeImgWithLogo on:image frame:newRect];
    return image;
}

+ (UIImage *)compressImage:(UIImage *)image{
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    if (width > 750) {  //图片最大宽度为750
        CGSize size = CGSizeMake(750, height * 750/width);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

//  获取AppIcon
+ (UIImage *)getAppIcon {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *iconPath = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage* icon = [UIImage imageNamed:iconPath];
    if (icon == nil) {
        return [UIImage new];
    }
    return icon;
}
//  两张图片叠加
+ (UIImage *)addImage:(UIImage *)image on:(UIImage *)targetImage frame:(CGRect)rect {
    
    if (rect.size.height == 0 || rect.size.width == 0) {
        return targetImage; //  返回大图
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetImage.size.width*targetImage.scale, targetImage.size.height*targetImage.scale), NO, 0.0);
    
    [targetImage drawInRect:CGRectMake(0, 0, targetImage.size.width*targetImage.scale, targetImage.size.height*targetImage.scale)];
    
    [image drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultingImage;
}

//  获取透明区域
+ (CGRect)getAlphaFrameInImage:(UIImage *)image {
    CGImageRef imageRef= [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    int bytesPerPixel = 4;
    size_t bytesPerRow=bytesPerPixel*width;
    int bitsPerComponent = 8;
    
    void* imageData ;//准备用来存储数据的数组
    //创建上下文,kCGImageAlphaPremultipliedLast表示像素点的排序是ARGB
    CGContextRef cgContexRef = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorSpace,
                                                     kCGImageAlphaPremultipliedFirst);
    
    
    CGRect theRect = CGRectMake(0,0, width, height);
    //将图片的数据写入上下文
    CGContextDrawImage(cgContexRef, theRect, imageRef);
    
    //Byte* tempData=(Byte*)CGBitmapContextGetData(cgContexRef);
    imageData = malloc(4*(width-1)+4*(height-1)*width+3);
    //    把data做一个深度拷贝，因为原来的数据在cgContexRef里边，要释放，要不会杯具
    memcpy(imageData, (Byte*)CGBitmapContextGetData(cgContexRef), 4*(width-1)+4*(height-1)*width+3);
    
    Byte *tempData = imageData;
    NSInteger left = -1;
    NSInteger top = -1;
    NSInteger right = -1;
    NSInteger bottom = -1;
    //流出安全区域，防止部分图片边缘有透明区域
    for (NSInteger x=10; x<width-10; x++) {
        for (NSInteger y=10; y<height-10; y++) {
            int index =(int)(4*x+4*y*width);
            Color c;
            c.A=tempData[index];
            c.R=tempData[index+1];
            c.G=tempData[index+2];
            c.B=tempData[index+3];
            //NSLog(@"%hhu",c.A);
            if (c.A == 0) {
                if (left == -1) {
                    left = x;
                } else if (left != -1) {
                    left = MIN(x, left);
                }
                
                if (top == -1) {
                    top = y;
                } else if (top != -1) {
                    top = MIN(y, top);
                }
                
                if (right == -1) {
                    right = x;
                } else if (right != -1) {
                    right = MAX(x, right);
                }
                
                if (bottom == -1) {
                    bottom = y;
                } else if (bottom != -1) {
                    bottom = MAX(y, bottom);
                }
            }
        }
    }
    //    NSString* str = [NSString stringWithFormat:@"left is %ld, top is %ld, right is %ld, bottom is %ld",left,top,right-left,bottom-top];
    //    NSLog(str);
    CGContextRelease(cgContexRef);
    CGColorSpaceRelease(colorSpace);
    free(imageData);
    return CGRectMake(left, top, right-left, bottom-top);
}
//  获取图片主题色
+ (UIColor *)getThemeColorOfImage:(UIImage *)image {
    if (image == nil)
    {
        return [UIColor groupTableViewBackgroundColor];
    }
    NSArray *MaxColor = [MCImageStore getThemeRGBAcolorArray:image];
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

//  银行卡背景色
+ (UIColor *)getBankThemeColorWithLogo:(UIImage *)logo {
    if (logo == nil) {
        return MAINCOLOR;
    }
    NSArray *colorSet  = [MCImageStore getThemeRGBAcolorArray:logo];
    int r = [colorSet[0] intValue];
    int g = [colorSet[1] intValue];
    int b = [colorSet[2] intValue];
    int a = [colorSet[3] intValue];
    if(r*0.299 + g*0.578 + b*0.114 >= 192){ //浅色则返回主题色
        return MAINCOLOR;
    }
    return [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a/255.0f)];
}
+ (NSArray *)getThemeRGBAcolorArray:(UIImage *)image {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(image.size.width / 2, image.size.height / 2);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width * 4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char *data = CGBitmapContextGetData(context);
    if (data == NULL) return nil;
    NSCountedSet *cls= [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x = 0; x < thumbSize.width; x++) {
        
        for (int y = 0; y < thumbSize.height; y++) {
            
            int offset = 4 * (x * y);
            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha =  data[offset + 3];
            if (alpha > 0) {//去除透明
                if (red == 255 && green == 255 && blue == 255) {//去除白色
                    
                }else{
                    
                    NSArray *clr = @[@(red), @(green), @(blue), @(alpha)];
                    [cls addObject:clr];
                }
            }
        }
    }
    CGContextRelease(context);
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    while ( (curColor = [enumerator nextObject]) != nil ) {
        
        NSUInteger tmpCount = [cls countForObject:curColor];
        if (tmpCount < MaxCount) continue;
        MaxCount = tmpCount;
        MaxColor = curColor;
    }
    return MaxColor;
}

//  图片压缩
+ (UIImage *)compressImageSize:(UIImage *)image toKByte:(NSUInteger)kb {
    NSUInteger maxLength = kb * 1000;
    UIImage *resultImage = image;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}


+ (UIImage *)compressImage:(UIImage *)image WithLength:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    maxLength = maxLength*1024;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return [UIImage imageWithData:data];
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return [UIImage imageWithData:data];
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return [UIImage imageWithData:data];
}



//  截图
+ (UIImage *)screenShotWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

+ (UIImage *)screenShotWithFrame:(CGRect)rect {
    //TODO:
    
    UIImage *img = [MCImageStore screenShotWithView:MCLATESTCONTROLLER.view];
    UIImage *timg = [MCImageStore ct_imageFromImage:img inRect:rect];
    
    return timg;
}


+ (UIImage *)placeholderImageWithSize:(CGSize)size {
    // 占位图的背景色
    UIColor *backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    // 中间LOGO图片
    UIImage *icon = [MCImageStore getAppIcon];
    
    //  图片灰色
    CGColorSpaceRef colorref = CGColorSpaceCreateDeviceGray();
    CGContextRef ctx = CGBitmapContextCreate(nil, icon.size.width, icon.size.height, 8, 0, colorref, kCGImageAlphaNone);
    CGColorSpaceRelease(colorref);
    CGContextDrawImage(ctx, CGRectMake(0, 0, icon.size.width, icon.size.height), icon.CGImage);
    UIImage *iconGray = [UIImage imageWithCGImage:CGBitmapContextCreateImage(ctx)];
    CGContextRelease(ctx);
    
    //  圆形剪裁
    UIGraphicsBeginImageContextWithOptions(iconGray.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, iconGray.size.width, iconGray.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [iconGray drawInRect:rect];
    UIImage* circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // 根据占位图需要的尺寸 计算 中间LOGO的宽高
    CGFloat logoWH = (size.width > size.height ? size.height : size.width) * 0.5;
    CGSize logoSize = CGSizeMake(logoWH, logoWH);
    // 打开上下文
    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
    // 绘图
    [backgroundColor set];
    UIRectFill(CGRectMake(0,0, size.width, size.height));
    CGFloat imageX = (size.width / 2) - (logoSize.width / 2);
    CGFloat imageY = (size.height / 2) - (logoSize.height / 2);
    [circleImage drawInRect:CGRectMake(imageX, imageY, logoSize.width, logoSize.height)];
    UIImage *resImage =UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return resImage;
}

+ (UIImage*)creatImage:(UIImage *)image cornerRadius:(CGFloat)radius {
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}


+ (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

+ (UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
    
}


+ (UIImage *)creatShareImageWithImage:(UIImage *)image {
    
    NSString *url = [NSString stringWithFormat:@"%@?phone=%@&brand_id=%@&ip=%@", SharedBrandInfo.shareMainAddress,SharedUserInfo.phone,SharedConfig.brand_id,BCFI.pureHost];
    return [self creatShareImageWithImage:image shareUrlString:url];
}

//创建二维码
+ (UIImage *)creatQrcodeImageWithUrlString:(NSString *)str width:(CGFloat)size {
    
    CIFilter* filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    NSData* data = [str dataUsingEncoding: NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];  //容错率高
    CIImage* ciimage=filter.outputImage;
    CGRect extent = CGRectIntegral(ciimage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciimage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


+ (UIImage *)creatShareImageWithImageFenXiang:(UIImage *)image {
    
    NSString *url = [NSString stringWithFormat:@"%@?phone=%@&brand_id=%@&ip=%@", SharedBrandInfo.shareMainAddress,SharedUserInfo.phone,SharedConfig.brand_id,BCFI.pureHost];
    return [self creatShareImageWithImageFenXiang:image shareUrlString:url];
}
+ (UIImage *)creatShareImageWithImageFenXiang:(UIImage *)image shareUrlString:(NSString *)url {
    
    //  压缩图片尺寸
    image = [MCImageStore compressImage:image];
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    // 去掉二维码区域的黑边
    CGFloat m = 1.5;
    CGRect newRect = rect;

    UIImage *codeImg = [MCImageStore creatQrcodeImageWithUrlString:url width:image.size.width];
    CGFloat logoW = rect.size.width/4;
    CGFloat logoH = rect.size.width/4;
    CGRect logoRect = CGRectMake(rect.size.width/2 - logoW/2, rect.size.width/2 - logoH/2, logoW, logoH);
    
    UIImage *icon = [MCImageStore getAppIcon];
    UIImage *codeImgWithLogo = [MCImageStore addImage:[MCImageStore creatImage:icon cornerRadius:10] on:codeImg frame:logoRect];
    
    return codeImgWithLogo;
}

@end

