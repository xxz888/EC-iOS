//
//  MCChooseChannelCell.m
//  Project
//
//  Created by Li Ping on 2019/7/15.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCChooseChannelCell.h"

@interface MCChooseChannelCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UILabel *tipsLowLab;


@property(nonatomic, strong) MCChannelModel *model;
@property(nonatomic, copy) NSString *amount;

@end

@implementation MCChooseChannelCell

+ (instancetype)cellFromTableView:(UITableView *)tableview channelInfo:(MCChannelModel *)model amount:(NSString *)amount {
    static NSString *CELL_ID = @"MCChooseChannelCell";
    MCChooseChannelCell *cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:CELL_ID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:CELL_ID];
        cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
    }
    cell.amount = amount;
    cell.model = model;
    
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.cornerRadius = 4;
    
}

- (void)setModel:(MCChannelModel *)model {
    _model = model;
    [self setModel:model amount:self.amount.doubleValue];
}

- (void)setModel:(MCChannelModel *)model amount:(double)amount {
    
    self.nameLab.text = [NSString stringWithFormat:@"%@%@",model.name,model.channelParams];
    
    self.tipsLab.textColor = [UIColor orangeColor];
    self.tipsLab.text = @"提示：2小时内到账（不限日期，快速到账）";
    if (model.singleMaxLimit.floatValue < 10000) {
        self.lab1.text = [NSString stringWithFormat:@"单笔限额：%d元-%d元", model.singleMinLimit.intValue, model.singleMaxLimit.intValue];
    } else {
        self.lab1.text = [NSString stringWithFormat:@"单笔限额：%d元-%d万元", model.singleMinLimit.intValue, (int)(model.singleMaxLimit.floatValue / 10000)];
    }
    
    self.lab2.text = [NSString stringWithFormat:@"交易时间：%@-%@", model.startTime, model.endTime];
    NSString *serviceCharge = [NSString stringWithFormat:@"%.2f元", amount * model.rate.doubleValue];

    self.lab3.text = [NSString stringWithFormat:@"手续费用：%@", serviceCharge];
    int maxLimit = model.everyDayMaxLimit.intValue;
    if (maxLimit >= 10000) {
        maxLimit = maxLimit / 10000;
        self.lab4.text = [NSString stringWithFormat:@"每日限额：%d万元", maxLimit];
    } else {
        self.lab4.text = [NSString stringWithFormat:@"每日限额：%d元", maxLimit];
    }
    
    self.lab5.text = [NSString stringWithFormat:@"交易费率：%.2f%%+%.2f元", model.rate.floatValue *100, model.extraFee.floatValue];
    self.lab6.text = [NSString stringWithFormat:@"实际到账：%.2f元", amount - amount * model.rate.floatValue - model.extraFee.floatValue];
    self.tipsLowLab.text = model.remarks;
}


@end
