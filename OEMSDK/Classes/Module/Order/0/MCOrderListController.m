//
//  MCOrderListController.m
//  MCOEM
//
//  Created by wza on 2020/4/25.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCOrderListController.h"
#import "MCOrderListFilterView.h"
#import <BRPickerView/BRPickerView.h>
#import "MCOrderListCell.h"
#import "MCOrderDetailController.h"

@interface MCOrderListController ()<MCOrderListFilterViewDelegate, QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, strong) MCOrderListFilterView *filterView;

@property(nonatomic, strong) BRStringPickerView *timeTypePicker;
@property(nonatomic, strong) BRDatePickerView *Ypicker;
@property(nonatomic, strong) BRDatePickerView *YMpicker;
@property(nonatomic, strong) BRDatePickerView *YMDpicker;

@property(nonatomic, strong) QMUIButton *timeButton;
@property(nonatomic, strong) QMUILabel *moneyLab;

@property(nonatomic, assign) int size;

@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;

@property(nonatomic, strong) NSMutableArray<NSMutableArray<MCOrderModel *>*> *dataSource;
@property(nonatomic, strong) NSMutableArray<MCOrderFilterModel *> *filterTypes;
@property(nonatomic, strong) NSMutableArray<MCOrderFilterModel *> *filterStatus;

@property(nonatomic, strong) QMUITableView *tableview;

@property(nonatomic, assign) MCOrderListType type;

@end

@implementation MCOrderListController

- (instancetype)initWithType:(MCOrderListType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}



