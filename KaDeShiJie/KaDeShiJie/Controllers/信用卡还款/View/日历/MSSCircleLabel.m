//
//  MSSCircleLabel.m
//  MSSCalendar
//
//  Created by 于威 on 16/4/4.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSCircleLabel.h"
#import <OEMSDK/OEMSDK.h>

@implementation MSSCircleLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = UIFontBoldMake(15);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    UIColor *color = nil;
    switch (_type) {
        case MSSCircleLabelTypeNormal:
            color = UIColorWhite;
            break;
        case MSSCircleLabelTypeSelected:
            color = UIColorMakeWithHex(@"#FF3735");
            break;
        case MSSCircleLabelTypeZhangdan:{
            color = UIColorMakeWithHex(@"#00A4FF");
        }
            break;
        case MSSCircleLabelTypeHuankuan:
            color = UIColorMakeWithHex(@"#FF9300");
            break;
        default:
            color = UIColorWhite;
            break;
    }
    [color setFill];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.height / 2 startAngle:0.0 endAngle:180.0 clockwise:YES];
    [path fill];
    
    self.textAlignment = NSTextAlignmentCenter;
    
    [super drawRect:rect];
}

- (void)setType:(MSSCircleLabelType)type {
    _type = type;
    [self setNeedsDisplay];
}




@end
