//
//  CALayer+Additions.m
//  KaDeShiJie
//
//  Created by apple on 2021/5/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)
- (void)setBorderColorFromUIColor:(UIColor *)color

{

  self.borderColor = color.CGColor;

}
@end
