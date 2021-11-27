//
//  UIViewController+MC_FixPresentInMainThread.m
//  Project
//
//  Created by Li Ping on 2019/10/12.
//  Copyright © 2019 LY. All rights reserved.
//

#import "UIViewController+MC_FixPresentInMainThread.h"
#import <objc/runtime.h>



@implementation UIViewController (MC_FixPresentInMainThread)

+ (void)load {
        Method before = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
        Method after = class_getInstanceMethod(self, @selector(mc_presentViewController:animated:completion:));
        method_exchangeImplementations(before, after);
}

- (void)mc_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    BOOL isCustom = (bundle == [NSBundle mainBundle]);  //  是否是自定义的类
    
    if (isCustom) {
        if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet) {   //  修改iOS13默认present模式
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) { //  主线程
            [self mc_presentViewController:viewControllerToPresent animated:flag completion:completion];
        } else {    //  子线程
            dispatch_async(dispatch_get_main_queue(), ^{    //  切到主线程 present
                [self mc_presentViewController:viewControllerToPresent animated:flag completion:completion];
            });
        }
    } else {
        [self mc_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    
}



@end
