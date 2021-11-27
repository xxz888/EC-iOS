//
//  MCBankStore.m
//  Project
//
//  Created by Li Ping on 2019/6/24.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCBankStore.h"

@implementation MCBankStore

+ (MCBankCardInfo *)getBankCellInfoWithName:(NSString *)name {
    NSArray *localA = [MCBankStore getLocalJson:@"card_bankName"];
    NSString * localName = @"BANK_default";
    UIImage *logo = [UIImage mc_imageNamed:localName];
    UIColor * backGround = MAINCOLOR; //  默认主题色
    for (NSDictionary *bankDic in localA) {// 添加本地logo
        
        NSString *ss = bankDic[@"bank_name"];
//        BANK_HXBANK
        if ([ss containsString:name]) {
            localName = [NSString stringWithFormat:@"BANK_%@", bankDic[@"bank_acronym"]];
            logo = [UIImage mc_imageNamed:localName];
            backGround = [MCBankStore getBankThemeColorWithLogo:logo];
            break;
        }
    }
    return [[MCBankCardInfo alloc] initWithLogo:logo cardCellBackgroundColor:backGround];
}

+ (NSArray *)getLocalJson:(NSString *)jsonName {
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle OEMSDKBundle] pathForResource:jsonName ofType:@"json"]];
    
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *newArray = [NSMutableArray array];
    
    for (NSDictionary *dict in dataArray) {
        
        [newArray addObject:dict];
    }
    return newArray;
}

+ (UIColor *)getBankThemeColorWithLogo:(UIImage *)logo {
    if (logo == nil) {
        return MAINCOLOR;
    }
    NSArray *colorSet  = [MCBankStore getThemeRGBAcolorArray:logo];
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

@end


@implementation MCBankCardInfo

- (instancetype)initWithLogo:(UIImage *)logo cardCellBackgroundColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.logo = logo;
        self.cardCellBackgroundColor = color;
    }
    return self;
}

@end
