//
//  QMWShadowView.m
//  UITabbarController
//
//  Created by Apple on 2017/6/23.
//  Copyright © 2017年 qinmei. All rights reserved.
//

#import "QMWShadowView.h"

@interface QMWShadowView ()
{
    UIView<QMWSMenuList>* _view;
    UIView* backview;
    CGRect animationFram;
}
@end

@implementation QMWShadowView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)inputView:(UIView<QMWSMenuList>*)view withAlpha:(CGFloat)alpha withClips:(CGFloat)radius withFram:(CGRect)annifram{
    backview=[[UIView alloc]initWithFrame:self.frame];
    backview.backgroundColor=[UIColor blackColor];
    backview.alpha=0;
    _view=view;
    animationFram=annifram;
    view.clipsToBounds=YES;
    view.layer.cornerRadius=radius;
    [self addSubview:backview];
    [self addSubview:view];
//    CGRect frame=view.frame;
//    view.frame=annifram;
    [UIView animateWithDuration:0.22 animations:^{
        self->backview.alpha=alpha;
//        view.frame=frame;
    }];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_view.viewTouch) {
        _view.viewTouch();
    }
//    [UIView animateWithDuration:0.22 animations:^{
//        _view.frame=animationFram;
//        backview.alpha=0;
//        _view.alpha=0;
//        for (UIView* vvv in _view.subviews) {
//            vvv.alpha=0;
//        }
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
