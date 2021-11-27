//
//  QMWShadowView.h
//  UITabbarController
//
//  Created by Apple on 2017/6/23.
//  Copyright © 2017年 qinmei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMWSMenuList.h"
@interface QMWShadowView : UIView

-(void)inputView:(UIView<QMWSMenuList>*)view withAlpha:(CGFloat)alpha withClips:(CGFloat)radius withFram:(CGRect)annifram;

@end
