//
//  UIView+qmui_centerXY.m
//  MCOEM
//
//  Created by wza on 2020/4/15.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "UIView+qmui_centerXY.h"

@implementation UIView (qmui_centerXY)

- (CGFloat)qmui_centerX {
    return self.center.x;
}
- (CGFloat)qmui_centerY {
    return self.center.y;
}
- (void)setQmui_centerX:(CGFloat)qmui_centerX {
    CGPoint center = self.center;
    center.x = qmui_centerX;
    self.center = center;
}
- (void)setQmui_centerY:(CGFloat)qmui_centerY {
    CGPoint center = self.center;
    center.y = qmui_centerY;
    self.center = center;
}






@end
