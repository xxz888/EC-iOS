//
//  LCKFTableHeader.m
//  Lianchuang_477
//
//  Created by wza on 2020/8/19.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "LCKFTableHeader.h"
#import <OEMSDK/OEMSDK.h>

@implementation LCKFTableHeader


- (void)awakeFromNib {
    [super awakeFromNib];
    [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        //MCLog(@"%@",userInfo.mj_keyValues);
    } ];
    self.imgView.image = [UIImage imageNamed:@"lc_kf_header"];
    if (MCModelStore.shared.preUserPhone.length == 11) {
        NSString *pre = [MCModelStore.shared.preUserPhone substringToIndex:3];
        NSString *suf = [MCModelStore.shared.preUserPhone substringFromIndex:MCModelStore.shared.preUserPhone.length - 4];
        self.phoneLab.text = [NSString stringWithFormat:@"%@ **** %@",pre,suf];
    } else {
        NSString *pre = [SharedUserInfo.phone substringToIndex:3];
        NSString *suf = [SharedUserInfo.phone substringFromIndex:SharedUserInfo.phone.length - 4];
        self.phoneLab.text = [NSString stringWithFormat:@"%@ **** %@",pre,suf];
        self.preButton.hidden = YES;
    }
    self.bgImg.image = [[UIImage imageNamed:@"lc_kf_bg"] imageWithColor:BCFI.color_main];
    [self.preButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    self.preButton.layer.cornerRadius = self.preButton.height/2;
    self.imgView.layer.cornerRadius = self.imgView.height/2;
}
- (IBAction)lianxishangji:(id)sender {
    if (MCModelStore.shared.preUserPhone.length == 11) {
        [MCServiceStore call:MCModelStore.shared.preUserPhone];
    } else {
        [MCToast showMessage:@"没有推荐人"];
    }
    
}

@end
