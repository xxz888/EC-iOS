//
//  KDCreditManagerHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDCreditManagerHeaderView.h"
#import "KDCreditExtensionViewController.h"
#import "KDCreditModel.h"
#import "KDLostQuotaViewController.h"

@interface KDCreditManagerHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *mgrBtn;
@property (nonatomic, strong) KDCreditModel *model;
@property (weak, nonatomic) IBOutlet UILabel *useableQuotaLabel;
@property (weak, nonatomic) IBOutlet UILabel *selfQuotaLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostSelfQuotaLabel;
@property (weak, nonatomic) IBOutlet UILabel *superiorQuotaLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostSuperiorQuotaLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalQuotaLabel;
@property (weak, nonatomic) IBOutlet UILabel *subordinateQuotaLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostSubordinateQuotaLabel;
@end

@implementation KDCreditManagerHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    

    self.topView.layer.cornerRadius = 12;
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 15;
    
    // gradient
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = CGRectMake(0,0,self.mgrBtn.ly_width,self.mgrBtn.ly_height);
//    gl.startPoint = CGPointMake(0.53, 0);
//    gl.endPoint = CGPointMake(0.53, 1);
//    gl.colors = @[(__bridge id)[UIColor colorWithRed:204/255.0 green:162/255.0 blue:100/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:170/255.0 green:115/255.0 blue:34/255.0 alpha:1.0].CGColor];
//    gl.locations = @[@(0), @(1.0f)];
//    self.mgrBtn.layer.cornerRadius = self.mgrBtn.ly_height * 0.5;
//    self.mgrBtn.layer.masksToBounds = YES;
//    [self.mgrBtn.layer insertSublayer:gl atIndex:0];
    
    [self getMyCredit];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDCreditManagerHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

#pragma mark - 授信管理
- (IBAction)clickManagerBtn:(id)sender {
    if (self.model.selfQuota < 1000) {
        [MCToast showMessage:@"您的额度低于1000，不能给其他人授信"];
        return;
    }
    KDCreditExtensionViewController *vc = [[KDCreditExtensionViewController alloc] init];
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}

// 获取我的授信额度
- (void)getMyCredit {
    
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/get/quota" parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        self.model = [KDCreditModel mj_objectWithKeyValues:resp.result];
    }];
}

- (void)setModel:(KDCreditModel *)model
{
    _model = model;
    
    self.useableQuotaLabel.text = STF(model.useableQuota);
    self.selfQuotaLabel.text = STF(model.selfQuota);
    self.lostSelfQuotaLabel.text = STF(model.lostSelfQuota);
    self.superiorQuotaLabel.text = STF(model.superiorQuota);
    self.lostSuperiorQuotaLabel.text = STF(model.lostSuperiorQuota);
    self.totalQuotaLabel.text = STF(model.totalQuota);
    self.subordinateQuotaLabel.text = STF(model.subordinateQuota);
    self.lostSubordinateQuotaLabel.text = STF(model.lostSubordinateQuota);
    
    if (self.model.selfQuota < 1000) {
        [self.mgrBtn setBackgroundImage:[UIImage imageNamed:@"kd_credit_btn_bg_no"] forState:UIControlStateNormal];
//        self.mgrBtn.enabled = NO;
        self.mgrBtn.alpha = 1;
    } else {
        [self.mgrBtn setBackgroundImage:[UIImage imageNamed:@"kd_credit_btn_bg_yes"] forState:UIControlStateNormal];
//        self.mgrBtn.enabled = YES;
        self.mgrBtn.alpha = 1;
    }
    
}
- (IBAction)clickLostQuotaAction:(UIButton *)sender {
    [MCLATESTCONTROLLER.navigationController pushViewController:[KDLostQuotaViewController new] animated:YES];
}
@end
