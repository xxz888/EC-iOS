//
//  MCToast.m
//  MCOEM
//
//  Created by wza on 2020/3/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCToast.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation MCToast

+ (void)showMessage:(NSString *)message {
    
    [self showMessage:message position:MCToastPositionBottom];
}
+ (void)showMessage:(NSString *)message position:(MCToastPosition)position {
    if (message && message.length > 0) {
        UIView *view = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//        hud.backgroundColor = KRedColor; 整个屏幕背景色
//        hud.tintColor = KBlueColor;
        hud.contentColor = KWhiteColor;
        hud.mode = MBProgressHUDModeText;
        hud.label.numberOfLines = 3;
        hud.label.text = message;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        hud.margin = 10.f;
        hud.userInteractionEnabled = NO;
        CGFloat margin = NavigationContentTop + 40;  //距离底部和顶部的距离
        CGFloat offSetY = view.bounds.size.height / 2 - margin;
        if (position == MCToastPositionTop) {
            hud.offset = CGPointMake(hud.offset.x, -offSetY);
        }
        if (position == MCToastPositionCenter) {
            hud.offset = CGPointZero;
        }
        if (position == MCToastPositionBottom) {
            hud.offset = CGPointMake(hud.offset.x, offSetY);
        }

        [hud hideAnimated:YES afterDelay:3.0];
    }
}
@end
