//
//  KDDirectRefundViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDirectRefundViewCell.h"
#import "KDPlanViewController.h"
#import "KDCommonAlert.h"
#import "KDPlanPreviewViewController.h"
@interface KDDirectRefundViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet KDFillButton *planBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *billdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *jihuajinduBtn;

@property (weak, nonatomic) IBOutlet UIView *progressContentView;
@property (strong, nonatomic) ZZCircleProgress *progressView;
@end

@implementation KDDirectRefundViewCell

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
    self.progressView.progress = 0;
    self.progressView.showProgressText = YES;
    self.progressView.progressLabel.font = LYFont(9);
    
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

        //planType 新的余额还款,如果要显示制定计划按钮，暂时planType就不等于1，走老的逻辑 2 4 5 7             136去掉
        if ([refundModel.planType integerValue] == 1) {
            NSArray  * keyStatus = @[@"",@"",@"执行中", @"", @"失败", @"取消中",@"",@"失败"];
            NSString * status = keyStatus[[refundModel.balancePlanStatus integerValue]];
            //运行中状态 app显示还款中
            if ([refundModel.balancePlanStatus integerValue] == 2 || [refundModel.balancePlanStatus integerValue] == 4 ||
                [refundModel.balancePlanStatus integerValue] == 5 || [refundModel.balancePlanStatus integerValue] == 7
                ) {
                NSString *desStr = [NSString stringWithFormat:@"计划%@，已还款%.2f元", status, refundModel.balanceSuccessAmount];
                NSMutableAttributedString *attsDes = [[NSMutableAttributedString alloc] initWithString:desStr];
                NSRange range = [desStr rangeOfString:[NSString stringWithFormat:@"%@", status]];
                [attsDes addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#F08300"] range:range];
                self.desLabel.attributedText = attsDes;
                self.planBtn.hidden = YES;
                self.progressView.progress = refundModel.balanceSuccessAmount / refundModel.balanceAllAmount;
                self.progressView.hidden = self.jihuajinduBtn.hidden = NO;
                self.progressContentView.userInteractionEnabled = YES;
            }else{
                self.progressContentView.userInteractionEnabled = NO;
                self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
                self.planBtn.hidden = YES;
                self.desLabel.text = status;
            }
        }
        //planType 老的余额还款
        if ([refundModel.planType integerValue] == 3) {
            if (refundModel.allAmount == 0) {
                self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
                self.progressContentView.userInteractionEnabled = NO;
                self.planBtn.hidden = NO;
                self.planBtn.userInteractionEnabled = YES;
                self.desLabel.text = @"请及时设置本月还款计划";
            }else{
                [self xinYongKaHuanKuanAction:refundModel];
                if ([refundModel.repaymentModel integerValue] == 0) {
                    self.planBtn.hidden = YES;
                    self.progressView.progress = refundModel.successAmount / refundModel.allAmount;
                    self.progressView.hidden = self.jihuajinduBtn.hidden = NO;
                    self.progressContentView.userInteractionEnabled = YES;
                }else{
                    self.desLabel.text = @"已制定本月还款计划";
                    self.progressView.hidden = self.jihuajinduBtn.hidden = YES;
                    self.progressContentView.userInteractionEnabled = NO;

                    self.planBtn.hidden = NO;
                    [self.planBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    [self.planBtn setBackgroundColor:KGrayColor];
                    self.planBtn.userInteractionEnabled = NO;
                }
            }
        }
}
#pragma mark --------------------信用卡还款和空卡还款公用的状态，封装起来---------------------
-(void)xinYongKaHuanKuanAction:(KDDirectRefundModel *)refundModel{
    NSString *status = nil;
    NSInteger currentDay = [MCDateStore getCurrentDay];
    if ((refundModel.repaymentBill.content.firstObject.taskStatus == 3 ||
         refundModel.repaymentBill.content.firstObject.taskStatus == 4) && currentDay > refundModel.billDay && currentDay < refundModel.repaymentDay) {
        status = @"已完成";
        NSString *desStr = [NSString stringWithFormat:@"计划%@，已还款%.2f元", status, refundModel.successAmount];
        NSMutableAttributedString *attsDes = [[NSMutableAttributedString alloc] initWithString:desStr];
        NSRange range = [desStr rangeOfString:[NSString stringWithFormat:@"%@", status]];
        [attsDes addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#53AF23"] range:range];
        self.desLabel.attributedText = attsDes;
    } else if(refundModel.repaymentBill.content.firstObject.taskStatus == 0){
        status = @"待执行";
        NSString *desStr = [NSString stringWithFormat:@"计划%@，已还款%.2f元", status, refundModel.successAmount];
        NSMutableAttributedString *attsDes = [[NSMutableAttributedString alloc] initWithString:desStr];
        NSRange range = [desStr rangeOfString:[NSString stringWithFormat:@"%@", status]];
        [attsDes addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#F08300"] range:range];
        self.desLabel.attributedText = attsDes;
    } else if ((refundModel.repaymentBill.content.firstObject.taskStatus == 1 || refundModel.repaymentBill.content.firstObject.taskStatus == 2) && refundModel.allAmount != 0) {
        status = @"还款中";
        NSString *desStr = [NSString stringWithFormat:@"计划%@，已还款%.2f元", status, refundModel.successAmount];
        NSMutableAttributedString *attsDes = [[NSMutableAttributedString alloc] initWithString:desStr];
        NSRange range = [desStr rangeOfString:[NSString stringWithFormat:@"%@", status]];
        [attsDes addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#F63802"] range:range];
        self.desLabel.attributedText = attsDes;
    }
    
    
  
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"directrefund";
    KDDirectRefundViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDDirectRefundViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)cancelAction:(id)sender {
    
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:@"确定要解绑此银行卡吗？"  isShowClose:NO];
    commonAlert.rightBtn.tag = 9999; //设置而这个是代表有请求，请求完再隐藏弹框
    __weak __typeof(self)weakSelf = self;
    commonAlert.rightActionBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/del/%@",TOKEN] parameters:@{@"cardno":weakSelf.refundModel.cardNo,@"type":@"0"} ok:^(MCNetResponse * _Nonnull resp) {
                if (weakSelf.refreshUIBlock) {
                    weakSelf.refreshUIBlock();
                }
            }];
        });

    };
    
