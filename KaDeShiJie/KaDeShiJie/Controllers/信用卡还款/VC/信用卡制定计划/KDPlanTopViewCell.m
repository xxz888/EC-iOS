//
//  KDPlanTopViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanTopViewCell.h"

@interface KDPlanTopViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation KDPlanTopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH-20,100);
    gl.startPoint = CGPointMake(1, 0.5);
    gl.endPoint = CGPointMake(0.01, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:254/255.0 green:69/255.0 blue:87/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:253/255.0 green:109/255.0 blue:92/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.bgView.layer.cornerRadius = 12;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0,2);
    self.bgView.layer.shadowOpacity = 1;
    self.bgView.layer.shadowRadius = 8;
    [self.bgView.layer insertSublayer:gl atIndex:0];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"planTopCell";
    KDPlanTopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDPlanTopViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setDirectModel:(KDDirectRefundModel *)directModel
{
    _directModel = directModel;
    
    self.nameLabel.text = directModel.bankName;
    self.cardNoLabel.text = [NSString stringWithFormat:@"(%@)", [directModel.cardNo substringFromIndex:directModel.cardNo.length - 4]];
    self.desLabel.text = [NSString stringWithFormat:@"账单日 每月%ld日｜还款日 每月%ld日", directModel.billDay, directModel.repaymentDay];
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:directModel.bankName];
    self.iconView.image = info.logo;
    self.bgView.backgroundColor = [info.cardCellBackgroundColor qmui_colorWithAlphaAddedToWhite:0.6];

}
- (IBAction)clickEditBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(topCellDelegateWithEditCard)]) {
        [self.delegate topCellDelegateWithEditCard];
    }
}
@end
