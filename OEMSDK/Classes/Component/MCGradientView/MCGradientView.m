//
//  MCGradientView.m
//  Project
//
//  Created by Li Ping on 2019/8/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCGradientView.h"

@interface MCGradientView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation MCGradientView


- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        // 渐变色
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        
        _startPoint = CGPointMake(0, 0);
        _endPoint = CGPointMake(1, 0);
        _startSaturation = 0.8;
        _endSaturation = 1.1;
        
        NSDictionary *hsba = [self getHSBAValueByColor:[UIColor mainColor]];
        
        float h = [[hsba objectForKey:@"H"] floatValue];
        float s = [[hsba objectForKey:@"S"] floatValue];
        float b = [[hsba objectForKey:@"B"] floatValue];
        float a = [[hsba objectForKey:@"A"] floatValue];
        
        //  起点颜色，将s变小
        UIColor *s_color = [[UIColor alloc] initWithHue:h saturation:s*_startSaturation brightness:b alpha:a];
        //  结束颜色，将s变大
        UIColor *e_color = [[UIColor alloc] initWithHue:h saturation:s*_endSaturation brightness:b alpha:a];
        
        _startColor = s_color;
        _endColor = e_color;
        
        [self reloadAppearance];
    }
    return _gradientLayer;
}

- (void)reloadAppearance {
    // 设置渐变区域的起始和终止位置（0-1）
    _gradientLayer.startPoint = self.startPoint;
    _gradientLayer.endPoint = self.endPoint;
    
    NSDictionary *hsba = [self getHSBAValueByColor:self.mainColor];
    
    float h = [[hsba objectForKey:@"H"] floatValue];
    float s = [[hsba objectForKey:@"S"] floatValue];
    float b = [[hsba objectForKey:@"B"] floatValue];
    float a = [[hsba objectForKey:@"A"] floatValue];
    
    //  起点颜色，将s变小
    UIColor *s_color = [[UIColor alloc] initWithHue:h saturation:s*self.startSaturation brightness:b alpha:a];
    //  结束颜色，将s变大
    UIColor *e_color = [[UIColor alloc] initWithHue:h saturation:s*self.endSaturation brightness:b alpha:a];
    
    self.startColor = s_color;
    self.endColor = e_color;
    
    _gradientLayer.colors=@[(__bridge id)self.startColor.CGColor,(__bridge id)self.endColor.CGColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setGradient];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setGradient];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.gradientLayer setFrame:self.bounds];
}


- (void)setGradient {
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

//  UIColor转 hsba
- (NSDictionary *)getHSBAValueByColor:(UIColor *)originColor {
    CGFloat h=0,s=0,b=0,a=0;
    if ([originColor respondsToSelector:@selector(getHue:saturation:brightness:alpha:)]) {
        [originColor getHue:&h saturation:&s brightness:&b alpha:&a];
    }
    return @{@"H":@(h),
             @"S":@(s),
             @"B":@(b),
             @"A":@(a)};
}

@end
