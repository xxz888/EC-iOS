//
//  NSBundle+changeBundleId.m
//  Project
//
//  Created by wza on 2020/4/6.
//  Copyright © 2020 LY. All rights reserved.
//

#import "NSBundle+changeBundleId.h"
#import <objc/runtime.h>

//原包名
#define NSBundle_changeBundleIdentifier_orgBundleId @"NSBundle_changeBundleIdentifier_orgBundleId"

//修改包名
#define NSBundle_changeBundleIdentifier_nowBundleId @"NSBundle_changeBundleIdentifier_nowBundleId"

@implementation NSBundle (changeBundleId)

//修改包名
- (void)changeBundleIdentifier:(NSString *)bundleId {
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [def setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:NSBundle_changeBundleIdentifier_orgBundleId];
        [def synchronize];
        
        Method m1 = class_getInstanceMethod([self class], NSSelectorFromString(@"bundleIdentifier"));
        Method m2 = class_getInstanceMethod([self class], NSSelectorFromString(@"_changeB"));
        method_exchangeImplementations(m1, m2);
    });
    if (bundleId) {
        [def setObject:bundleId forKey:NSBundle_changeBundleIdentifier_nowBundleId];
        [def synchronize];
    } else {
        [def setObject:[def objectForKey:NSBundle_changeBundleIdentifier_orgBundleId] forKey:NSBundle_changeBundleIdentifier_nowBundleId];
        [def synchronize];
    }
}

- (NSString *)_changeB {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NSBundle_changeBundleIdentifier_nowBundleId];
}

@end
