//
//  MCCashierHeader.m
//  MCOEM
//
//  Created by wza on 2020/5/4.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCCashierHeader.h"
#import "MCCashierKeyBoard.h"
#import "MCBankStore.h"
#import "MCCashierChooseCard.h"
#import "MCChooseCardModel.h"
#import "MCChannelModel.h"
#import "MCDefaultChannelAlert.h"
#import "WBQRCodeVC.h"
#import "MCChooseChannelController.h"
#import "KDCommonAlert.h"

#define kOpenH 230.0
#define kCloseH 160.0

@interface MCCashierHeader ()<MCCashierKeyBoardDelegate, MCCashierChooseCardDelegate, WBQRCodeVCDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;


@property (weak, nonatomic) IBOutlet UILabel *xinyongLab;
@property (weak, nonatomic) IBOutlet UILabel *chuxuLab;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIImageView *xinyongImg;
@property (weak, nonatomic) IBOutlet UIImageView *chuxuImg;
@property (weak, nonatomic) IBOutlet UIImageView *appLogoImgView;



@property (weak, nonatomic) IBOutlet UITextField *amountTF;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *kbView;

@property(nonatomic, strong) MCChooseCardModel *xinyongInfo;
@property(nonatomic, strong) MCChooseCardModel *chuxuInfo;
@property(nonatomic, strong) MCChannelModel *channelInfo;

@property(nonatomic, strong) MCCashierKeyBoard *keyBoard;

@property(nonatomic, strong) MCCashierChooseCard *chooseXinyong;
@property(nonatomic, strong) MCCashierChooseCard *chooseChuxu;

@property(nonatomic, strong) MCDefaultChannelAlert *alert;

@property(nonatomic, copy) NSString *orderCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kbH;

@property (weak, nonatomic) IBOutlet UILabel *zaixianLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;



@end

@implementation MCCashierHeader
#pragma mark - GETTER & SETTER
- (MCCashierChooseCard *)chooseChuxu {
    if (!_chooseChuxu) {
        _chooseChuxu = [[MCCashierChooseCard alloc] initWithType:MCCashierChooseCardChuxu];
        _chooseChuxu.delegate = self;
    }
    return _chooseChuxu;
}
- (MCCashierChooseCard *)chooseXinyong {
    if (!_chooseXinyong) {
        _chooseXinyong = [[MCCashierChooseCard alloc] initWithType:MCCashierChooseCardXinyong];
        _chooseXinyong.delegate = self;
    }
    return _chooseXinyong;
}
- (MCCashierKeyBoard *)keyBoard {
    if (!_keyBoard) {
        _keyBoard = [MCCashierKeyBoard newFromNib];
        _keyBoard.delegate = self;
    }
    return _keyBoard;
}
- (void)setXinyongInfo:(MCChooseCardModel *)xinyongInfo {
    _xinyongInfo = xinyongInfo;
    MCBankCardInfo *ii = [MCBankStore getBankCellInfoWithName:xinyongInfo.bankName];
    self.xinyongImg.image = ii.logo;
    NSString *cardNo = xinyongInfo.cardNo;
    if (cardNo && cardNo.length > 4) {
        self.xinyongLab.text = [NSString stringWithFormat:@"%@ 尾号：%@",xinyongInfo.bankName,[cardNo substringFromIndex:cardNo.length-4]];
    }
}
- (void)setChuxuInfo:(MCChooseCardModel *)chuxuInfo {
    _chuxuInfo = chuxuInfo;
    MCBankCardInfo *ii = [MCBankStore getBankCellInfoWithName:chuxuInfo.bankName];
    self.chuxuImg.image = ii.logo;
    NSString *cardNo = chuxuInfo.cardNo;
    if (cardNo && cardNo.length > 4) {
        self.chuxuLab.text = [NSString stringWithFormat:@"%@ 尾号：%@",chuxuInfo.bankName,[cardNo substringFromIndex:cardNo.length-4]];
    }
}

