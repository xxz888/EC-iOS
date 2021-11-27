//
//  MCAboutHeader.m
//  MCOEM
//
//  Created by wza on 2020/4/16.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCAboutHeader.h"

@implementation MCAboutHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.image = SharedAppInfo.icon;
    self.lab1.textColor = UIColorBlack;
    self.lab3.textColor = UIColorGrayDarken;
    self.lab2.textColor = UIColorGrayDarken;
    self.phoneLab.textColor = UIColorGrayDarken;
    
    self.lab1.text = SharedConfig.brand_name;
    self.lab2.text = SharedAppInfo.build;
    self.lab3.text = [NSString stringWithFormat:@"    随着移动互联网的高速发展，手机里的移动支付应用给日常生活带来极大便利，今日，%@特推出一款可实现无卡支付的掌上钱包--%@\n    本产品颠覆传统POS机，通过无卡支付技术，实现一键支付；该软件支持支付宝、财付通、易宝、银联、微信和几乎所有的银行卡和信用卡，省去现金交易的不安全性和繁琐性，节约成本、简单易用。商家只需一键安装该软件，输入银行卡号，提供验证即可一键支付，%@对商户进行实名认证，短信认证，为您打造一个绿色、安全、快捷的支付平台。", SharedConfig.brand_company,SharedConfig.brand_name,SharedConfig.brand_name];

    self.phoneLab.text = SharedBrandInfo.brandPhone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.qmui_height = self.lab3.qmui_bottom + 101;
}
- (IBAction)touchPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", SharedBrandInfo.brandPhone]]];
}

@end
