//
//  MCOrderListCell.m
//  MCOEM
//
//  Created by wza on 2020/4/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCOrderListCell.h"

@interface MCOrderListCell ()

@property(nonatomic, strong) MCOrderModel *model;

@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;




@end



@implementation MCOrderListCell

+ (instancetype)cellWithTableview:(UITableView *)tableView orderModel:(MCOrderModel *)model {
    static NSString *cellID = @"MCOrderListCell";
    MCOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.typeLab.textColor = UIColorBlack;
    self.timeLab.textColor = UIColorBlack;
    self.moneyLab.textColor = MAINCOLOR;
    self.statusLab.textColor = UIColorGrayDarken;
}

- (void)setModel:(MCOrderModel *)model {
    _model = model;
    self.typeLab.text = model.desc;
    self.timeLab.text = model.updateTime;
    if ([model.realAmount containsString:@"+"] || [model.realAmount containsString:@"-"]) {
        self.moneyLab.text = [NSString stringWithFormat:@"%.2f",model.realAmount.floatValue];
    } else if (model.type.intValue == 0) { // 充值
        self.moneyLab.text = [NSString stringWithFormat:@"+%.2f",model.realAmount.floatValue];
    } else if (model.type.intValue == 2) { //提现
        if ([model.realAmount containsString:@"-"]) {
            self.moneyLab.text = [NSString stringWithFormat:@"-%.2f",model.realAmount.floatValue];
        } else {
            self.moneyLab.text = [NSString stringWithFormat:@"+%.2f",model.realAmount.floatValue];
        }
    } else {
        self.moneyLab.text = [NSString stringWithFormat:@"%.2f",model.realAmount.floatValue];
    }
    
    NSString *tempStr = @"";
    NSInteger type = [model.status integerValue];
            
    switch (type) {
        case 0: tempStr = @"待完成"; break;
        case 1: tempStr = @"已成功"; break;
        case 2: tempStr = @"已取消"; break;
        case 3: tempStr = @"待处理"; break;
        case 4: tempStr = @"待结算"; break;
        default: break;
    }
    self.statusLab.text = tempStr;
    
}

-(void)setFrame:(CGRect)frame{
    frame.origin.y += 2;
    frame.size.height -= 2;
    [super setFrame:frame];
}


@end