#pragma mark - Life
- (void)awakeFromNib {
    [super awakeFromNib];
    self.view1.backgroundColor = MAINCOLOR;
    self.topConstraint.constant += StatusBarHeight;
    self.view2.layer.cornerRadius = 5;
    [self.kbView addSubview:self.keyBoard];
    self.heightConstraint.constant = kCloseH;
    
    self.sureButton.layer.cornerRadius = 4;
    [self.sureButton setBackgroundColor:MAINCOLOR];
    self.appLogoImgView.layer.cornerRadius = 8;
    self.appLogoImgView.image = SharedAppInfo.icon;
    [self.amountTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    self.xinyongLab.text = @"";
    self.chuxuLab.text = @"";
    
    self.xinyongImg.image = nil;
    self.chuxuImg.image = nil;
    
//    [self requestDefaultCards];
    
    self.zaixianLab.text = [NSString stringWithFormat:@"%@在线收款",SharedConfig.brand_name];
    self.descLab.text = [NSString stringWithFormat:@"由%@平台提供技术支持",SharedConfig.brand_company];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.keyBoard.frame = self.kbView.bounds;
    
    self.kbH.constant = 0.4*MCSCALE*SCREEN_HEIGHT;
}
- (void)dealloc
{
    [self.amountTF removeObserver:self forKeyPath:@"text"];
}

- (void)nocardAlertShowWithMessage:(NSString *)msg type:(MCBankCardType)cardType cardModel:(MCChooseCardModel *)cardModel {
    if (![QMUIAlertController isAnyAlertControllerVisible]) {
        
        QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"温馨提示" message:msg preferredStyle:QMUIAlertControllerStyleAlert];
        
        [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:NO];
        }]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"去绑卡" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            MCBankCardModel *model = nil;
            if (cardModel) {
                model = [MCBankCardModel mj_objectWithKeyValues:cardModel.mj_keyValues];
            }
            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
            [info setObject:@(cardType) forKey:@"type"];
            if (model) {
                [info setObject:model forKey:@"model"];
            }
            [MCPagingStore pagingURL:rt_card_edit withUerinfo:info];
        }]];
        [alert showWithAnimated:YES];
    }
}
#pragma mark - 获取默认卡
- (void)requestDefaultCards {
    
    __weak __typeof(self)weakSelf = self;
    
    //默认信用卡
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
    
    //默认储蓄卡
    NSDictionary *p2 = @{@"userId":SharedUserInfo.userid,
                         @"type":@"2",
                         @"nature":@"2",
                         @"isDefault":@"1"};
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:p2 ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temp = [MCChooseCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (MCChooseCardModel *model in temp) {
            weakSelf.chuxuInfo = model;
            break;
        }
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        if ([resp.code isEqualToString:@"666666"]) {
            [weakSelf nocardAlertShowWithMessage:resp.messege type:MCBankCardTypeChuxuka cardModel:nil];
        } else {
            [MCToast showMessage:resp.messege];
        }
    }];
}
#pragma mark - 默认通道
- (void)requestDefaultChannel {
    NSDictionary *param = @{@"userId":SharedUserInfo.userid,
                            @"brandId":SharedConfig.brand_id,
                            @"bankCard":self.xinyongInfo.cardNo,
                            @"amount":@(self.amountTF.text.floatValue),
                            @"recommend":@"1"};
    [MCSessionManager.shareManager mc_POST:@"/user/app/channel/getchannel/bybankcard/andamount" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temp = [MCChannelModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (MCChannelModel *channelInfo in temp) {
            self.channelInfo = channelInfo;
            self.alert = [[MCDefaultChannelAlert alloc] init];
            __weak __typeof(self)weakSelf = self;
            [self.alert showWithChannelInfo:channelInfo amount:self.amountTF.text changeHandler:^(MCChannelModel * _Nonnull model) {
                //TODO: 切换通道
                MCChooseChannelController *vc = [[MCChooseChannelController alloc] initWithCardNo:weakSelf.xinyongInfo.cardNo amount:weakSelf.amountTF.text handler:^(MCChannelModel * _Nonnull model) {
                    weakSelf.channelInfo = model;
                    [weakSelf launchPay];
                }];
                [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
            } sureHandler:^(MCChannelModel * _Nonnull model) {
                [weakSelf launchPay];
            }];
            break;
        }
    }];
}
#pragma mark - 点击收款
- (void)shoukuan {  //收款
    if (!self.xinyongInfo) {
        [MCToast showMessage:@"请选择充值卡"];
        return;
    }
    if (!self.chuxuInfo) {
        [MCToast showMessage:@"请选择提现卡"];
        return;
    }
    if (self.amountTF.text.floatValue < 100) {
        [MCToast showMessage:@"最小输入金额100元"];
        return;
    }
    [self requestDefaultChannel];
}
#pragma mark - 发起支付
- (void)launchPay {
    NSString *phone = SharedUserInfo.phone;
    NSString *order_desc = [NSString stringWithFormat:@"%@%@", self.channelInfo.name,self.channelInfo.channelParams];
    NSString *channe_tag = [NSString stringWithFormat:@"%@", self.channelInfo.channelTag];
    
    NSDictionary *param = @{
                            @"amount":self.amountTF.text,
                            @"orderDesc":order_desc,
                            @"phone":phone,
                            @"channeTag":channe_tag,
                            @"brandId":SharedConfig.brand_id,
                            @"userId":SharedUserInfo.userid,
                            @"bankCard":self.xinyongInfo.cardNo,
                            @"creditBankName":self.xinyongInfo.bankName};
    
    [MCSessionManager.shareManager mc_POST:@"/facade/app/topup/new" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        if (resp.result && [resp.result isKindOfClass:[NSString class]] && [resp.result containsString:@"http"]) {
            [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp.result}];
        } else {
            //扫码
            if ([resp.result isKindOfClass:[NSString class]]) {
                self.orderCode = resp.result;
                WBQRCodeVC *qrVC = [[WBQRCodeVC alloc] init];
                qrVC.delegate = self;
                [MCLATESTCONTROLLER.navigationController pushViewController:qrVC animated:YES];
            } else {
                [MCToast showMessage:@"生成订单失败，请重试"];
            }
        }
        
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        if ([resp.code isEqualToString:@"666666"]) {
            if (resp.result && [resp.result isKindOfClass:[NSString class]] && [resp.result containsString:@"http"]) {  //花呗身份校验
                [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp.result}];
            } else {
                [MCToast showMessage:resp.result];
            }
        } else {
            [MCToast showMessage:resp.messege];
        }
    }];
}
#pragma mark - Actions
- (IBAction)sureTouched:(UIButton *)sender {
    [self shoukuan];
}
- (IBAction)changeXinyong:(UIButton *)sender {
    [self.chooseXinyong show];
}
- (IBAction)changeChuxu:(UIButton *)sender {
    [self.chooseChuxu show];
}

