//
//  MCCashierChooseCell.m
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCCashierChooseCell.h"
#import "MCBankStore.h"


@interface MCCashierChooseCell ()

@property(nonatomic, strong) MCChooseCardModel *model;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@end

@implementation MCCashierChooseCell

+ (instancetype)cellForTableView:(UITableView *)tableview cardInfo:(MCChooseCardModel *)model {
    static NSString *cellID = @"MCCashierChooseCell";
    MCCashierChooseCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    cell.model = model;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tagButton setBackgroundColor:MAINCOLOR];
    self.tagButton.layer.cornerRadius = self.tagButton.height/2;
}

-(void)setFrame:(CGRect)frame{
    frame.origin.y += 1;
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (void)setModel:(MCChooseCardModel *)model {
    _model = model;
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:model.bankName];
    self.imgView.image = info.logo;
    self.lab1.text = model.bankName;
    self.lab2.text = model.cardType;
    NSString *subCardString = [model.cardNo substringWithRange:NSMakeRange(4, model.cardNo.length - 3 - 4)];
    self.lab3.text = [model.cardNo stringByReplacingOccurrencesOfString:subCardString withString:@" **** **** **** "];
    if (model.type && [model.type isEqualToString:@"0"]) {
        [self.tagButton setTitle:@"充值卡" forState:UIControlStateNormal];
    }
    if (model.type && [model.type isEqualToString:@"2"]) {
        [self.tagButton setTitle:@"提现卡" forState:UIControlStateNormal];
    }
    
    self.maskView.hidden = !model.useState.boolValue;
}

@end