//    QMUIModalPresentationViewController *diaVC = [[QMUIModalPresentationViewController alloc] init];
//    KDDirectAlertView *typeView = [[KDDirectAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 218)];
//    diaVC.contentView = typeView;
//    diaVC.contentViewMargins = UIEdgeInsetsMake(0, 32.5, 0, 32.5);
//    [diaVC showWithAnimated:YES completion:nil];
//    __weak typeof(self) weakSelf = self;
//    typeView.cancelBtnAction = ^{
//        [diaVC hideWithAnimated:YES completion:nil];
//    };
//    typeView.sureBtnAction = ^{
//
//    };
}
-(void)clickProgressContentView:(id)tap{
    
    //planType 老的余额还款
    if ([self.refundModel.planType integerValue] == 3) {
        if (self.refundModel.allAmount == 0) {
            [self clickPlanBtn:self.planBtn];
        }else{
            //只有在待执行状态下才可点击。
            KDDirectRefundModel * directRefundModel = self.refundModel;
            [self getHistory:directRefundModel];
        }
    }else{
        [self requestDetail];
    }
    
    



      
}
-(void)requestDetail{
    KDPlanPreviewViewController *vc = [[KDPlanPreviewViewController alloc] init];
    
    KDRepaymentModel *repaymentModel = [[KDRepaymentModel alloc]init];
    repaymentModel.bankName = self.refundModel.bankName;
    repaymentModel.creditCardNumber = self.refundModel.cardNo;
    repaymentModel.statusName = @"";
    vc.repaymentModel = repaymentModel;
    vc.orderType = 2;
    vc.isCanDelete = YES;
    vc.balancePlanId = self.refundModel.balancePlanId;
    vc.whereCome = 3;// 1 下单 2 历史记录 3 信用卡还款进来
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    
    

}
- (IBAction)clickPlanBtn:(id)sender {
    
    KDPlanViewController *vc = [[KDPlanViewController alloc] init];
    vc.navTitle = @"制定计划";
    vc.directModel = self.refundModel;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];

}
#pragma mark - 数据请求
- (void)getHistory:(KDDirectRefundModel *)directRefundModel{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [params setValue:BCFI.brand_id forKey:@"brandId"];
    NSString * year = @"";
    if ([[self.refundModel.planCreateTime split:@"/"] count] > 0) {
        year = [self.refundModel.planCreateTime split:@"/"][0];
    }else{
        year = [MCDateStore getYear];
    }
    [params setValue:year forKey:@"year"];
    
    NSString * month = @"";
    if ([[self.refundModel.planCreateTime split:@"/"] count] > 1) {
        month = [self.refundModel.planCreateTime split:@"/"][1];
    }else{
        month = [MCDateStore getMonth];
    }
    [params setValue:month forKey:@"month"];
    [params setValue:@"2" forKey:@"orderType"];
    kWeakSelf(self);
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/add/queryrepayment/make/informationn" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        NSMutableArray * repaymentModelArray = [KDRepaymentModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        KDRepaymentModel * selectRepaymentModel = nil;
        for (KDRepaymentModel * repaymentModel in repaymentModelArray) {
            NSString * time1 = [repaymentModel.createTime substringWithRange:NSMakeRange(8, 2)];
            NSString * time2 = [weakself.refundModel.planCreateTime substringWithRange:NSMakeRange(8, 2)];
            if ([repaymentModel.creditCardNumber isEqualToString:directRefundModel.cardNo] && [time1 isEqualToString:time2]) {
                    selectRepaymentModel = repaymentModel;
                    break;
            }
        }
        if (selectRepaymentModel) {
            KDPlanPreviewViewController *vc = [[KDPlanPreviewViewController alloc] init];
            vc.repaymentModel = selectRepaymentModel;
            vc.orderType = 2;
            vc.isCanDelete = YES;
            vc.whereCome = 3;// 1 下单 2 历史记录 3 信用卡还款进来
            [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        }

    }];
    
}
@end
