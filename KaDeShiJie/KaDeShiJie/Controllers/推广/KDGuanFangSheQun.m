//
//  KDGuanFangSheQun.m
//  KaDeShiJie
//
//  Created by BH on 2021/10/19.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDGuanFangSheQun.h"

@implementation KDGuanFangSheQun

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)zhidaoleAction:(id)sender {
    if (self.block) {
        self.block();
    }
}
@end
