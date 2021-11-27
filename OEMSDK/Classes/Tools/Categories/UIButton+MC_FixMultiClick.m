//
//  UIButton+MC_FixMultiClick.m
//  Project
//
//  Created by Li Ping on 2019/5/31.
//  Copyright © 2019 LY. All rights reserved.
//

#import "UIButton+MC_FixMultiClick.h"
#import <objc/runtime.h>




static NSTimeInterval mc_acceptEventTime = 0;

@implementation UIButton (MC_FixMultiClick)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
- (NSTimeInterval)mc_acceptEventInterval {
    double d = [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
    return  d > 0 ? d : .5;
}
- (void)setMc_acceptEventInterval:(NSTimeInterval)mc_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(mc_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const char *UIControl_acceptIgnoreMultiClick = "UIControl_acceptIgnoreMultiClick";
- (BOOL)mc_ignoreMultiClick {
    return [objc_getAssociatedObject(self, UIControl_acceptIgnoreMultiClick) boolValue];
}
- (void)setMc_ignoreMultiClick:(BOOL)mc_ignoreMultiClick {
    objc_setAssociatedObject(self, UIControl_acceptIgnoreMultiClick, @(mc_ignoreMultiClick), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 在load时执行hook
+ (void)load {
    if ([self isKindOfClass:[UIButton class]]) {
        Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method after    = class_getInstanceMethod(self, @selector(mc_sendAction:to:forEvent:));
        method_exchangeImplementations(before, after);
    }
    
    
}

- (void)mc_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.mc_ignoreMultiClick) {
        [self mc_sendAction:action to:target forEvent:event];
    }
    if ([NSDate date].timeIntervalSince1970 - mc_acceptEventTime < self.mc_acceptEventInterval) {
        return;
    }
    if (self.mc_acceptEventInterval > 0) {
        mc_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    [self mc_sendAction:action to:target forEvent:event];
}

@end
