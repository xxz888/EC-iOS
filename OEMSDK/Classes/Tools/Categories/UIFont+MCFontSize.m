//
//  UIFont+MCFontSize.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/16.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "UIFont+MCFontSize.h"

#import <objc/runtime.h>

//UI设计图宽度
#define DesignWidth 375.0
//缩放比例
#define Scaling ((CGFloat)([UIScreen mainScreen].bounds.size.width / DesignWidth))

@implementation UIFont (MCFontSize)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //要特别注意你替换的方法到底是哪个性质的方法（实例方法：Class class = [self class]; 类方法：Class class = object_getClass((id)self);）
        //类方法的写法
        Class class = object_getClass((id)self);
        // 获取系统的selector
        SEL   originalSelector = @selector(systemFontOfSize:);
        SEL   originalSelector1 = @selector(fontWithName:size:);
        // 自己要交换的selector
        SEL   swizzledSelector = @selector(tc_systemFontOfSize:);
        SEL   swizzledSelector1 = @selector(tc_fontWithName:size:);
        // 两个方法的地址
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        Method originalMethod1 = class_getClassMethod(class, originalSelector1);
        Method swizzledMethod1 = class_getClassMethod(class, swizzledSelector1);
        //  动态添加方法
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        BOOL didAddMethod1 =
        class_addMethod(class,
                        originalSelector1,
                        method_getImplementation(swizzledMethod1),
                        method_getTypeEncoding(swizzledMethod1));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        if (didAddMethod1) {
            class_replaceMethod(class,
                                swizzledSelector1,
                                method_getImplementation(originalMethod1),
                                method_getTypeEncoding(originalMethod1));
        } else {
            method_exchangeImplementations(originalMethod1, swizzledMethod1);
        }
    });
}

+ (UIFont *)tc_systemFontOfSize:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont tc_systemFontOfSize:fontSize * Scaling];
    return newFont;
}

+ (UIFont *)tc_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont tc_fontWithName:fontName size:fontSize * Scaling];
    return newFont;
}

@end
