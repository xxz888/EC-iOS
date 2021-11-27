//
//  MCProfitListController.m
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCProfitListController.h"
#import "MCSegementView.h"
#import "MCFenrunCell.h"
#import "MCFanyongCell.h"
#import "MCFenrunModel.h"
#import "MCFanyongModel.h"
#import <BRPickerView/BRPickerView.h>
#import "MCFenrunDetailController.h"
#import "MCFanyongDetailController.h"

@interface MCProfitListController () <UITableViewDelegate, UITableViewDataSource, MCSegementViewDelegate>

@property(nonatomic, strong) UILabel *filterLab;
@property(nonatomic, strong) MCSegementView *segement;

@property(nonatomic, strong) UITableView *tableview;

@property(nonatomic, copy) NSMutableArray<MCFenrunModel *> *fenrunSource;
@property(nonatomic, copy) NSMutableArray<MCFanyongModel *> *fanyongSource;
@property(nonatomic, assign) NSInteger page;

@property(nonatomic, strong) BRStringPickerView *pickerOne;
@property(nonatomic, strong) BRDatePickerView *pickerTwo;

@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;

@end

@implementation MCProfitListController
- (BRDatePickerView *)pickerTwo {
    if (!_pickerTwo) {
        _pickerTwo = [[BRDatePickerView alloc] initWithPickerMode:BRDatePickerModeYMD];
        __weak __typeof(self)weakSelf = self;
        _pickerTwo.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:selectDate];
            //MCLog(@"%@",selectValue);
            weakSelf.filterLab.text = selectValue;
            NSDateFormatter  *f = [NSDateFormatter new];
            f.dateFormat = @"yyyy-MM-dd";
            NSString *endT = [f stringFromDate:nextDay];
            weakSelf.startTime = selectValue;
            weakSelf.endTime = endT;
            [weakSelf reloadData];
        };
    }
    return _pickerTwo;
}

- (BRStringPickerView *)pickerOne {
    if (!_pickerOne) {
        _pickerOne = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        _pickerOne.dataSourceArr = @[@"显示所有",@"根据日期显示"];
        __weak __typeof(self)weakSelf = self;
        _pickerOne.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            if (resultModel.index == 0) {
                weakSelf.startTime = @"";
                weakSelf.endTime = @"";
                [weakSelf reloadData];
                weakSelf.filterLab.text = resultModel.value;
            } else {
                [weakSelf.pickerTwo show];
            }
        };
    }
    return _pickerOne;
}
- (NSMutableArray<MCFenrunModel *> *)fenrunSource {
    if (!_fenrunSource) {
        _fenrunSource = [NSMutableArray new];
    }
    return _fenrunSource;
}
- (NSMutableArray<MCFanyongModel *> *)fanyongSource {
    if (!_fanyongSource) {
        _fanyongSource = [NSMutableArray new];
    }
    return _fanyongSource;
}
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segement.bottom + 10, SCREEN_WIDTH, SCREEN_HEIGHT-self.segement.bottom-10) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.backgroundColor = UIColor.clearColor;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.ly_emptyView = [MCEmptyView emptyView];
    }
    return _tableview;
}
- (MCSegementView *)segement {
    if (!_segement) {
        _segement = [[MCSegementView alloc] initWithFrame:CGRectMake(0, NavigationContentTop+1, SCREEN_WIDTH, 50)];
        _segement.backgroundColor = UIColorWhite;
        _segement.titles = @[@"分润明细",@"返佣明细"];
        _segement.delegate = self;
    }
    return _segement;
}
- (UILabel *)filterLab {
    if (!_filterLab) {
        _filterLab = [[UILabel alloc] qmui_initWithFont:UIFontMake(12) textColor:UIColorBlack];
        _filterLab.text = @"显示所有";
    }
    return _filterLab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titLab = [[UILabel alloc] qmui_initWithFont:UIFontMake(18) textColor:UIColorBlack];
    titLab.text = @"收益明细";
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[titLab, self.filterLab]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 0;
    stack.alignment = UIStackViewAlignmentCenter;
    
    self.navigationItem.titleView = stack;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"筛选" target:self action:@selector(onFilterTouched:)];
    self.view.backgroundColor = UIColorForBackground;
    [self.view addSubview:self.segement];
    [self.view addSubview:self.tableview];
    self.page = 0;
    [self requstFenrun];
    __weak __typeof(self)weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf reloadData];
    }];
    self.tableview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];
    
}
- (void)onFilterTouched:(UIBarButtonItem *)sender {
    [self.pickerOne show];
}
#pragma mark - Actions
- (void)reloadData {
    self.page = 0;
    if (self.segement.currentIndex == 0) {
        [self requstFenrun];
    } else {
        [self requestFanyong];
    }
}
- (void)loadMore {
    self.page += 1;
    if (self.segement.currentIndex == 0) {
        [self requstFenrun];
    } else {
        [self requestFanyong];
    }
}

- (void)requstFenrun {
    NSDictionary *param = @{@"userid":SharedUserInfo.userid,
                            @"size":@"20",
                            @"page":@(self.page),
                            @"start_time":self.startTime ?: @"",
                            @"end_time":self.endTime ?: @""
    };
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"transactionclear/app/profit/query/all" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (weakSelf.page == 0) {
            [weakSelf.fenrunSource removeAllObjects];
        }
        [weakSelf.fenrunSource addObjectsFromArray:[MCFenrunModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]]];
        [weakSelf.tableview reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",error.code, error.domain]];
    }];
}
- (void)requestFanyong {
    NSDictionary *param = @{@"getphone":SharedUserInfo.phone,
                            @"size":@"20",
                            @"page":@(self.page),
                            @"strTime":self.startTime ?: @"",
                            @"endTime":self.endTime ?: @""
    };
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"transactionclear/app/query/all/profit" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (weakSelf.page == 0) {
            [weakSelf.fanyongSource removeAllObjects];
        }
        [weakSelf.fanyongSource addObjectsFromArray:[MCFanyongModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]]];
        [weakSelf.tableview reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",error.code, error.domain]];
    }];
}
#pragma mark - Tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segement.currentIndex == 0) {
        return 100.f;
    }
    return 80.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segement.currentIndex == 0) {
        return self.fenrunSource.count;
    }
    return self.fanyongSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segement.currentIndex == 0) {
        return [MCFenrunCell cellForTableview:tableView fenrunInfo:self.fenrunSource[indexPath.row]];
    }
    return [MCFanyongCell cellForTableview:tableView fanyongInfo:self.fanyongSource[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segement.currentIndex == 0) {
        [self.navigationController pushViewController:[[MCFenrunDetailController alloc] initWithFenrunModel:self.fenrunSource[indexPath.row]] animated:YES];
    } else {
        [self.navigationController pushViewController:[[MCFanyongDetailController alloc] initWithFanyongModel:self.fanyongSource[indexPath.row]] animated:YES];
    }
}
#pragma mark - MCSegementViewDelegate
- (void)segementViewDidSeletedIndex:(NSInteger)index buttonTitle:(NSString *)title {
    self.startTime = @"";
    self.endTime = @"";
    self.filterLab.text = @"显示所有";
    [self reloadData];
}

@end
