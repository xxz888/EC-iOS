//
//  MCBalanceController.m
//  MCOEM
//
//  Created by wza on 2020/5/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBalanceController.h"
#import "MCWithdrawController.h"

@interface MCBalanceController ()

@property (weak, nonatomic) IBOutlet UILabel *avalibleLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UIButton *jiesuanBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MCBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden];
    self.jiesuanBtn.layer.cornerRadius = self.jiesuanBtn.height/2;
    [self.jiesuanBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    self.bgView.backgroundColor = MAINCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    __weak __typeof(self)weakSelf = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    [self requestData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.bgView.height+1);

}

- (void)requestData {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/account/query/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scrollView.mj_header endRefreshing];
        NSString *balanceString = [NSString stringWithFormat:@"%.2f", [resp.result[@"balance"] floatValue]];
        weakSelf.avalibleLab.text = balanceString;
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scrollView.mj_header endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.scrollView.mj_header endRefreshing];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",error.code,error.domain]];
    }];
    [self.sessionManager mc_POST:@"/user/app/rebate/query/sumrebate" parameters:@{@"user_id":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scrollView.mj_header endRefreshing];
        NSString *amountStr = [NSString stringWithFormat:@"%.2f", [resp.result[@"allRebate"] floatValue]];
        weakSelf.totalLab.text = amountStr;
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scrollView.mj_header endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.scrollView.mj_header endRefreshing];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",error.code,error.domain]];
    }];
}

- (IBAction)onBackTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onJiesuanTouched:(id)sender {
    [self.navigationController pushViewController:[MCWithdrawController new] animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
