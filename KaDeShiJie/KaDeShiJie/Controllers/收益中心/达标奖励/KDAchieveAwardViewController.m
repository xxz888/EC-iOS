//
//  KDAchieveAwardViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDAchieveAwardViewController.h"
#import "KDProfitDirectPushViewCell.h"
#import "KDAchieveAwardHeaderView.h"
#import "KDHistoryModel.h"

@interface KDAchieveAwardViewController ()<QMUITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) KDHistoryModel *historyModel;
@property (nonatomic, strong) KDAchieveAwardHeaderView *header;
@end

@implementation KDAchieveAwardViewController

- (KDAchieveAwardHeaderView *)header
{
    if (!_header) {
        _header = [[KDAchieveAwardHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 325)];
    }
    return _header;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mc_tableview.tableHeaderView = self.header;
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.rowHeight = 44;
    self.mc_tableview.dataSource = self;
    MCEmptyView *empty = [MCEmptyView emptyViewWithKDTitle:@"达标奖励"];
    empty.contentViewY = (DEVICE_HEIGHT - self.header.height) / 2 + self.header.height-120;
    self.mc_tableview.ly_emptyView = empty;
//    self.mc_tableview.ly_emptyView = [MCEmptyView emptyViewWithKDTitle:@"达标奖励"];
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self getData];
    }];
//    self.mc_tableview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        self.page += 1;
//        [self getData];
//    }];
    self.page = 0;
    [self getData];
    // 导航条
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [self setNavigationBarHidden];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"达标奖励";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}
- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - QMUITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyModel.detail.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDProfitDirectPushViewCell *cell = [KDProfitDirectPushViewCell cellWithTableView:tableView];
    cell.nameView.hidden = YES;
    cell.dabiaoModel = self.historyModel.detail[indexPath.row];
    return cell;
}

- (void)getData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"4" forKey:@"queryType"];
    [params setValue:@(100) forKey:@"size"];
    [params setValue:@(self.page) forKey:@"page"];
    if (self.page == 0) {
        [self.mc_tableview.mj_footer resetNoMoreData];
    }   
    [self.sessionManager mc_POST:@"/transactionclear/app/query/order/detail" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        MCLog(@"%@",resp.result);
        if ([self.mc_tableview.mj_header isRefreshing]) {
            [self.mc_tableview.mj_header endRefreshing];
        }
        if ([self.mc_tableview.mj_footer isRefreshing]) {
            [self.mc_tableview.mj_footer endRefreshing];
        }
        self.historyModel = [KDHistoryModel mj_objectWithKeyValues:resp.result];
        [self.mc_tableview reloadData];
    }];
}

- (void)setHistoryModel:(KDHistoryModel *)historyModel
{
    _historyModel = historyModel;
    
    self.header.model = historyModel;
    
    [self.mc_tableview reloadData];
}
@end
