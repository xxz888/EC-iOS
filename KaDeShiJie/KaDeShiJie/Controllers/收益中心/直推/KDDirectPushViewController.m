//
//  KDDirectPushViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDirectPushViewController.h"
#import "KDDirectPushNoDataView.h"
#import "KDDirectPushViewCell.h"
#import "KDDirectPushHeaderView.h"
#import "KDPushModel.h"

@interface KDDirectPushViewController ()<QMUITableViewDelegate, QMUITableViewDataSource, KDDirectPushHeaderViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) KDDirectPushNoDataView *directPushEmptyView;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, assign) NSInteger page;
@end

@implementation KDDirectPushViewController

- (void)showNoDataView
{
    self.mc_tableview.hidden = YES;
    [self.view addSubview:self.directPushEmptyView];
}
- (void)hideNoDataView
{
    [_directPushEmptyView removeFromSuperview];
    _directPushEmptyView = nil;
    self.mc_tableview.hidden = NO;
}
- (KDDirectPushNoDataView *)directPushEmptyView
{
    if (!_directPushEmptyView) {
        _directPushEmptyView = [[KDDirectPushNoDataView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 242) * 0.5, SCREEN_WIDTH, 242)];
    }
    return _directPushEmptyView;
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
    
    NSString *title = [NSString stringWithFormat:@"%@用户", self.titleString];
    [self setNavigationBarTitle:title tintColor:[UIColor mainColor]];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.rowHeight = 144;
    KDDirectPushHeaderView *headView = [[[NSBundle mainBundle] loadNibNamed:@"KDDirectPushHeaderView" owner:nil options:nil] lastObject];
    headView.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 50);
    headView.delegate = self;
    [self.view addSubview:headView];

    if ([self.titleString isEqualToString:@"直推"]) {
        self.level = @"1";
    } else if ([self.titleString isEqualToString:@"间推"]) {
        self.level = @"2";
    } else if ([self.titleString isEqualToString:@"二级间推"]) {
        self.level = @"3";
    }
    self.page = 0;
    self.status = @"0";
    __weak __typeof(self)weakSelf = self;
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf getData:YES];
    }];
    self.mc_tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf getData:NO];
    }];
    [self getData:YES];
}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop + 50, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - NavigationContentTop);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDDirectPushViewCell *cell = [KDDirectPushViewCell cellWithTableView:tableView];
    
//    if (indexPath.row < self.dataArray.count) {
        cell.status = self.status;
        cell.pushModel = self.dataArray[indexPath.row];
        cell.phoneButton.hidden = [self.titleString isEqualToString:@"间推"] || [self.titleString isEqualToString:@"二级间推"];
        cell.phoneViewRight.constant = [self.titleString isEqualToString:@"间推"] || [self.titleString isEqualToString:@"二级间推"] ? 0 : -21;
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getData:(BOOL)cleanData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.level forKey:@"level"];
    [params setValue:@(self.page) forKey:@"page"];
    [params setValue:@(20) forKey:@"size"];
    [params setValue:self.status forKey:@"status"];
    if (self.condition.length != 0) {
        [params setValue:self.condition forKey:@"condition"];
    }
//    if (self.page == 0) {
//        [self.mc_tableview.mj_footer resetNoMoreData];
//    }
    MCLog(@"param:%@",params);
    [self.sessionManager mc_POST:@"/user/app/query/direct/user/info" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if ([self.mc_tableview.mj_header isRefreshing]) {
            [self.mc_tableview.mj_header endRefreshing];
        }
        if ([self.mc_tableview.mj_footer isRefreshing]) {
            [self.mc_tableview.mj_footer endRefreshing];
        }
        if (cleanData) {
            [self.dataArray removeAllObjects];
        }
        //MCLog(@"%@",resp.result);
        NSArray *arr = [KDPushModel mj_objectArrayWithKeyValuesArray:resp.result];
        
        [self.dataArray addObjectsFromArray:arr];
        if (self.dataArray.count == 0) {
            [self showNoDataView];
        } else if (arr.count < 5) {
            [self hideNoDataView];
            
        } else {
            [self hideNoDataView];
        }
        [self.mc_tableview reloadData];
    }];
}

#pragma mark - KDDirectPushHeaderViewDelegate
- (void)directPushHeaderViewSearchText:(NSString *)searchText
{
    if (!searchText || [self.condition isEqualToString:searchText]) {
        return;
    }
    self.condition = searchText;
    [self.mc_tableview.mj_header beginRefreshing];
}
- (void)directPushHeaderViewChoseStatus:(NSString *)status
{
    if ([self.status isEqualToString:status]) {
        return;
    }
    self.status = status;
    self.page=0;
    [self getData:YES];
}
@end