#pragma mark - Getter
- (QMUITableView *)tableview {
    if (!_tableview) {
        CGFloat top = self.type == MCOrderListTypeNormal ? 130 : 50;
        _tableview = [[QMUITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop+top, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop-130) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.ly_emptyView = [MCEmptyView emptyView];
    }
    return _tableview;
}
- (NSMutableArray<NSMutableArray<MCOrderModel *> *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (QMUILabel *)moneyLab {
    if (!_moneyLab) {
        _moneyLab = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorBlack];
        _moneyLab.text = @"累计金额：0";
    }
    return _moneyLab;
}
- (BRDatePickerView *)Ypicker {
    if (!_Ypicker) {
        _Ypicker = [[BRDatePickerView alloc] initWithPickerMode:BRDatePickerModeY];
        __weak __typeof(self)weakSelf = self;
        _Ypicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            weakSelf.startTime = [NSString stringWithFormat:@"%@-01-01",selectValue];
            weakSelf.endTime = [NSString stringWithFormat:@"%d-01-01",selectValue.intValue+1];
            [weakSelf.timeButton setTitle:selectValue forState:UIControlStateNormal];
            [weakSelf requestDataWithTypes:weakSelf.filterTypes status:weakSelf.filterStatus];
        };
    }
    return _Ypicker;
}
- (BRDatePickerView *)YMpicker {
    if (!_YMpicker) {
        _YMpicker = [[BRDatePickerView alloc] initWithPickerMode:BRDatePickerModeYM];
        __weak __typeof(self)weakSelf = self;
        _YMpicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            weakSelf.startTime = [NSString stringWithFormat:@"%@-01",selectValue];
            NSArray *temA = [selectValue componentsSeparatedByString:@"-"];
            NSString *year = temA[0];
            NSString *month = temA[1];
            weakSelf.endTime = [NSString stringWithFormat:@"%@-%02d-01",year,month.intValue+1];
            [weakSelf.timeButton setTitle:selectValue forState:UIControlStateNormal];
            [weakSelf requestDataWithTypes:weakSelf.filterTypes status:weakSelf.filterStatus];
        };
    }
    return _YMpicker;
}
- (BRDatePickerView *)YMDpicker {
    if (!_YMDpicker) {
        _YMDpicker = [[BRDatePickerView alloc] initWithPickerMode:BRDatePickerModeYMD];
        __weak __typeof(self)weakSelf = self;
        _YMDpicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            NSArray *temA = [selectValue componentsSeparatedByString:@"-"];
            NSString *year = temA[0];
            NSString *month = temA[1];
            weakSelf.startTime = [NSString stringWithFormat:@"%@-%@-01",year,month];
            weakSelf.endTime = selectValue;
            [weakSelf.timeButton setTitle:selectValue forState:UIControlStateNormal];
            [weakSelf requestDataWithTypes:weakSelf.filterTypes status:weakSelf.filterStatus];
        };
    }
    return _YMDpicker;
}
- (BRStringPickerView *)timeTypePicker {
    if (!_timeTypePicker) {
        _timeTypePicker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        _timeTypePicker.dataSourceArr = @[@"默认",@"精确到年",@"精确到月",@"精确到日"];
        __weak __typeof(self)weakSelf = self;
        _timeTypePicker.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            if ([resultModel.value isEqualToString:@"默认"]) {
                weakSelf.startTime = nil;
                weakSelf.endTime = nil;
                [weakSelf.timeButton setTitle:@"全部" forState:UIControlStateNormal];
            } else if ([resultModel.value isEqualToString:@"精确到年"]) {
                [weakSelf.Ypicker show];
            } else if ([resultModel.value isEqualToString:@"精确到月"]) {
                [weakSelf.YMpicker show];
            } else if ([resultModel.value isEqualToString:@"精确到日"]) {
                [weakSelf.YMDpicker show];
            }
        };
    }
    return _timeTypePicker;
}
- (QMUIButton *)timeButton {
    if (!_timeButton) {
        _timeButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_timeButton setTitle:@"全部" forState:UIControlStateNormal];
        _timeButton.titleLabel.font = UIFontMake(15);
        [_timeButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        [_timeButton addTarget:self action:@selector(onTimeTouched:) forControlEvents:UIControlEventTouchUpInside];
        _timeButton.layer.cornerRadius = _timeButton.qmui_height/2;
        _timeButton.layer.borderColor = UIColorForBackground.CGColor;
        _timeButton.layer.borderWidth = 1;
        _timeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return _timeButton;
}
- (MCOrderListFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[MCOrderListFilterView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 45) type:self.type];
        _filterView.delegate = self;
    }
    return _filterView;
}
#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorForBackground;
    if (self.type == MCOrderListTypeNP) {
        [self setNavigationBarTitle:@"NP账单" tintColor:nil];
    } else {
        [self setNavigationBarTitle:@"账单" tintColor:nil];
    }
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.filterView];
    __weak __typeof(self)weakSelf = self;
    if (self.type == MCOrderListTypeNormal) {
        [self.view addSubview:({
            UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, weakSelf.filterView.bottom+1, SCREEN_WIDTH, 80)];
            vv.backgroundColor = UIColorWhite;
            [vv addSubview:({
                QMUILabel *lab = [[QMUILabel alloc] qmui_initWithFont:UIFontBoldMake(16) textColor:UIColorBlack];
                lab.frame = CGRectMake(15, 10, 0, 0);
                lab.text = @"订单日期";
                [lab sizeToFit];
                lab;
            })];
            [vv addSubview:weakSelf.timeButton];
            [vv addSubview:weakSelf.moneyLab];
            
            [weakSelf.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@20);
                make.bottom.equalTo(@-10);
                make.height.equalTo(@30);
            }];
            weakSelf.timeButton.layer.cornerRadius = 15;
            
            [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@-30);
                make.bottom.equalTo(@-10);
            }];
            
            vv;
        })];
    }
    
    
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.size = 20;
        [weakSelf requestDataWithTypes:weakSelf.filterTypes status:weakSelf.filterStatus];
    }];
    self.tableview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakSelf.size += 20;
        [weakSelf requestDataWithTypes:weakSelf.filterTypes status:weakSelf.filterStatus];
    }];
    
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.size = 20;
    [self requestDataWithTypes:nil status:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.filterView.typeModal hide:NO];
    [self.filterView.statusModal hide:NO];
    self.filterView.typeButton.selected = NO;
    self.filterView.statusButton.selected = NO;
}

#pragma mark - MCOrderListFilterViewDelegate
- (void)filterDidChangedTypes:(NSMutableArray<MCOrderFilterModel *> *)types status:(NSMutableArray<MCOrderFilterModel *> *)status {
    
    self.filterTypes = types;
    self.filterStatus = status;
    
    [self requestDataWithTypes:self.filterTypes status:self.filterStatus];
}

