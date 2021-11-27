//
//  MCWalletCollectionViewCell.m
//  MCOEM
//
//  Created by wza on 2020/6/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCWalletCollectionViewCell.h"
#import "MCBankStore.h"
#import "MCBankCardCell.h"

@interface MCWalletCollectionViewCell ()



@end

@implementation MCWalletCollectionViewCell



- (void)setModel:(MCBankCardModel *)model {
    _model = model;
    self.bankNameLab.text = model.bankName;
    if([model.nature containsString:@"借"]){
        if([model.type isEqualToString:@"0"]){
            self.cardTypeLab.text = @"充值卡";
        } else if([model.type isEqualToString:@"2"]){
            self.cardTypeLab.text = @"提现卡";
        }
    } else if([model.nature containsString:@"贷"]) {
        self.cardTypeLab.text = @"充值卡";
    }
    self.dfButton.hidden = !model.idDef;
    [self.dfSwitch setOn:model.idDef];
    
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:model.bankName];
    self.logoImgView.image = info.logo;
    self.bgView.backgroundColor = [info.cardCellBackgroundColor qmui_colorWithAlphaAddedToWhite:0.6];
//    self.bgView.layer.borderColor = [self.bgView.backgroundColor colorWithAlphaComponent:0.1].CGColor;
    self.bgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.waterImgView.image = [info.logo qmui_imageWithAlpha:0.2];
    
    if (model.cardNo.length > 4) {
        self.cardNoLab.text = [NSString stringWithFormat:@"**** %@",[model.cardNo substringFromIndex:model.cardNo.length-4]];
    }
    
    self.cardNameLab.text = model.cardType;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dfSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    self.bgView.backgroundColor = UIColor.qmui_randomColor;
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.borderWidth = 1.f;
    
    self.dfButton.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    self.dfButton.layer.borderWidth = 1.0;
    self.dfButton.layer.cornerRadius = 4.f;
    
}
- (IBAction)onButtonTouched:(UIButton *)sender {
    MCLog(@"%ld",sender.tag);
    if (sender.tag == 1000) {
        self.block(MCBankCardCellActionDefault, self.model);
    } else if (sender.tag == 1001) {
        self.block(MCBankCardCellActionModify, self.model);
    } else if (sender.tag == 1002) {
        self.block(MCBankCardCellActionDelete, self.model);
    }
}

@end
