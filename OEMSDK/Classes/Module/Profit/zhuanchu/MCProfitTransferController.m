//
//  MCProfitTransferController.m
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCProfitTransferController.h"
#import "KDCommonAlert.h"

@interface MCProfitTransferController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *availableLab;
@property (weak, nonatomic) IBOutlet UIButton *totalButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property(nonatomic, copy) NSString *availableProfit;

@end

@implementation MCProfitTransferController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requstData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarTitle:@"余额提现" tintColor:UIColor.whiteColor];
    [self.totalButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [self.commitButton setBackgroundColor:MAINCOLOR];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    __weak __typeof(self)weakSelf = self;
    self.scroll.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requstData];
    }];
}

- (void)requstData {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/account/query/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scroll.mj_header endRefreshing];
        self.availableLab.text = [NSString stringWithFormat:@"可转出金额%.2f元", [resp.result[@"rebateBalance"] floatValue]];
        weakSelf.availableProfit = [NSString stringWithFormat:@"%.2f", [resp.result[@"rebateBalance"] floatValue]];
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scroll.mj_header endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.scroll.mj_header endRefreshing];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",error.code,error.domain]];
    }];
}

- (IBAction)onTotalTouched:(id)sender {
    self.textField.text = self.availableProfit;
}
- (IBAction)onCommitTouched:(id)sender {
    CGFloat input = self.textField.text.floatValue;
    CGFloat available = self.availableProfit.floatValue;
    if (input == 0) {
        [MCToast showMessage:@"请输入金额"];
        return;
    }
    if (input < 1) {
        [MCToast showMessage:@"最小转出金额为1元"];
        return;
    }
    if (input > available) {
        [MCToast showMessage:@"输入金额不得大于可提现金额"];
        return;
    }
    [self transfer];
}

- (void)transfer {
    NSDictionary *param = @{@"phone":SharedUserInfo.phone,
                            @"amount":self.textField.text,
                            @"order_desc":@"分润提现",
                            @"brandId":SharedConfig.brand_id};
    [MCSessionManager.shareManager mc_POST:@"/facade/app/withdraw/rebate" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        
        
        KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
        [commonAlert initKDCommonAlertContent:@"转出成功"  isShowClose:YES];

//        [commonAlert initKDCommonAlertTitle:@"提示" content:@"转出成功" leftBtnTitle:@"" rightBtnTitle:@"转出成功" ];
        commonAlert.middleActionBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        
//        QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"转出成功" preferredStyle:QMUIAlertControllerStyleAlert];
//        [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }]];
//        [alert showWithAnimated:YES];
    }];
}

@end
