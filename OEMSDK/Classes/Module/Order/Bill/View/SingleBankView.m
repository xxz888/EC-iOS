//
//  SingleBankView.m
//  Project
//
//  Created by liuYuanFu on 2019/6/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import "SingleBankView.h"

@implementation SingleBankView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // 顶部视图高度
    self.topViewHeight.constant = NavigationContentTopConstant;
    // 背景图约束高度
    self.top_bgHeight.constant = 200-64+NavigationContentTopConstant;
    self.bankView.layer.cornerRadius = self.bankView.ly_width/2;
     self.bankView.layer.shadowColor = [UIColor mainColor].CGColor;
     self.bankView.layer.shadowOffset = CGSizeMake(2,2);
     self.bankView.layer.shadowRadius = 2;
     self.bankView.layer.shadowOpacity = 0.3f;
    
    _serviceTitle.text = [NSString stringWithFormat:@"%@服务大厅",self.headArr[2]];
    // 热线
    _phoneLb.text = self.headArr[0];
    // 图标
    _bankImg.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"%@",self.headArr[1]]];
    // 文本
    _bankLb.text = self.headArr[2];
}

-(void)layoutSubviews{
    self.ly_width = SCREEN_WIDTH;
    self.ly_height = 260 -64+NavigationContentTopConstant;
}

- (IBAction)backToUpVC:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(justMethodChuFa:)]) {
        [self.delegate justMethodChuFa:sender];
    }
}


@end
