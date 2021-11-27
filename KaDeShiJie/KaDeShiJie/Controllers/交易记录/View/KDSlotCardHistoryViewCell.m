//
//  KDSlotCardHistoryViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDSlotCardHistoryViewCell.h"

@interface KDSlotCardHistoryViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end


@implementation KDSlotCardHistoryViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"slotcardhistory";
    KDSlotCardHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDSlotCardHistoryViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSlotHistoryModel:(KDSlotCardHistoryModel *)slotHistoryModel
{
    _slotHistoryModel = slotHistoryModel;
    
    
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:slotHistoryModel.bankName];
    self.iconView.image = info.logo;
    
    self.nameLabel.text = slotHistoryModel.bankName;
    self.cardNoLabel.text = [NSString stringWithFormat:@"(%@)", [slotHistoryModel.bankcard substringFromIndex:slotHistoryModel.bankcard.length - 4]];
    
    NSString *desStr = [NSString stringWithFormat:@"费率%.2f%%", slotHistoryModel.rate * 100];
    NSMutableAttributedString *attsDes = [[NSMutableAttributedString alloc] initWithString:desStr];
    NSRange range = [desStr rangeOfString:[NSString stringWithFormat:@"%.2f%%", slotHistoryModel.rate * 100]];
    [attsDes addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#F63802"] range:range];
    self.desLabel.attributedText = attsDes;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", slotHistoryModel.amount];
    
    if (slotHistoryModel.status == 0) {
        
    }
    if (slotHistoryModel.status == 1) {
        self.statusLabel.text = @"已成功";
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#87dc5b"];
    } else if (slotHistoryModel.status == 2) {
        self.statusLabel.text = @"已失败";
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ff5722"];
    } else if (slotHistoryModel.status == 3) {
        self.statusLabel.text = @"待结算";
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
    }
}

@end
