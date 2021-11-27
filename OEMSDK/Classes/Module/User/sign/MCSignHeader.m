//
//  MCSignHeader.m
//  MCOEM
//
//  Created by wza on 2020/4/16.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCSignHeader.h"


@interface MCSignHeader ()

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UIButton *mallBtn;
@property (weak, nonatomic) IBOutlet UILabel *allLab;
@property (weak, nonatomic) IBOutlet QMUISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;

@end



@implementation MCSignHeader



- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor mainColor];
    [self.mallBtn setBackgroundColor:self.backgroundColor];
    self.mallBtn.layer.cornerRadius = 5;
    self.signBtn.layer.cornerRadius = self.signBtn.qmui_height/2;
    [self.signBtn setBackgroundColor:UIColor.whiteColor];
    [self.signBtn setTitleColor:self.backgroundColor forState:UIControlStateNormal];
    [self.signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [self.signBtn setTitle:@"已签到" forState:UIControlStateDisabled];
    
    self.slider.trackHeight = 5;
    self.slider.thumbSize = CGSizeMake(15, 15);
    self.slider.backgroundColor = UIColor.clearColor;
    self.slider.minimumTrackTintColor = UIColor.whiteColor;
    self.slider.maximumTrackTintColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.slider.thumbColor = UIColor.whiteColor;
    self.slider.userInteractionEnabled = NO;
    
    
    [self requestTodaySign];
    [self requestSignInfo];
    [self requestCoin];
    self.allLab.text = [NSString stringWithFormat:@"%@",SharedUserInfo.coin];
}
//累计签的天数
- (void)requestSignDays:(NSDictionary *)signInfo {
    [MCSessionManager.shareManager mc_POST:@"/user/app/signin/getsign" parameters:@{@"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        NSInteger leiji = ((NSArray*)resp.result).count;
        self.lab2.text = [NSString stringWithFormat:@"累计签到%lu天",(unsigned long)leiji];
        if (!signInfo) {
            return;
        }
        
        CGFloat value = leiji/([signInfo[@"bonuscoin"] floatValue] + [signInfo[@"days"] floatValue]);
        
        [self.slider setValue:value animated:YES];
    }];
}
//今日是否签到
- (void)requestTodaySign {
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/signin/isdosign" parameters:@{@"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        BOOL sign = [resp.result boolValue];
        self.signBtn.enabled = !sign;
    }];
}

- (void)requestSignInfo {
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/signin/getsigncoin/andbonusdays" parameters:@{@"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        self.lab1.text = [NSString stringWithFormat:@"今日+%@积分，距离额外奖励还有%@天",resp.result[@"bonuscoin"],resp.result[@"days"]];
        self.lab3.text = [NSString stringWithFormat:@"+%@",resp.result[@"bonuscoin"]];
        [self requestSignDays:resp.result];
    }];
}

- (void)requestCoin {
    __weak __typeof(self)weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"user/app/signin/getsigncoin/" parameters:@{@"brandId":SharedConfig.brand_id,@"grade":SharedUserInfo.grade} ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *arr = resp.result;
        if (!arr || arr.count == 0) {
            return;
        }
        weakSelf.lab4.text = [NSString stringWithFormat:@"+%@分",resp.result[0][@"bonusCoin"]];
        weakSelf.lab5.text = [NSString stringWithFormat:@"累计%@天",resp.result[0][@"continueDays"]];
        
        [MCModelStore.shared getUserAccount:^(MCAccountModel * _Nonnull accountModel) {
            weakSelf.allLab.text = accountModel.coin;
        }];
    }];
    
    
}


- (IBAction)mallClick:(id)sender {
    [MCPagingStore pushWebWithTitle:@"商城" classification:@"功能跳转"];
}
- (IBAction)signTouched:(id)sender {
    [MCSessionManager.shareManager mc_POST:@"/user/app/signin/dosign" parameters:@{@"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        [MCLATESTCONTROLLER.mc_tableview.mj_header beginRefreshing];
    }];
}

@end
