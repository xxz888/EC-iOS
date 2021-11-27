//
//  NBCollectSureHeader.m
//  Project
//
//  Created by Li Ping on 2019/7/3.
//  Copyright © 2019 LY. All rights reserved.
//

#import "NBCollectSureHeader.h"
#import "MCCashierChooseCard.h"
#import <BRPickerView/BRPickerView.h>

@interface NBCollectSureHeader()

@property (weak, nonatomic) IBOutlet UILabel *daozhangLab;
@property (weak, nonatomic) IBOutlet UILabel *hkCountDownLab;
@property (weak, nonatomic) IBOutlet UILabel *skAmountLab;

@property (weak, nonatomic) IBOutlet UILabel *jrTimLab;
@property (weak, nonatomic) IBOutlet UILabel *zcTimLab;
@property (weak, nonatomic) IBOutlet UILabel *yqLab;



@property (nonatomic, strong) BRAddressPickerView *pickerView;
@end

@implementation NBCollectSureHeader
- (BRAddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeCity];
        _pickerView.title = @"请选择开户省市";
        _pickerView.selectValues = @[@"上海市", @"上海市"];
        __weak __typeof(self)weakSelf = self;
        _pickerView.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
            weakSelf.cityLab.text = [NSString stringWithFormat:@"%@-%@",province,city];
        };
    }
    return _pickerView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (int i = 1000; i<1003; i++) {
        UIView *v = [self viewWithTag:i];
        if (v) {
            v.layer.cornerRadius = v.bounds.size.width/2;
        }
    }
    
    for (int i=3000; i < 3002; i++) {
        UIStackView *v = [self viewWithTag:i];
        if (v) {
//            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionThirdTouched:)];
            [v addGestureRecognizer:tap];
        }
    }
    
    //  到账金额
    self.daozhangLab.text = @"0.00";
    //  还款倒计时
    self.hkCountDownLab.text = @"0";
    //  收款金额
    self.skAmountLab.text = @"0.00";
    
    //  今日加入
    self.jrTimLab.text = @"2019.07.03";
    //  正常还款
    self.zcTimLab.text = @"2019.07.03";
    //  延期还款
    self.yqLab.text = @"2019.07.03";
    
    
    //  到账储蓄卡
    self.cardInfoLab.text =@"中国农业银行(2341)";
    //  开户行省市
    self.cityLab.text = @"上海市-上海市";
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 620);
}

- (void)setFindModel:(NBNPFindBankCardModel *)findModel
{
    _findModel = findModel;
    
    CGFloat allMoney = [findModel.money floatValue];
    CGFloat feeMoney = allMoney * [findModel.channelRate.rate floatValue] + findModel.channelRate.withdrawFee.floatValue + findModel.channelRate.extraFee.floatValue;
    self.daozhangLab.text = [NSString stringWithFormat:@"%.2f", allMoney - feeMoney];
    
    self.hkCountDownLab.text = [NSString stringWithFormat:@"%ld", findModel.period];
    self.skAmountLab.text = findModel.money;
    
    self.jrTimLab.text = findModel.tradTime;
    self.zcTimLab.text = findModel.regularRepaymentTime;
    self.yqLab.text = findModel.npRepaymentTime;
}

- (void)setCardInfo:(MCChooseCardModel *)cardInfo
{
    _cardInfo = cardInfo;
    
    NSString *last = [NSString stringWithFormat:@"%@", [cardInfo.cardNo substringFromIndex:cardInfo.cardNo.length - 4]];
    NSString *bankStr = [NSString stringWithFormat:@"%@(%@)", cardInfo.bankName, last];
    self.cardInfoLab.text = bankStr;
    
    self.cityLab.text = [NSString stringWithFormat:@"%@-%@", cardInfo.province, cardInfo.city];
}

- (void)setBottomCardInfo:(MCChooseCardModel *)bottomCardInfo
{
    _bottomCardInfo = bottomCardInfo;
    
    NSString *last = [NSString stringWithFormat:@"%@", [bottomCardInfo.cardNo substringFromIndex:bottomCardInfo.cardNo.length - 4]];
    NSString *bankStr = [NSString stringWithFormat:@"%@(%@)", bottomCardInfo.bankName, last];
    self.cardInfoLab.text = bankStr;
    
    self.cityLab.text = [NSString stringWithFormat:@"%@-%@", bottomCardInfo.province, bottomCardInfo.city];
}

- (IBAction)sectionTwoAction:(UIButton *)sender {
    NSInteger i = sender.tag - 2200;
    if ([self.delegate respondsToSelector:@selector(collectSureHeaderAction:)]) {
        [self.delegate collectSureHeaderAction:i];
    }
}

- (void)sectionThirdTouched:(UITapGestureRecognizer *)tap {
    NSInteger i = tap.view.tag;
    if (i == 3000) {    //信息安全
        [MCPagingStore pushWebWithTitle:@"信息安全" classification:@"功能跳转"];
    }
    if (i == 3001) {    //资金安全
        [MCPagingStore pushWebWithTitle:@"资金安全" classification:@"功能跳转"];
    }
}
@end
