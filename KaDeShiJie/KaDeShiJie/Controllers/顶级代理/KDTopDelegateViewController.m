//
//  KDTopDelegateViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDTopDelegateViewController.h"
#import "KDDelegateViewCell.h"
#import "KDTopDelegateNewModel.h"
#import "KDTopDelegateHeaderView.h"

@interface KDTopDelegateViewController ()<QMUITableViewDelegate, QMUITableViewDataSource, KDTopDelegateHeaderViewDelegate>
@property (nonatomic, strong) QMUITextField *text;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *search;
@property (nonatomic, strong) KDTopDelegateHeaderView *headerView;
@property (nonatomic, strong) UIButton *shareBtn;
@property(nonatomic, assign) NSInteger page;
@end

@implementation KDTopDelegateViewController

- (KDTopDelegateHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDTopDelegateHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 284)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.shareBtn.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.shareBtn.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"顶级代理" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 72, StatusBarHeight + 11, 82, 22);
    [rightBtn setBackgroundColor:UIColor.whiteColor];
    [rightBtn setTitle:@"规则说明" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor qmui_colorWithHexString:@"#F08300"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont qmui_systemFontOfSize:13 weight:QMUIFontWeightBold italic:NO];
    rightBtn.layer.cornerRadius = 11;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn addTarget:self action:@selector(clickRightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:rightBtn];
    self.shareBtn = rightBtn;
    self.page = 1;
    self.mc_tableview.tableHeaderView = self.headerView;
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.rowHeight = 107;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    MCEmptyView *empty = [MCEmptyView emptyViewWithKDDelegateTitle:@"顶级代理"];
    empty.contentViewY = (DEVICE_HEIGHT - self.headerView.height) / 2 + self.headerView.height-120;
    self.mc_tableview.ly_emptyView = empty;
    kWeakSelf(self);
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 1;
        [weakself getData:YES];
        [weakself.headerView reloadData];
    }];
    self.mc_tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        [weakself getData:NO];
    }];
    [self getData:YES];
}
- (void)clickRightAction
{
    [MCPagingStore pushWebWithTitle:@"规则说明" classification:@"功能跳转"];
}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, -NavigationContentTop + 44, SCREEN_WIDTH, SCREEN_HEIGHT+NavigationContentTop - 44);
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDDelegateViewCell *cell = [KDDelegateViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)topDelegateHeaderViewSearchText:(NSString *)text
{
    self.search = text;
    [self.dataArray removeAllObjects];
    self.page = 1;
    [self getData:YES];
}
//637875
- (void)getData:(BOOL)cleanData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"preUserId"];
    if (self.search) {
        [params setValue:self.search forKey:@"text"];
    }
    [params setValue:@(self.page) forKey:@"page"];
    [params setValue:@(100) forKey:@"rows"];
    kWeakSelf(self);
    
    
    [[MCSessionManager shareManager] mc_POST:@"/transactionclear/app/standard/extension/user/all/query" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if ([weakself.mc_tableview.mj_header isRefreshing]) {
            [weakself.mc_tableview.mj_header endRefreshing];
        }
        if ([weakself.mc_tableview.mj_footer isRefreshing]) {
            [weakself.mc_tableview.mj_footer endRefreshing];
        }
        NSArray *arr = [KDTopDelegateNewModel mj_objectArrayWithKeyValuesArray:resp.result];
        [weakself.dataArray addObjectsFromArray:arr];
        //如果是下拉刷新，数组清空，page=0
        if (cleanData) {
            [weakself.dataArray removeAllObjects];
            [weakself.dataArray addObjectsFromArray:arr];
        }else{
        //如果是上拉加载，拼接数组，如果刷新到某一页没有数据，就停止
            if ([arr count] == 0) {
                [MCToast showMessage:@"已加载全部数据"];
            }
        }
        [weakself.mc_tableview reloadData];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
