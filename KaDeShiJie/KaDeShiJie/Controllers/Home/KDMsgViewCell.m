//
//  KDMsgViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/8.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDMsgViewCell.h"

@interface KDMsgViewCell ()

@end

@implementation KDMsgViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.frame = CGRectMake(0, 0, SCREEN_WIDTH - 90 - 28, 77 * SCREEN_WIDTH / 375);
}

@end