#pragma mark - Actions
- (void)onTimeTouched:(QMUIButton *)sender {
    [self.timeTypePicker show];
}

#pragma mark - Request
- (void)requestDataWithTypes:(NSMutableArray<MCOrderFilterModel *> *)types status:(NSMutableArray<MCOrderFilterModel *> *)status  {
    
    NSMutableString *type = [[NSMutableString alloc] initWithString:@""];
    for (MCOrderFilterModel *model in types) {
        if (model.isSelected) {
            [type appendString:[NSString stringWithFormat:@",%@",model.code]];
        }
    }
    NSMutableString *statu = [[NSMutableString alloc] initWithString:@""];
    for (MCOrderFilterModel *model in status) {
        if (model.isSelected) {
            [statu appendString:[NSString stringWithFormat:@",%@",model.code]];
        }
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@(self.size) forKey:@"size"];
    [param setObject:SharedUserInfo.userid forKey:@"userid"];
    if (self.type) {
        [param setObject:@"5" forKey:@"channelType"];
    }
//    if (type.length) {
        [param setObject:type forKey:@"type"];
//    }
    if (statu.length) {
        [param setObject:statu forKey:@"status"];
    }
    if (self.startTime) {
        [param setObject:self.startTime forKey:@"start_time"];
    }
    if (self.endTime) {
        [param setObject:self.endTime forKey:@"end_time"];
    }
    __weak __typeof(self)weakSelf = self;
    [[MCSessionManager shareManager] mc_POST:[NSString stringWithFormat:@"/transactionclear/app/payment/query/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        NSArray *tempA = [MCOrderModel mj_objectArrayWithKeyValuesArray:[resp.result objectForKey:@"content"]];
        weakSelf.moneyLab.text = [NSString stringWithFormat:@"累计金额:%.2f", resp.sumAmount.floatValue];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:[weakSelf groupWithDataArr:tempA]];
        [weakSelf.tableview reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:error.localizedFailureReason];
    }];
    
}
- (NSMutableArray *)groupWithDataArr:(NSArray *)dataArr {
    if (dataArr.count != 0) {
        NSMutableArray *groupArr = [NSMutableArray array];
        NSMutableArray *currentArr = [NSMutableArray array];
        [currentArr addObject:dataArr[0]];
        [groupArr addObject:currentArr];
        if (dataArr.count > 1) {
            for (int i = 1; i < dataArr.count; i++) {
                NSMutableArray *preModelArr = groupArr[groupArr.count-1];
                NSString *preModelDate = [[preModelArr[0] valueForKey:@"createTime"] substringToIndex:7];
                NSString *currentDate = [[dataArr[i] valueForKey:@"createTime"] substringToIndex:7];
                if ([preModelDate isEqualToString:currentDate]) {
                    [currentArr addObject:dataArr[i]];
                }else {
                    currentArr = [NSMutableArray array];
                    [currentArr addObject:dataArr[i]];
                    [groupArr addObject:currentArr];
                }
            }
        }
        return groupArr;
    }
    return [NSMutableArray new];
}
#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 80;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCOrderListCell *cell = [MCOrderListCell cellWithTableview:tableView orderModel:self.dataSource[indexPath.section][indexPath.row]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage mc_imageNamed:@"bargin_date"]];
    imgV.size = CGSizeMake(20, 20);
    imgV.left = 8;
    imgV.centerY = header.height/2;
    [header addSubview:imgV];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.font = UIFontBoldMake(14);
    lab.textColor = UIColorBlack;
    NSDateFormatter *f1 = [[NSDateFormatter alloc] init];
    f1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    f1.timeZone = [NSTimeZone localTimeZone];
    NSString *timeStr = self.dataSource[section].firstObject.updateTime;
    NSDate *date = [f1 dateFromString:timeStr];
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    f2.dateFormat = @"yyyy年MM月";
    lab.text = [f2 stringFromDate:date];
    [lab sizeToFit];
    lab.left = imgV.right+5;
    lab.centerY = header.height/2;
    [header addSubview:lab];
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCOrderDetailController *detail = [MCOrderDetailController new];
    detail.bargainInfo = self.dataSource[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
