//
//  UIView+newnib.m
//  MCOEM
//
//  Created by wza on 2020/3/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "UIView+newnib.h"




@implementation UIView (newnib)

+ (instancetype)newFromNib {
    
    NSBundle *bundle = [NSBundle wg_subBundleWithBundleName:@"OEMSDK" targetClass:[self class]];
    
    id obj = [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:bundle]
               instantiateWithOwner:nil
               options:nil] firstObject];
    NSAssert([obj isKindOfClass:[self class]], @"Class mismatch %@",
             NSStringFromClass([self class]));
    return obj;
}

@end
