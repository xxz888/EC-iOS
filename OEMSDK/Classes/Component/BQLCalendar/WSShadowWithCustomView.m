//
//  WSShadowWithCustomView.m
//  UITabbarController
//
//  Created by Apple on 2017/6/23.
//  Copyright © 2017年 qinmei. All rights reserved.
//

#import "WSShadowWithCustomView.h"
#import "QMWShadowView.h"

@interface WSShadowWithCustomView ()

@end

@implementation WSShadowWithCustomView

+(void)showShadow:(UIView<QMWSMenuList>*)customerview withAlpha:(CGFloat)alpha withClips:(CGFloat)radius withFram:(CGRect)annifram{
    
    QMWShadowView* shdow=[[QMWShadowView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    shdow.tag=10002;
    [[UIApplication sharedApplication].keyWindow addSubview:shdow];
    [shdow inputView:customerview withAlpha:alpha withClips:radius withFram:annifram];
    
}
+(void)hideShadow{
    UIView* view=[[UIApplication sharedApplication].keyWindow viewWithTag:10002] ;
    [UIView animateWithDuration:0.32 animations:^{
        view.alpha=0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    view=nil;
}
@end
