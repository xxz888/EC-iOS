//
//  KDTrandingRecordViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDTrandingRecordViewCell.h"

@interface KDTrandingRecordViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation KDTrandingRecordViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"trandingrecord";
    KDTrandingRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDTrandingRecordViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
}


- (void)setRepaymentModel:(KDRepaymentModel *)repaymentModel
{
    _repaymentModel = repaymentModel;
    
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:repaymentModel.bankName];
    self.iconView.image = info.logo;
    
    self.nameLabel.text = repaymentModel.bankName;
    self.cardNoLabel.text = [NSString stringWithFormat:@"(%@)", [repaymentModel.creditCardNumber substringFromIndex:repaymentModel.creditCardNumber.length - 4]];
    
    NSString *desStr = [NSString stringWithFormat:@"已还%.2f元 | 总额%.2f元", repaymentModel.repaymentedAmount, repaymentModel.taskAmount];
    NSMutableAttributedString *attsDes = [[NSMutableAttributedString alloc] initWithString:desStr];
    NSRange range = [desStr rangeOfString:[NSString stringWithFormat:@"%.2f元", repaymentModel.repaymentedAmount]];
    [attsDes addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#F63802"] range:range];
    self.desLabel.attributedText = attsDes;
    
    self.timeLabel.text = repaymentModel.createTime;
    
    if (repaymentModel.orderType == 2) {
        
        //新的余额还款
        if (self.repaymentModel.balance) {
            NSArray *status = @[@"",@"待执行",@"执行中", @"已完成", @"已失败", @"取消中",@"已取消",@"计划失败",@"已失败"];
            self.statusLabel.text = status[repaymentModel.status];
        }else{
            NSArray *status = @[@"执行中", @"已失败", @"执行中", @"已完成",@"已失败"];
            self.statusLabel.text = status[repaymentModel.taskStatus];
        }
        
        if ([self.statusLabel.text isEqualToString:@"已完成"]) {
            self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#53AF23"];
        }else if ([self.statusLabel.text isEqualToString:@"已失败"]){
            self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ff5722"];
        }else{
            self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
        }
        
    }else if (repaymentModel.orderType == 3){
        self.statusLabel.text = repaymentModel.statuskongkaName;
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:repaymentModel.statuskongkaColor];

    }

}



@end
