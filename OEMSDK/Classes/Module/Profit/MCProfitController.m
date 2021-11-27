//
//  MCProfitController.m
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCProfitController.h"
#import "MCProfitTransferController.h"
#import "MCProfitListController.h"

@interface MCProfitController ()
@property (weak, nonatomic) IBOutlet UILabel *todayLab;
@property (weak, nonatomic) IBOutlet UILabel *yestodayLab;
@property (weak, nonatomic) IBOutlet UILabel *availableLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UIButton *transferButton;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnTopCons;
@end

@implementation MCProfitController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarHidden];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.view1.backgroundColor = MAINCOLOR;
    self.transferButton.layer.cornerRadius = self.transferButton.height/2;
    
    __weak __typeof(self)weakSelf = self;
    self.scroll.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    self.centerBtnTopCons.constant = 62 * SCREEN_WIDTH / 375;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, self.view.height+1);
}

- (void)requestData {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/account/query/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scroll.mj_header endRefreshing];
        weakSelf.availableLab.text = [NSString stringWithFormat:@"%.2f", [resp.result[@"rebateBalance"] floatValue]];
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scroll.mj_header endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.scroll.mj_header endRefreshing];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",error.code,error.domain]];
    }];
    [self.sessionManager mc_POST:@"/user/app/rebate/query/sumrebate" parameters:@{@"user_id":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scroll.mj_header endRefreshing];
        weakSelf.yestodayLab.text = [NSString stringWithFormat:@"%.2f",[resp.result[@"yesterdayRebate"] floatValue]];
        weakSelf.todayLab.text = [NSString stringWithFormat:@"%.2f",[resp.result[@"todayRebate"] floatValue]];
        weakSelf.totalLab.text = [NSString stringWithFormat:@"%.2f",[resp.result[@"allRebate"] floatValue]];
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.scroll.mj_header endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.scroll.mj_header endRefreshing];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",error.code,error.domain]];
    }];
}


- (IBAction)onBackTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onTransferTouched:(id)sender {
    [self.navigationController pushViewController:[MCProfitTransferController new] animated:YES];
}
- (IBAction)onDetailTouched:(id)sender {
    [self.navigationController pushViewController:[MCProfitListController new] animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
