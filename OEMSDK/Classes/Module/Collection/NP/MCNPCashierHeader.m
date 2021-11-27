//
//  MCNPCashierHeader.m
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCNPCashierHeader.h"
#import "MCBankCardModel.h"
#import "NBNPFindBankCardModel.h"
#import "MCChooseCardModel.h"
#import "MCBankStore.h"
#import "MCCashierChooseCard.h"
#import "NBCollectSureController.h"
#import "MCOrderListController.h"
#import "KDCommonAlert.h"



@interface MCNPCashierHeader ()<MCCashierChooseCardDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bg1;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNameView;
@property (weak, nonatomic) IBOutlet UIImageView *bankIconView;
@property (weak, nonatomic) IBOutlet UITextField *moneyView;

@property(nonatomic, strong) MCChooseCardModel *xinyongInfo;
@property (nonatomic, strong) NBNPFindBankCardModel *findModel;


@property(nonatomic, strong) MCCashierChooseCard *chooseXinyong;


@end

@implementation MCNPCashierHeader
- (MCCashierChooseCard *)chooseXinyong {
    if (!_chooseXinyong) {
        _chooseXinyong = [[MCCashierChooseCard alloc] initWithType:MCCashierChooseCardXinyong];
        _chooseXinyong.delegate = self;
    }
    return _chooseXinyong;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bg1.clipsToBounds = YES;
    self.bg1.layer.cornerRadius = 15;
    self.bg1.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    self.bg1.layer.shadowOffset = CGSizeMake(0,1);
    self.bg1.layer.shadowOpacity = 1;
    self.bg1.layer.shadowRadius = 4;
    self.nextButton.layer.borderColor = [UIColor qmui_colorWithHexString:@"#C5C5C5"].CGColor;
    self.nextButton.layer.borderWidth = 1;
    self.nextButton.layer.cornerRadius = self.nextButton.ly_height/2;
    for (int i = 2000; i < 2004; i++) {
        UIView *itemView = [self viewWithTag:i];
        if (itemView) {
            itemView.layer.cornerRadius = 6;
            itemView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemTouched:)];
            [itemView addGestureRecognizer:tap];
        }
    }
    UIStackView *feeS = [self viewWithTag:1000];
    if (feeS) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFeeTouched:)];
        [feeS addGestureRecognizer:tap];
    }
    
    //  费率
    self.rateLab.text = @"费率：0.00";
    //  手续费
    self.feeLab.text = @"手续费：0.00";
    
    self.moneyView.delegate = self;
    
//    [self requestDefaultXinyong];
}
- (void)setXinyongInfo:(MCChooseCardModel *)xinyongInfo {
    _xinyongInfo = xinyongInfo;
    if (xinyongInfo.billDay.intValue == 0) {
        kWeakSelf(self);
        KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
        [commonAlert initKDCommonAlertContent:@"您的信用卡信息填写不完整，请补充完整"  isShowClose:NO];
        commonAlert.rightActionBlock = ^{
            MCBankCardModel *model = [MCBankCardModel mj_objectWithKeyValues:xinyongInfo.mj_keyValues];
            
            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
            [info setObject:@(MCBankCardTypeXinyongka) forKey:@"type"];
            if (model) {
                [info setObject:model forKey:@"model"];
            }
            [MCPagingStore pagingURL:rt_card_edit withUerinfo:info];
            weakself.bankNameView.text = @"银行卡信息";
            weakself.bankIconView.image = [UIImage mc_imageNamed:@"logo"];
        };
        
        
        
        
//        [MCAlertStore showWithTittle:@"温馨提示" message:@"您的信用卡信息填写不完整，请补充完整" buttonTitles:@[@"我知道了", @"完善信息"] sureBlock:^{
//            MCBankCardModel *model = [MCBankCardModel mj_objectWithKeyValues:xinyongInfo.mj_keyValues];
//
//            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
//            [info setObject:@(MCBankCardTypeXinyongka) forKey:@"type"];
//            if (model) {
//                [info setObject:model forKey:@"model"];
//            }
//            [MCPagingStore pagingURL:rt_card_edit withUerinfo:info];
//            self.bankNameView.text = @"银行卡信息";
//            self.bankIconView.image = [UIImage mc_imageNamed:@"logo"];
//        }];
    }
    MCBankCardInfo *bankInfo = [MCBankStore getBankCellInfoWithName:xinyongInfo.bankName];
    self.bankIconView.image = bankInfo.logo;
    NSString *cardNo = [NSString stringWithFormat:@"%@",xinyongInfo.cardNo];
    if (cardNo && cardNo.length > 4) {
        self.bankNameView.text = [NSString stringWithFormat:@"%@ %@",xinyongInfo.bankName,[cardNo substringFromIndex:cardNo.length-4]];
    }
}
#pragma mark - Actions