- (IBAction)backAction:(UIButton *)sender {
    [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"] && object== self.amountTF) {
        if (self.amountTF.text && self.amountTF.text.length && self.heightConstraint.constant < kOpenH) {
            [UIView animateWithDuration:0.3 animations:^{
                self.heightConstraint.constant = kOpenH;
                [self layoutIfNeeded];
            }];
        } else if (self.amountTF.text.length == 0 && self.heightConstraint.constant == kOpenH) {
            [UIView animateWithDuration:0.3 animations:^{
                self.heightConstraint.constant = kCloseH;
                [self layoutIfNeeded];
            }];
        }
    } else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark - MCCashierKeyBoardDelegate
- (void)cashierKeyBoardDidClickOnTitle:(NSString *)title {
    if ([title isEqualToString:@"退格"]) {
        if (self.amountTF.text.length != 0) {
            self.amountTF.text = [self.amountTF.text substringToIndex:self.amountTF.text.length-1];
        }
    } else if ([title isEqualToString:@"清除"]) {
        if (self.amountTF.text.length != 0) {
            self.amountTF.text = @"";
        }
    } else if ([title isEqualToString:@"收款"]) {
        [self shoukuan];
    } else {    //数字和'.'
        if ([title isEqualToString:@"0"] || [title isEqualToString:@"."]) {
            if (self.amountTF.text.length == 0) {
                self.amountTF.text = [NSString stringWithFormat:@"0."];
                return;
            }
        }
        if ([self.amountTF.text containsString:@"."] && [title isEqualToString:@"."]) {
            return;
        }
        self.amountTF.text = [self.amountTF.text stringByAppendingString:title];
    }
}

#pragma mark - MCCashierChooseCardDelegate
- (void)cashierChoose:(MCCashierChooseCard *)choose DidSelectedCard:(MCChooseCardModel *)cardInfo {
    if (choose == self.chooseXinyong) {
        if (!cardInfo.billDay || !cardInfo.repaymentDay) {
            [self nocardAlertShowWithMessage:@"您的信用卡信息填写不完整，请补充完整" type:MCBankCardTypeXinyongka cardModel:cardInfo];
        } else {
            self.xinyongInfo = cardInfo;
        }
        return;
    }
    if (choose == self.chooseChuxu) {
        self.chuxuInfo = cardInfo;
        return;
    }
}
#pragma mark - WBQRCodeVCDelegate
- (void)scancodeViewControllerComplete:(NSString *)str {
    if (!str || str.length < 1) {
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"您正在发起一笔%@元的收款，确定后将从对方支付宝账户自动扣款", self.amountTF.text];
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:msg  isShowClose:NO];
//    [commonAlert initKDCommonAlertTitle:@"温馨提示" content:msg leftBtnTitle:@"取消" rightBtnTitle:@"确定" ];
    commonAlert.rightActionBlock = ^{
       NSDictionary *param = @{@"authCode":str,@"orderCode":self.orderCode};
       [MCSessionManager.shareManager mc_POST:@"/facade/topup/yxhb/trade" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
           if (resp.result && [resp.result isKindOfClass:[NSString class]] && [resp.result containsString:@"http"]) {
               [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp.result}];
           }
       }];
    };
    
//    NSString *msg = [NSString stringWithFormat:@"您正在发起一笔%@元的收款，确定后将从对方支付宝账户自动扣款", self.amountTF.text];
//    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:QMUIAlertControllerStyleAlert];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//
//        NSDictionary *param = @{@"authCode":str,@"orderCode":self.orderCode};
//        [MCSessionManager.shareManager mc_POST:@"/facade/topup/yxhb/trade" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
//            if (resp.result && [resp.result isKindOfClass:[NSString class]] && [resp.result containsString:@"http"]) {
//                [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp.result}];
//            }
//        }];
//
//    }]];
//    [alert showWithAnimated:YES];
}


@end
