//
//  UIColor+MCColor.m
//  MCOEM
//
//  Created by SS001 on 2020/3/28.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "UIColor+MCColor.h"


@implementation UIColor (MCColor)

+ (UIColor *)mainColor
{
    return MCModelStore.shared.brandConfiguration.color_main;
}

@end
