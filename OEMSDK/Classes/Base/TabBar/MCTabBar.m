//
//  MCTabBar.m
//  MCOEM
//
//  Created by wza on 2020/3/7.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCTabBar.h"

@interface MCTabBar ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *btn;

@end

@implementation MCTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.barStyle = UIBarStyleBlack;   // 设置样式, 去除tabbar上面的黑线
        self.backgroundImage = [UIImage mc_imageNamed:@"tabbar_bg"];   // 设置tabbar 背景图片
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    Class class = NSClassFromString(@"UITabBarButton");
    int btnIndex = 0;
    NSInteger c = (NSInteger)floor(MCModelStore.shared.brandConfiguration.tab_items.count/2);
    NSString *centTitle = MCModelStore.shared.brandConfiguration.tab_items[c].title;
    for (UIView *btn in self.subviews){
        if ([btn isKindOfClass:class]) {
            
            if (btnIndex == c) { // btnIndex == 2 的时候， 为中间按钮， 添加一个背景图片
                CGFloat margin = 0;
                if (centTitle&&centTitle.length>0) {
                    margin = -15;
                }
//                self.imageView.frame = CGRectMake(5, -self.imageView.qmui_height/2+margin, btn.qmui_width - 10, btn.qmui_height + 17);
                
                self.imageView.frame = CGRectMake((btn.width-50)/2,-50/2, 50, 50);
                [btn insertSubview:self.imageView atIndex:0];
                self.btn = btn;
            }
            btnIndex++;
        }
    }
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:BCFI.tab_center_image];
    }
    return _imageView;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        CGPoint newP = [self convertPoint:point toView:self.imageView];
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.imageView pointInside:newP withEvent:event]) {
            return self.btn;
        }else{ //如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    else {  //tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