- (void)onItemTouched:(UITapGestureRecognizer *)tap {
    NSInteger i = tap.view.tag - 2000;
    if (i == 0) {   //NP介绍
        [MCPagingStore pushWebWithTitle:@"介绍NP" classification:@"功能跳转"];
    }
    if (i == 1) {   //订单明细
        MCOrderListController *npList = [[MCOrderListController alloc] initWithType:MCOrderListTypeNP];
        [MCLATESTCONTROLLER.navigationController pushViewController:npList animated:YES];
    }
    if (i == 2) {   //在线客服
        if ([self.delegate respondsToSelector:@selector(clickServiceOnLine)]) {
            [self.delegate clickServiceOnLine];
        }
    }
    if (i == 3) {   //操作流程
        [MCPagingStore pushWebWithTitle:@"操作流程" classification:@"功能跳转"];
    }
    
}
- (IBAction)onNextChanged:(id)sender {
    if ([self.moneyView.text floatValue] >= self.findModel.channel.singleMinLimit.floatValue && [self.moneyView.text floatValue] <= self.findModel.channel.singleMaxLimit.floatValue) {
        self.findModel.money = self.moneyView.text;
        
        NBCollectSureController *sureVC = [NBCollectSureController new];
        sureVC.findCardModel = self.findModel;
        sureVC.xykModel = self.xinyongInfo;
        [MCLATESTCONTROLLER.navigationController pushViewController:sureVC animated:YES];
        
    } else {
        [MCToast showMessage:@"您输入的金额不符合提现要求，请重新输入"];
    }
}

#pragma mark - Actions
- (void)onFeeTouched:(UITapGestureRecognizer *)tap {
    [MCToast showMessage:@"匹配的通道不同，费率页可能不同"];
}

- (IBAction)onChangeTouched:(id)sender {
    [self endEditing:YES];
    [self.chooseXinyong show];
}


- (void)nocardAlertShowWithMessage:(NSString *)msg type:(MCBankCardType)cardType cardModel:(MCChooseCardModel *)cardModel {
    if (![QMUIAlertController isAnyAlertControllerVisible]) {
        
        QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"温馨提示" message:msg preferredStyle:QMUIAlertControllerStyleAlert];
        
        [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//            [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"去绑卡" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            MCBankCardModel *model = nil;
            if (cardModel) {
                model = [MCBankCardModel mj_objectWithKeyValues:cardModel.mj_keyValues];
            }
            [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(cardType)}];
            
        }]];
        [alert showWithAnimated:YES];
    }
}

#pragma mark - Requst
- (void)requestDefaultXinyong {
    __weak __typeof(self)weakSelf = self;
    
    NSDictionary *p1 = @{@"userId":SharedUserInfo.userid,
                         @"type":@"0",
                         @"nature":@"0",
                         @"isDefault":@"1"};
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:p1 ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temp = [MCChooseCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (MCChooseCardModel *model in temp) {
            if (!model.billDay || !model.repaymentDay) {
                [weakSelf nocardAlertShowWithMessage:@"您的信用卡信息填写不完整，请补充完整" type:MCBankCardTypeXinyongka cardModel:model];
            } else {
                weakSelf.xinyongInfo = model;
                [weakSelf findNPBankCardInfo:model];
            }
            break;
        }
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        if ([resp.code isEqualToString:@"666666"]) {
            [weakSelf nocardAlertShowWithMessage:resp.messege type:MCBankCardTypeXinyongka cardModel:nil];
        } else {
            [MCToast showMessage:resp.messege];
        }
    }];
}
- (void)findNPBankCardInfo:(MCChooseCardModel *)cardInfo {
    NSDictionary *param = @{@"userId":cardInfo.userId,
                            @"bank_card":cardInfo.cardNo,
                            @"cardType":@"1"
    };
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/user/app/bank/np/find" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        NBNPFindBankCardModel *model = [NBNPFindBankCardModel mj_objectWithKeyValues:resp.result];
        weakSelf.findModel = model;
        // 费率
        float rate = [model.channelRate.rate floatValue] * 100;
        weakSelf.rateLab.text = [NSString stringWithFormat:@"费率:%.2f%%+%.0f元", rate, model.channelRate.extraFee.floatValue + model.channelRate.withdrawFee.floatValue];
        weakSelf.feeLab.text = [NSString stringWithFormat:@"手续费：%.2f元", model.channelRate.extraFee.floatValue + model.channelRate.withdrawFee.floatValue];
        
        weakSelf.moneyView.placeholder = [NSString stringWithFormat:@"请输入金额，单笔%@-%@元", model.channel.singleMinLimit, model.channel.singleMaxLimit];
    }];
}
#pragma mark - MCCashierChooseCardDelegate
- (void)cashierChoose:(MCCashierChooseCard *)choose DidSelectedCard:(MCChooseCardModel *)cardInfo {
    self.xinyongInfo = cardInfo;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *moneyStr = str;
    if (moneyStr.length > 0) {
        CGFloat allMoney = [moneyStr floatValue];
        CGFloat rate = [self.findModel.channelRate.rate floatValue];
        CGFloat fee = self.findModel.channelRate.withdrawFee.floatValue + self.findModel.channelRate.extraFee.floatValue;
        CGFloat money = rate * allMoney + fee;
        self.feeLab.text = [NSString stringWithFormat:@"手续费：%.2f元", money];
    }
    return YES;
}



@end
