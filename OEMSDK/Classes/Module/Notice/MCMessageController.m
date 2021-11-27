//
//  MCMessageController.m
//  MCOEM
//
//  Created by wza on 2020/4/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCMessageController.h"
#import "MCSegementView.h"
#import "MCMessageModel.h"
#import "MCMessageCell.h"

@interface MCMessageController () <MCSegementViewDelegate, QMUITableViewDataSource, QMUITableViewDelegate>

@property(nonatomic, strong) MCSegementView *segement;
@property(nonatomic, strong) QMUITableView *tableview;
@property(nonatomic, strong) NSMutableArray<MCMessageModel *> *dataSource;
@property(nonatomic, assign) int page;
@property(nonatomic, copy) NSString *type;

@end

@implementation MCMessageController
- (NSMutableArray<MCMessageModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource  =[NSMutableArray new];
    }
    return _dataSource;
}
- (QMUITableView *)tableview {
    if (!_tableview) {
        _tableview = [[QMUITableView alloc] initWithFrame:CGRectMake(0, self.segement.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-self.segement.bottom) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak __typeof(self)weakSelf = self;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 0;
            if ([weakSelf.type isEqualToString:@"0"]) {
                [weakSelf requestPerson];
            } else {
                [weakSelf requestPlatform];
            }
        }];
        _tableview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            weakSelf.page += 1;
            if ([weakSelf.type isEqualToString:@"0"]) {
                [weakSelf requestPerson];
            } else {
                [weakSelf requestPlatform];
            }
        }];
    }
    return _tableview;
}
- (MCSegementView *)segement {
    if (!_segement) {
        _segement = [[MCSegementView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 45)];
        _segement.titles = @[@"个人消息",@"平台消息"];
        _segement.delegate = self;
    }
    return _segement;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"消息中心" tintColor:nil];
    self.page = 0;
    self.type = @"0";
    [self.view addSubview:self.segement];
    [self.view addSubview:self.tableview];
    self.mc_tableview.hidden = YES;
    [self requestPerson];
}

#pragma mark - Actions
- (void)requestPerson {
    NSDictionary *param = @{@"page":@(self.page),@"size":@"20"};
    __weak __typeof(self)weakSelf = self;
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/user/app/jpush/history/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (weakSelf.page == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        NSArray *tempA = [MCMessageModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        [weakSelf.dataSource addObjectsFromArray:tempA];
        [weakSelf.tableview reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:error.localizedFailureReason];
    }];
}
- (void)requestPlatform {
    NSDictionary *param = @{@"page":@(self.page),@"size":@"20"};
    __weak __typeof(self)weakSelf = self;
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/user/app/jpush/history/brand/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (weakSelf.page == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        NSArray *tempA = [MCMessageModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        [weakSelf.dataSource addObjectsFromArray:tempA];
        [weakSelf.tableview reloadData];
        
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCLoading hidden];
        [MCToast showMessage:error.localizedFailureReason];
    }];
}

#pragma mark - MCSegementViewDelegate
- (void)segementViewDidSeletedIndex:(NSInteger)index buttonTitle:(NSString *)title {
    self.page = 0;
    if (index == 0) {
        self.type = @"0";
        [self requestPerson];
    } else {
        self.type = @"1";
        [self requestPlatform];
    }
}

#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCMessageCell cellWithTableview:tableView messageModel:self.dataSource[indexPath.row]];
}

@end
