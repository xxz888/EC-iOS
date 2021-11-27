//
//  KDWithDrawHistoryViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDWithDrawHistoryViewController.h"
#import "KDWithDrawHistoryViewCell.h"
#import "KDWithDrawHistoryheaderView.h"
#import "KDHistoryModel.h"
#import "KDProfitDirectPushModel.h"

@interface KDWithDrawHistoryViewController ()<QMUITableViewDataSource>
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) KDHistoryModel *historyModel;
@property (nonatomic, strong) KDWithDrawHistoryheaderView *header;
@end

@implementation KDWithDrawHistoryViewController

- (KDWithDrawHistoryheaderView *)header
{
    if (!_header) {
        _header = [[KDWithDrawHistoryheaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 324)];
        _header.titleString = self.titleString;
    }
    return _header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mc_tableview.tableHeaderView = self.header;
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.rowHeight = 68.5;
    self.mc_tableview.dataSource = self;
    // 导航条
    [self setNavigationBarTitle:self.titleString backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    
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
}
- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
}
#pragma mark - QMUITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyModel.detail.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDWithDrawHistoryViewCell *cell = [KDWithDrawHistoryViewCell cellWithTableView:tableView];
    cell.model = self.historyModel.detail[indexPath.row];
    return cell;
}

- (void)getData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.queryType forKey:@"queryType"];
    [params setValue:@(100) forKey:@"size"];
    [params setValue:@(self.page) forKey:@"page"];
    if (self.page == 0) {
        [self.mc_tableview.mj_footer resetNoMoreData];
    }
    [self.sessionManager mc_POST:@"/transactionclear/app/query/order/detail" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if ([self.mc_tableview.mj_header isRefreshing]) {
            [self.mc_tableview.mj_header endRefreshing];
        }
        if ([self.mc_tableview.mj_footer isRefreshing]) {
            [self.mc_tableview.mj_footer endRefreshing];
        }
        self.historyModel = [KDHistoryModel mj_objectWithKeyValues:resp.result];
    }];
}

- (void)setHistoryModel:(KDHistoryModel *)historyModel
{
    _historyModel = historyModel;
    
    self.header.model = historyModel;
    
    if (historyModel.detail.count == 0) {
        
    } else {
        [self.mc_tableview reloadData];
    }
}
@end
