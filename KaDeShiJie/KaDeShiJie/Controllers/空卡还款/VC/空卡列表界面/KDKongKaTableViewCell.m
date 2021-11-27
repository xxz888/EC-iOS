//
//  KDKongKaTableViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDKongKaTableViewCell.h"
#import "KDPlanViewController.h"
#import "KDCommonAlert.h"
#import "KDPlanKongKaPreviewViewController.h"
#import "KDKongKaPlanViewController.h"

@interface KDKongKaTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet KDFillButton *planBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *billdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *progressContentView;
@property (strong, nonatomic) ZZCircleProgress *progressView;
@property (weak, nonatomic) IBOutlet UIButton *jihuajinduBtn;

@end

@implementation KDKongKaTableViewCell

- (ZZCircleProgress *)progressView
{
    if (!_progressView) {
        _progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 30, 30) pathBackColor:[UIColor qmui_colorWithHexString:@"#CCCCCC"] pathFillColor:[UIColor mainColor] startAngle:-90 strokeWidth:3];
    }
    return _progressView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
    self.planBtn.layer.cornerRadius = 15;
    self.jihuajinduBtn.layer.cornerRadius = 15;
    [self.jihuajinduBtn setTitleColor:[UIColor qmui_colorWithHexString:@"#F08300"] forState:0];
    [self.progressContentView addSubview:self.progressView];
    self.progressView.reduceAngle = 0;
    self.progressView.showPoint = YES;
    self.progressView.pointImage.image = [UIImage qmui_imageWithColor:[UIColor mainColor]];
    self.progressView.progress = 0.3;
    self.progressView.showProgressText = YES;
    self.progressView.progressLabel.font = LYFont(9);
    self.progressView.progressLabel.textColor = [UIColor mainColor];
    self.progressContentView.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProgressContentView:)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)setRefundModel:(KDDirectRefundModel *)refundModel
{
    _refundModel = refundModel;
    
    self.nameLabel.text = refundModel.bankName;
    self.billdayLabel.text = [NSString stringWithFormat:@"账单日 每月%ld日｜还款日 每月%ld日", refundModel.billDay, refundModel.repaymentDay];
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:refundModel.bankName];
    
    self.iconView.image = info.logo;
    self.cardNoLabel.text = [NSString stringWithFormat:@"(%@)", [refundModel.cardNo substringFromIndex:refundModel.cardNo.length - 4]];
    
    
    if ([refundModel.planType integerValue] == 1) {
        self.desLabel.text = @"已制定本月还款计划";
        self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
        self.planBtn.hidden = NO;
        [self.planBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.planBtn setBackgroundColor:KGrayColor];
        self.planBtn.userInteractionEnabled = NO;
        [self.planBtn setTitle:@"制定计划" forState:0];
    }else if ([refundModel.planType integerValue] == 2){
        [self xinYongKaOrKongKaAction:refundModel];
    }else{
        if (refundModel.allAmount != 0 && [refundModel.repaymentModel integerValue] !=1) {
            self.desLabel.text = @"已制定本月还款计划";
            self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
            self.planBtn.hidden = NO;
            [self.planBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [self.planBtn setBackgroundColor:KGrayColor];
            self.planBtn.userInteractionEnabled = NO;
            [self.planBtn setTitle:@"制定计划" forState:0];
        }else{
            [self xinYongKaOrKongKaAction:refundModel];
        }
    }

}
#pragma mark --------------------信用卡还款和空卡还款公用的状态，封装起来---------------------
-(void)xinYongKaOrKongKaAction:(KDDirectRefundModel *)refundModel{
    NSInteger emptyCardPlanStatus = [refundModel.emptyCardPlanStatus integerValue];
    self.desLabel.text = @"请您稍作等待";

    if (!emptyCardPlanStatus || emptyCardPlanStatus == 0) {
        self.planBtn.hidden = NO;
        self.planBtn.userInteractionEnabled = YES;
        self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
        self.desLabel.text = @"请及时设置本月还款计划";
    }else if (emptyCardPlanStatus == 2 || emptyCardPlanStatus == 3) {
        self.planBtn.hidden = YES;
        self.planBtn.userInteractionEnabled = YES;
        self.progressView.hidden = self.jihuajinduBtn.hidden = NO;
        self.progressView.progress = refundModel.successAmount / refundModel.allAmount;
        self.desLabel.text = @"计划正在进行中";
    }else if (emptyCardPlanStatus == 1){
        self.planBtn.hidden = NO;
        self.planBtn.userInteractionEnabled = YES;
        [self.planBtn setTitle:@"审核中" forState:0];
        self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
    }else if (emptyCardPlanStatus == 4 || emptyCardPlanStatus == 5){
        self.planBtn.hidden = NO;
        self.planBtn.userInteractionEnabled = YES;
        [self.planBtn setTitle:@"暂停中" forState:0];
        self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
    }else if (emptyCardPlanStatus == 6){
        self.planBtn.hidden = NO;
        self.planBtn.userInteractionEnabled = YES;
        [self.planBtn setTitle:@"已完成" forState:0];
        self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
    }else if (emptyCardPlanStatus == 7){
        self.planBtn.hidden = NO;
        [self.planBtn setTitle:@"退还手续费中" forState:0];
        self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
        [self.planBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.planBtn setBackgroundColor:KGrayColor];
        self.planBtn.userInteractionEnabled = NO;
    }

}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"directrefund";
    KDKongKaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDKongKaTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)cancelAction:(id)sender {
    
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:@"确定要解绑此银行卡吗？" isShowClose:NO];
    
    commonAlert.rightActionBlock = ^{
        
        __weak __typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/del/%@",TOKEN] parameters:@{@"cardno":weakSelf.refundModel.cardNo,@"type":@"0"} ok:^(MCNetResponse * _Nonnull resp) {
                if (weakSelf.refreshUIBlock) {
                    weakSelf.refreshUIBlock();
                }
            }];
        });

 
    };

}
-(void)clickProgressContentView:(id)tap{
    [self clickPlanBtn:self.planBtn];
}
- (IBAction)clickPlanBtn:(id)sender {
    __weak __typeof(self)weakSelf = self;
    if ([self.refundModel.planType integerValue] == 1) {
    
    }else if ([self.refundModel.planType integerValue] == 2){
        
    }else{
        NSInteger emptyCardPlanStatus = [self.refundModel.emptyCardPlanStatus integerValue];
        if (!emptyCardPlanStatus || emptyCardPlanStatus == 0) {
    //        [MCSessionManager.shareManager mc_POST:@"creditcardmanager/app/empty/card/get/channel/all" parameters:@{} ok:^(MCNetResponse * _Nonnull resp) {
                KDKongKaPlanViewController * vc = [[KDKongKaPlanViewController alloc]init];
                vc.directModel = self.refundModel;
                vc.navTitle = @"空卡计划制定";
                vc.version = @"99-6";
                [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    //        }];
            

        }else{
            if (emptyCardPlanStatus == 7) {
                return;
            }
            KDPlanKongKaPreviewViewController * vc = [[KDPlanKongKaPreviewViewController alloc]init];
            vc.directModel = self.refundModel;
            vc.whereCome = 3;// 1 下单 2 历史记录 3 空卡列表点击进来
            [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        }
    }


}
@end
