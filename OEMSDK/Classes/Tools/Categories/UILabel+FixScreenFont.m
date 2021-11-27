//
//  UILabel+FixScreenFont.m
//  MCOEM
//
//  Created by wza on 2020/5/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "UILabel+FixScreenFont.h"

#define  C_WIDTH(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/375.0
@implementation UILabel (FixScreenFont)
- (void)setFixWidthScreenFont:(float)fixWidthScreenFont{
    
    if (fixWidthScreenFont > 0 ) {
        self.font = [UIFont systemFontOfSize:C_WIDTH(fixWidthScreenFont)];
    }else{
        self.font = self.font;
    }
}

- (float )fixWidthScreenFont{
    return self.fixWidthScreenFont;
}
@end
