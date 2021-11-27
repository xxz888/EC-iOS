//
//  MCBankCardCell.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBankCardCell.h"
#import "MCBankStore.h"
#import "KDCommonAlert.h"

@implementation MCBankCardCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *cellID = @"MCBankCardCell";
    MCBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cenView.layer.masksToBounds = YES;
    self.cenView.layer.cornerRadius = 8.f;
    self.defBtn.layer.masksToBounds = YES;
    self.defBtn.layer.cornerRadius = 8.f;
    self.logo.backgroundColor = UIColorWhite;
    self.logo.layer.cornerRadius = self.logo.qmui_width/2;
    self.modifyBtn.layer.cornerRadius = self.modifyBtn.qmui_height/2;
    
    self.defBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 6, 3, 6);
}

- (void)setModel:(MCBankCardModel *)model {
    _model = model;
    self.bankName.text = model.bankName;
    NSString *firstName = [model.userName substringWithRange:NSMakeRange(0, 1)];
    if (model.userName.length == 2) {
        self.username.text = [NSString stringWithFormat:@"（%@*）", firstName];
    } else {
        NSString *last = [model.userName substringFromIndex:model.userName.length-1];
        self.username.text = [NSString stringWithFormat:@"（%@*%@）", firstName, last];
    }
    
    
    if([model.nature containsString:@"借"]){
        self.defBtn.hidden = NO;
        if([model.type isEqualToString:@"0"]){
            self.cardType.text = @"充值卡";
        } else if([model.type isEqualToString:@"2"]){
            self.cardType.text = @"提现卡";
        }
        
        
    } else if([model.nature containsString:@"贷"]) {
        self.defBtn.hidden = YES;
        self.cardType.text = @"充值卡";
                
    } else {
        [MCToast showMessage:@"发现未识别的卡"];
    }
    
    NSString *subCardString = [model.cardNo substringWithRange:NSMakeRange(4, model.cardNo.length - 3 - 4)];
    self.cardNo.text = [model.cardNo stringByReplacingOccurrencesOfString:subCardString withString:@" **** **** **** "];
    
    self.cardDetail.text = model.cardType;
    
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:model.bankName];
    self.logo.image = info.logo;
    self.bgImage.backgroundColor = [info.cardCellBackgroundColor qmui_colorWithAlphaAddedToWhite:0.6];
    if(model.idDef){
        [self.defBtn setTitle:@"默认卡" forState:UIControlStateNormal];
        self.defBtn.userInteractionEnabled = NO;
        self.defBtn.layer.borderWidth = 0;
    } else {
        [self.defBtn setTitle:@"设为默认卡" forState:UIControlStateNormal];
        self.defBtn.userInteractionEnabled = YES;
        self.defBtn.layer.borderWidth = 1;
        self.defBtn.layer.borderColor = UIColorWhite.CGColor;
        self.defBtn.layer.cornerRadius = self.defBtn.height/2;
    }
}
- (IBAction)defBtnTouched:(id)sender {  //设为默认
    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/default/%@",TOKEN] parameters:@{@"cardno":self.model.cardNo} ok:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:@"设置成功"];
        self.block(MCBankCardCellActionDefault, self.model);
    }];
}
- (IBAction)delBtnTouched:(id)sender {  //删除卡片

    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:@"确定要解绑此银行卡吗？"  isShowClose:NO];
    kWeakSelf(self);

    commonAlert.rightActionBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/del/%@",TOKEN] parameters:@{@"cardno":self.model.cardNo,@"type":self.model.type} ok:^(MCNetResponse * _Nonnull resp) {
                  //删除成功发送一个通知让 KDWebContainer 重新设置
                  [MCToast showMessage:@"删除成功"];
                
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"mcNotificationWebContainnerReset" object:nil];
                weakself.block(MCBankCardCellActionDelete, weakself.model);
            }];
        });

    };
    
//    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要解绑此银行卡吗？" preferredStyle:QMUIAlertControllerStyleAlert];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"解绑" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//        [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/del/%@",TOKEN] parameters:@{@"cardno":self.model.cardNo,@"type":self.model.type} ok:^(MCNetResponse * _Nonnull resp) {
//            //删除成功发送一个通知让 KDWebContainer 重新设置
//            [MCToast showMessage:@"删除成功"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"mcNotificationWebContainnerReset" object:nil];
//            self.block(MCBankCardCellActionDelete, self.model);
//        }];
//    }]];
//    [alert showWithAnimated:YES];
    
}
- (IBAction)modifyTouched:(id)sender {  //修改
    self.block(MCBankCardCellActionModify, self.model);
}

@end
