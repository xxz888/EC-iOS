//
//  QSHHistoryListController.m
//  Project
//
//  Created by Li Ping on 2019/8/6.
//  Copyright © 2019 LY. All rights reserved.
//

#import "QSHHistoryListController.h"

#import "QSHHistoryListCell.h"
#import "QSHHistoryListHeader.h"
#import "MCHistoryProfitModel.h"


static NSString * api_get_history_profit = @"/transactionclear/app/profit/sumofmonth/queryby/acquserid";

@interface QSHHistoryListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QSHHistoryListHeader *header;
@property (nonatomic, strong) MCHistoryProfitModel *model;

@end

@implementation QSHHistoryListController



- (QSHHistoryListHeader *)header {
    if (!_header) {
        _header = [QSHHistoryListHeader newFromNib];
    }
    return _header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"历史收益" backgroundImage:[UIImage qmui_imageWithColor:MAINCOLOR]];
    
    self.mc_tableview.tableHeaderView = self.header;
    self.mc_tableview.delegate  = self;
    self.mc_tableview.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchDatas];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QSHHistoryListCell *cell = [QSHHistoryListCell cellFromTableView:tableView];
    MCHistoryProfitContent *mm = self.model.content[indexPath.row];
    cell.earnLab.text = mm.profit;
    cell.timeLab.text = mm.date;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.content.count;
}

- (void)fetchDatas {
    
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:api_get_history_profit parameters:@{@"userId":SharedUserInfo.userid,@"type":@"2"} ok:^(MCNetResponse * _Nonnull resp) {
        weakSelf.model = [MCHistoryProfitModel mj_objectWithKeyValues:resp.result];
        weakSelf.header.totalProfit.text = [NSString stringWithFormat:@"%.2f", weakSelf.model.totalProfit.floatValue];
        [weakSelf.mc_tableview reloadData];
    }];
}

@end
