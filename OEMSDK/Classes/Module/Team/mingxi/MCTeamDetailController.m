//
//  MCTeamDetailController.m
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCTeamDetailController.h"
#import "MCMemberModel.h"
#import "MCMemberCell.h"

@interface MCTeamDetailController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, strong) MCTeamModel *model;

@property(nonatomic, copy) NSMutableArray<MCMemberModel *> *dataSource;

@property(nonatomic, assign) NSInteger page;

@end

@implementation MCTeamDetailController

- (NSMutableArray<MCMemberModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (instancetype)initWithTeamModel:(MCTeamModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    [self setNavigationBarTitle:@"会员明细" tintColor:nil];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    __weak __typeof(self)weakSelf = self;
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf requestData];
    }];
    self.mc_tableview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf requestData];
    }];
    [self requestData];
}

- (void)requestData {
    NSDictionary *param = @{@"lower_level":@"1",    //0-所有，1-直推
                            @"grade":self.model.grade,
                            @"page":@(self.page),
                            @"size":@"20"};
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:[NSString stringWithFormat:@"/user/app/info/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.mc_tableview.mj_header endRefreshing];
        [weakSelf.mc_tableview.mj_footer endRefreshing];
        if (weakSelf.page == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        NSArray *tempA = [MCMemberModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        [weakSelf.dataSource addObjectsFromArray:tempA];
        [weakSelf.mc_tableview reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.mc_tableview.mj_header endRefreshing];
        [weakSelf.mc_tableview.mj_footer endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.mc_tableview.mj_header endRefreshing];
        [weakSelf.mc_tableview.mj_footer endRefreshing];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",error.code, error.domain]];
    }];
}

#pragma mark - Tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCMemberCell cellWithTableview:tableView memberModel:self.dataSource[indexPath.row]];
}
@end
