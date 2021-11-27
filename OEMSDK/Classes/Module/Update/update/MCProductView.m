//
//  MCProductView.m
//  MCOEM
//
//  Created by wza on 2020/4/22.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCProductView.h"



@implementation MCProductView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.gradeImgView.layer.borderWidth = 2;
    self.gradeImgView.layer.borderColor = UIColorWhite.CGColor;
    self.gradeImgView.layer.cornerRadius = self.gradeImgView.qmui_width/2;
    
}

- (void)setType:(MCProductViewType)type {
    if (type == MCProductViewTypeMyRate) {
        self.priceLab.hidden = YES;
        self.numLab.textColor = self.currentGradeLab.textColor;
    }
}

@end
