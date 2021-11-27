//
//  BillSearchCell.m
//  Project
//
//  Created by liuYuanFu on 2019/6/4.
//  Copyright © 2019 LY. All rights reserved.
//

#import "BillSearchCell.h"

@implementation BillSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    self.ly_width = SCREEN_WIDTH;
}

@end
