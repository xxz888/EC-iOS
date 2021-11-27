//
//  KDProfitDirectPushViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDProfitDirectPushViewController.h"
#import "KDProfitDirectPushHeaderView.h"
#import "KDProfitDirectPushEmptyView.h"
#import "KDProfitDirectPushViewCell.h"
#import "KDProfitDirectPushModel.h"

@interface KDProfitDirectPushViewController ()<QMUITableViewDataSource>
@property (nonatomic, strong) KDProfitDirectPushHeaderView *headView;
@property (nonatomic, strong) KDProfitDirectPushEmptyView *directPushEmptyView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *queryType;
@property (nonatomic, assign) NSInteger page;

@end

@implementation KDProfitDirectPushViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (KDProfitDirectPushEmptyView *)directPushEmptyView
{
    if (!_directPushEmptyView) {
        _directPushEmptyView = [[KDProfitDirectPushEmptyView alloc] initWithFrame:CGRectMake(0, 207 + (SCREEN_HEIGHT - 267 - 207) * 0.5, SCREEN_WIDTH, 267)];
    }
    return _directPushEmptyView;
}

- (KDProfitDirectPushHeaderView *)headView
{
    if (!_headView) {
        _headView = [[KDProfitDirectPushHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 207)];
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 显示空白页面
//    [self showNoDataView];
    
    self.headView.timeView.text = self.timeString;
    self.headView.centerView.text = self.centerTitle;
    [self.view addSubview:self.headView];
    
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.rowHeight = 44;
    self.mc_tableview.dataSource = self;
    // 导航条
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [self setNavigationBarHidden];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = self.titleString;
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    if ([self.titleString isEqualToString:@"直推"]) {
        self.level = @"1";
    } else if ([self.titleString isEqualToString:@"间推"]) {
        self.level = @"2";
    } else if ([self.titleString isEqualToString:@"二级间推"]) {
        self.level = @"3";
    }
    if ([self.centerTitle containsString:@"刷卡"]) {
        self.queryType = @"1";
    } else if ([self.centerTitle containsString:@"还款"]) {
        self.queryType = @"2";
    } else if ([self.centerTitle containsString:@"空卡"]) {
        self.queryType = @"3";
    } else if ([self.centerTitle containsString:@"花呗"]) {
        self.queryType = @"6";
    }
    __weak __typeof(self)weakSelf = self;
    self.page = 0;
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [self getData:YES];
    }];
    
    self.mc_tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [self getData:NO];
    }];
    [self getData:YES];
}
- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, 207, SCREEN_WIDTH, SCREEN_HEIGHT - 207);
}
- (void)showNoDataView
{
    self.mc_tableview.hidden = YES;
    [self.view addSubview:self.directPushEmptyView];
}
- (void)hideNoDataView
{
    [_directPushEmptyView removeFromSuperview];
    _directPushEmptyView = nil;
}
#pragma mark - QMUITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDProfitDirectPushViewCell *cell = [KDProfitDirectPushViewCell cellWithTableView:tableView];
    cell.tuiguangModel = self.dataArray[indexPath.row];
    cell.nameView.hidden = NO;
    return cell;
}

- (void)getData:(BOOL)cleanData {
    NSString *first = [self.timeString substringWithRange:NSMakeRange(0, 4)];
    NSString *last = [self.timeString substringWithRange:NSMakeRange(5, 2)];
    NSString *time = [NSString stringWithFormat:@"%@%@", first, last];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.queryType forKey:@"queryType"];
    [params setValue:time forKey:@"queryDate"];
    [params setValue:self.level forKey:@"level"];
    [params setValue:NSIntegerToNSString(self.page) forKey:@"page"];
    [params setValue:@"20" forKey:@"size"];
    kWeakSelf(self);
    [self.sessionManager mc_POST:@"/transactionclear/app/query/profit/detail" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if ([weakself.mc_tableview.mj_header isRefreshing]) {
            [weakself.mc_tableview.mj_header endRefreshing];
        }
        if ([weakself.mc_tableview.mj_footer isRefreshing]) {
            [weakself.mc_tableview.mj_footer endRefreshing];
        }
        
        NSArray *arr = [KDProfitDirectPushModel mj_objectArrayWithKeyValuesArray:resp.result];

        //如果是下拉刷新，数组清空，page=0
        if (cleanData) {
            [weakself.dataArray removeAllObjects];
            [weakself.dataArray addObjectsFromArray:arr];
        }else{
        //如果是上拉加载，拼接数组，如果刷新到某一页没有数据，就停止
            if ([arr count] == 0) {
                [MCToast showMessage:@"已加载全部数据"];
                
                CGFloat sum = 0;
                for (KDProfitDirectPushModel * model in weakself.dataArray) {
                    sum += model.rebate;
                }
                NSLog(@"总计----%lf",sum);
                
            }else{
                [weakself.dataArray addObjectsFromArray:arr];
            }
        }
        [weakself.mc_tableview reloadData];
    }];
}
@end
