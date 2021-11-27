//
//  LXUpgradeCell.m
//  Project
//
//  Created by Li Ping on 2019/7/26.
//  Copyright © 2019 LY. All rights reserved.
//

#import "LXUpgradeCell.h"
#import "MCProductDetailController.h"


@interface LXUpgradeCell ()

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIButton *button3;

@property (nonatomic, weak) IBOutlet UILabel *gradeNameLabel;

@property (nonatomic, weak) IBOutlet UIImageView *bgImgView;
@property (nonatomic, weak) IBOutlet UILabel *gradeTitleLab;
@property (nonatomic, weak) IBOutlet UILabel *descLab1;
@property (nonatomic, weak) IBOutlet UILabel *descLab2;
@property (nonatomic, weak) IBOutlet UIImageView *gradImgView;
@property (nonatomic, weak) IBOutlet UILabel *requireLab;

@end

@implementation LXUpgradeCell

+ (instancetype)cellFromTableView:(UITableView *)tableview {
    static NSString *CELL_ID = @"LXUpgradeCell";
    LXUpgradeCell *cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:CELL_ID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:CELL_ID];
        cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.requireLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    self.button1.layer.cornerRadius = 13.5;
    self.button2.layer.cornerRadius = 13.5;
    self.button3.layer.cornerRadius = 13.5;
    
    self.button2.layer.borderWidth = 1;
    self.button3.layer.borderWidth = 1;
    self.button2.layer.borderColor = MAINCOLOR.CGColor;
    self.button3.layer.borderColor = MAINCOLOR.CGColor;
    [self.button2 setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [self.button3 setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    
    [self.button1 setBackgroundColor:MAINCOLOR];
    
    
}

- (IBAction)upGradeTouched:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"已经购买"]) {
        [MCToast showMessage:@"你已经购买过该产品，无需再次购买"];
    }
    if ([sender.titleLabel.text isEqualToString:@"联系客服"]) {
        NSString *brandPhone = SharedBrandInfo.brandPhone;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", brandPhone]]];
    }
    if ([sender.titleLabel.text isEqualToString:@"一键升级"]) {
        [MCChoosePayment popAlertBeforeShowWithAmount:self.model.money.doubleValue productId:self.model.ID productName:self.model.name couponId:nil];
    }
    if ([sender.titleLabel.text isEqualToString:@"收益导图 ▶"]) {
        [MCPagingStore pushWebWithTitle:@"收益导图" classification:@"功能跳转"];
    }
    
}

- (IBAction)viewDetailTouched:(UIButton *)sender {
    MCProductDetailController *detail = [[MCProductDetailController alloc] initWithProductModel:self.model];
    [MCLATESTCONTROLLER.navigationController pushViewController:detail animated:YES];
}

- (void)setModel:(MCProductModel *)model {
    _model = model;
    
    [self setupModel:model userInfo:SharedUserInfo];
}

- (void)setupModel:(MCProductModel *)model userInfo:(MCUserInfo *)info{
    int gg = (model.grade.intValue -1) % 5;
    
    if (self.cellImageArr) {
        self.bgImgView.image = self.cellImageArr[gg];
    }else{
        self.bgImgView.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"lx_upgrade_bg_%d", gg]];
    }
    self.gradImgView.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"lx_grade_%d", model.grade.intValue]];
    self.gradeTitleLab.text = model.name;
    self.descLab1.text = model.earningsState;
    
    NSString *b1Title = nil;
    if ([model.trueFalseBuy isEqualToString:@"0"]) {    //线上购买，显示价格
        b1Title = @"一键升级";
        self.requireLab.text = [NSString stringWithFormat:@"¥ %.2f", model.money.doubleValue];
    } else if ([model.trueFalseBuy isEqualToString:@"2"]) {    //线上购买,不显示价格
        b1Title = @"一键升级";
        self.requireLab.text = MCBrandConfiguration.sharedInstance.brand_name;
    } else if ([model.trueFalseBuy isEqualToString:@"1"]) {    //联系客服，显示价格
        b1Title = @"联系客服";
        self.requireLab.text = [NSString stringWithFormat:@"¥ %.2f", model.money.doubleValue];
    } else if ([model.trueFalseBuy isEqualToString:@"3"]) {    //联系客服，不显示价格
        b1Title = @"联系客服";
        self.requireLab.text = @"需联系客服";
    } else {
        b1Title = @"一键升级";
        self.requireLab.text = [NSString stringWithFormat:@"¥ %.2f", model.money.doubleValue];
    }
    
    [self.button1 setTitle:(model.grade.intValue>info.grade.intValue?b1Title:@"已经购买") forState:UIControlStateNormal];
    self.button2.hidden = (model.grade.intValue !=1);
    
    [self.button1 setBackgroundColor:MAINCOLOR];
    [self.button1 setTitleColor:[MAINCOLOR qmui_inverseColor] forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
}



@end
