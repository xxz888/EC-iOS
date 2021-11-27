//
//  KDEarnCenterHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDEarnCenterHeaderView.h"
#import "KDExtendEarnViewController.h"
#import "KDProfitViewController.h"
#import "KDDirectPushViewController.h"
#import "KDAchieveAwardViewController.h"
#import "KDReturnMoneyViewController.h"
#import "KDRemedyView.h"
#import "KDWithDrawHistoryViewController.h"
#import "KDLostQuotaViewController.h"
#import "KDEarnCenterModel.h"

@interface KDEarnCenterHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *withDrewBtn;
@property (weak, nonatomic) IBOutlet UIButton *mibuBtn;


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIStackView *centerView;
@property (weak, nonatomic) IBOutlet UIStackView *bottomView;
/** 可提现 */
@property (weak, nonatomic) IBOutlet UILabel *balanceView;
/** 当前收益 */
@property (weak, nonatomic) IBOutlet UILabel *todayEarnView;
/** 当月收益 */
@property (weak, nonatomic) IBOutlet UILabel *monthEarnView;
@property (nonatomic, strong) KDEarnCenterModel *earnModel;
@end

@implementation KDEarnCenterHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.mibuBtn.layer.borderWidth = 1;
    self.mibuBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mibuBtn.layer.cornerRadius = 12;
    self.mibuBtn.layer.masksToBounds = YES;
    
    self.withDrewBtn.layer.cornerRadius = 12;
    self.withDrewBtn.layer.masksToBounds = YES;

    self.topView.layer.cornerRadius = 12;
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 15;
    
    NSArray *title = @[@"推广收益", @"刷卡分润", @"还款分润", @"空卡分润", @"达标奖励", @"返现", @"", @"", @"直推用户", @"提现记录", @"弥补记录", @""];
    for (int i = 0; i < 12; i++) {
        QMUIButton *btn = [self viewWithTag:100 + i];
        btn.imagePosition = QMUIButtonImagePositionTop;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_earn_icon_%d", i]] forState:UIControlStateNormal];
        [btn setTitle:title[i] forState:UIControlStateNormal];
    }
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDEarnCenterHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (IBAction)btnAction:(QMUIButton *)sender {
    NSArray *titleArray = @[@"推广收益", @"刷卡分润", @"还款分润", @"空卡分润", @"达标奖励", @"返现", @"", @"", @"直推用户", @"提现记录", @"弥补记录", @""];
    NSString *title = titleArray[sender.tag - 100];
    if ([title isEqualToString:@"推广收益"]) {
        [MCLATESTCONTROLLER.navigationController pushViewController:[KDExtendEarnViewController new] animated:YES];
        return;
    }
    if ([title isEqualToString:@"返现"]) {
        KDReturnMoneyViewController *vc = [[KDReturnMoneyViewController alloc] init];
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"VIP收益"]) {
        [MCPagingStore pushWebWithTitle:title classification:@"功能跳转"];
        return;
    }
    if ([title isEqualToString:@"共享还款分润"]) {
        [MCPagingStore pushWebWithTitle:title classification:@"功能跳转"];
        return;
    }
    if ([title isEqualToString:@"弥补记录"]) {
        KDWithDrawHistoryViewController *vc = [[KDWithDrawHistoryViewController alloc] init];
        vc.titleString = @"信用弥补记录";
        vc.queryType = @"7";
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"提现记录"]) {
        KDWithDrawHistoryViewController *vc = [[KDWithDrawHistoryViewController alloc] init];
        vc.titleString = @"提现记录";
        vc.queryType = @"8";
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"达标奖励"]) {
        KDAchieveAwardViewController *vc = [[KDAchieveAwardViewController alloc] init];
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"直推用户"]) {
        KDDirectPushViewController *vc = [[KDDirectPushViewController alloc] init];
        vc.titleString = @"直推";
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        return;
    }
    KDProfitViewController *profitVC = [[KDProfitViewController alloc] init];
    profitVC.viewType = title;
    [MCLATESTCONTROLLER.navigationController pushViewController:profitVC animated:YES];
}

#pragma mark - 提现
- (IBAction)clickWithDrawBtn:(UIButton *)sender {
    [[KDGuidePageManager shareManager] requestShiMing:^{
        [MCLATESTCONTROLLER.navigationController pushViewController:[MCWithdrawController new] animated:YES];
    }];
}
- (IBAction)clickRemendyBtn:(UIButton *)sender {
    KDLostQuotaViewController *vc = [[KDLostQuotaViewController alloc] init];
    vc.titleString = @"弥补";
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}

- (void)reloadData
{
    __weak typeof(self) weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/query/user/account/sum" parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        weakSelf.earnModel = [KDEarnCenterModel mj_objectWithKeyValues:resp.result];
    }];
}

- (void)setEarnModel:(KDEarnCenterModel *)earnModel
{
    _earnModel = earnModel;
    
    self.balanceView.text = [NSString stringWithFormat:@"%.2f", earnModel.usableWithdrawAmount.floatValue];
    self.todayEarnView.text = [NSString stringWithFormat:@"%.2f", earnModel.todayRebate.doubleValue];
    self.monthEarnView.text = [NSString stringWithFormat:@"%.2f", earnModel.monthRebate.doubleValue];
}
@end
