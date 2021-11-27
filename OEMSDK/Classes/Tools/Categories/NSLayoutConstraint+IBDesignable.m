//
//  NSLayoutConstraint+IBDesignable.m
//  MCOEM
//
//  Created by wza on 2020/5/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "NSLayoutConstraint+IBDesignable.h"

#define  C_WIDTH(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/375.0

@implementation NSLayoutConstraint (IBDesignable)

-(void)setWidthScreen:(BOOL)widthScreen{
    if (widthScreen) {
        self.constant = C_WIDTH(self.constant);
    }else{
        self.constant = self.constant;
    }
}

-(BOOL)widthScreen{
    return self.widthScreen;
}

@end
