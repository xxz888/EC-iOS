//
//  KDKongKaPlanViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDKongKaPlanViewController.h"
#import "KDPlanHeaderView.h"
#import "KDPlanTopViewCell.h"
#import "KDPlanCenterViewCell.h"
#import "KDPlanBottomViewCell.h"
#import "KDEmptyCardRefundViewCell.h"
#import "KDEditDirectCardViewController.h"
#import "KDPlanCenterKongKaCell.h"
@interface KDKongKaPlanViewController ()<QMUITableViewDataSource, QMUITableViewDelegate, KDPlanCenterViewCellDelegate, KDPlanTopViewCellDelegate>
@property (nonatomic, assign) CGFloat centerCellHig;
@property (nonatomic, strong) NSMutableArray *channelArray;
@property (nonatomic, assign) BOOL isOpenChannel;
@end

@implementation KDKongKaPlanViewController

- (NSMutableArray *)channelArray
{
    if (!_channelArray) {
        _channelArray = [NSMutableArray array];
    }
    return _channelArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getDirectCardData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:self.navTitle tintColor:UIColor.whiteColor];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.mj_header = nil;
    self.centerCellHig = 600;
    self.isOpenChannel = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 600;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 46)];
    header.backgroundColor = [UIColor clearColor];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        KDPlanTopViewCell *cell = [KDPlanTopViewCell cellWithTableView:tableView];
        cell.directModel = self.directModel;
        cell.delegate = self;
        return cell;
    } else {
        KDPlanCenterKongKaCell *cell = [KDPlanCenterKongKaCell cellWithTableView:tableView];
        cell.directModel = self.directModel;
        cell.version = self.version;
        return cell;
    }
}

#pragma mark - KDPlanCenterViewCellDelegate
- (void)centerCellChoseRefundType:(NSString *)type changeCenterCellHeight:(CGFloat)cellHeight
{
    self.centerCellHig = cellHeight;
    
    [self.mc_tableview reloadData];
}
#pragma mark - KDPlanHeaderViewDelegate
- (void)planHeaderViewDelegateWithOpenType:(BOOL)open
{
    self.isOpenChannel = open;
    
    [self.mc_tableview reloadData];
}

#pragma mark - KDPlanTopViewCellDelegate
- (void)topCellDelegateWithEditCard
{
    KDEditDirectCardViewController *vc = [[KDEditDirectCardViewController alloc] init];
    vc.directModel = self.directModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取银行卡数据
- (void)getDirectCardData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [self.sessionManager mc_POST:@"/creditcardmanager/app/get/creditcard/by/userid/new" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *dataArray = [KDDirectRefundModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (KDDirectRefundModel *model in dataArray) {
            if ([model.cardNo isEqualToString:self.directModel.cardNo]) {
                self.directModel = model;
            }
        }
        [self.mc_tableview reloadData];
    }];
}
@end
