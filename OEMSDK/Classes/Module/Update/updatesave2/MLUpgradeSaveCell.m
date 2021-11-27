//
//  MLUpgradeSaveCell.m
//  Project
//
//  Created by Li Ping on 2019/7/19.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MLUpgradeSaveCell.h"
#import "MCProductDetailController.h"

@interface MLUpgradeSaveCell ()

@property (nonatomic, weak) IBOutlet UIButton *upGradebtn;
@property (nonatomic, weak) IBOutlet UIButton *viewDetailBtn;

@property (nonatomic, weak) IBOutlet UILabel *gradeNameLabel;

@property (nonatomic, weak) IBOutlet UIImageView *bgImgView;
@property (nonatomic, weak) IBOutlet UILabel *gradeTitleLab;
@property (nonatomic, weak) IBOutlet UILabel *descLab1;
@property (nonatomic, weak) IBOutlet UILabel *descLab2;
@property (nonatomic, weak) IBOutlet UIImageView *gradImgView;
@property (nonatomic, weak) IBOutlet UILabel *requireLab;

@end

@implementation MLUpgradeSaveCell


+ (instancetype)cellFromTableView:(UITableView *)tableview {
    static NSString *CELL_ID = @"MLUpgradeSaveCell";
    MLUpgradeSaveCell *cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
//    if (!cell) {
//        [tableview registerNib:[UINib nibWithNibName:CELL_ID bundle:nil] forCellReuseIdentifier:CELL_ID];
//        cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
//    }
    
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:CELL_ID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:CELL_ID];
        cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.upGradebtn.layer.cornerRadius = 13.5;
    self.viewDetailBtn.layer.cornerRadius = 13.5;
    self.viewDetailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewDetailBtn.layer.borderWidth = 1;
}

- (IBAction)upGradeTouched:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"已经购买"]) {
        [MCToast showMessage:@"你已经购买过该产品，无需再次购买"];
        return;
    }
    

    if ([self.model.trueFalseBuy isEqualToString:@"1"]||[self.model.trueFalseBuy isEqualToString:@"3"]) {    // 联系客服
              NSString *brandPhone = SharedBrandInfo.brandPhone;
              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", brandPhone]]];
    }else{
        [MCChoosePayment popAlertBeforeShowWithAmount:self.model.money.doubleValue productId:self.model.ID productName:self.model.name couponId:nil];

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
    int gg = (model.grade.intValue -1) % 3;
    
    if (self.cellImageArr) {
         self.bgImgView.image = self.cellImageArr[gg];
     }else{
         self.bgImgView.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"lx_upgrade_bg_%d", gg]];
     }
    self.bgImgView.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"ml_up_bg_%d", gg]];
    self.gradeTitleLab.text = model.name;
    self.descLab1.text = model.upgradestate;
    
    [self.upGradebtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.requireLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    if ([model.trueFalseBuy isEqualToString:@"0"]) {    //线上购买，显示价格
        self.requireLab.text = [NSString stringWithFormat:@"¥ %.2f", model.money.doubleValue];
        if (model.grade.intValue <= info.grade.intValue) {
            [self.upGradebtn setTitle:@"已经购买" forState:UIControlStateNormal];
        } else {
            [self.upGradebtn setTitle:@"一键升级" forState:UIControlStateNormal];
        }
    }
    if ([model.trueFalseBuy isEqualToString:@"2"]) {    //线上购买,不显示价格
        self.requireLab.text = MCBrandConfiguration.sharedInstance.brand_name;
        if (model.grade.intValue <= info.grade.intValue) {
            [self.upGradebtn setTitle:@"已经购买" forState:UIControlStateNormal];
        } else {
            [self.upGradebtn setTitle:@"一键升级" forState:UIControlStateNormal];
        }
    }
    if ([model.trueFalseBuy isEqualToString:@"1"]) {    // 联系客服，显示价格
        self.requireLab.text = [NSString stringWithFormat:@"¥ %.2f", model.money.doubleValue];
        if (model.grade.intValue <= info.grade.intValue) {
            [self.upGradebtn setTitle:@"已经购买" forState:UIControlStateNormal];
        } else {
            [self.upGradebtn setTitle:@" 联系客服" forState:UIControlStateNormal];
        }
    }
    if ([model.trueFalseBuy isEqualToString:@"3"]) {    // 联系客服，不显示价格
        self.requireLab.text = @"需联系客服";
        if (model.grade.intValue <= info.grade.intValue) {
            [self.upGradebtn setTitle:@"已经购买" forState:UIControlStateNormal];
        } else {
            [self.upGradebtn setTitle:@" 联系客服" forState:UIControlStateNormal];
        }
    }
    self.descLab1.text = model.earningsState;
    
}

@end
