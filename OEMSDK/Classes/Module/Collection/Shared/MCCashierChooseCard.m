//
//  MCCashierChooseCard.m
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCCashierChooseCard.h"
#import "STModal.h"
#import "MCCashierChooseCell.h"
#import "MCChooseCardModel.h"
#import "MCCardManagerController.h"

@interface MCCashierChooseCard ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) UIButton *addButton;
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UITableView *tableview;

@property(nonatomic, strong) STModal *modal;

@property(nonatomic, assign) MCCashierChooseCardType type;

@property(nonatomic, strong) NSMutableArray<MCChooseCardModel*> *dataSource;

@end

@implementation MCCashierChooseCard

- (NSMutableArray<MCChooseCardModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = UIFontBoldMake(17);
        _titleLab.textColor = UIColorBlack;
    }
    return _titleLab;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.6)];
        _bgView.backgroundColor = UIColorForBackground;
    }
    return _bgView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 0, 40, 40);
        [_closeButton setImage:[UIImage mc_imageNamed:@"mc_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(onCloseTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _addButton.frame = CGRectMake(0, 0, 80, 40);
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setTitleColor:UIColorGrayDarken forState:UIControlStateNormal];
        _addButton.titleLabel.font = UIFontMake(15);
        [_addButton addTarget:self action:@selector(onAddTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak __typeof(self)weakSelf = self;
        _tableview.backgroundColor = self.bgView.backgroundColor;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestCards];
        }];
    }
    return _tableview;
}

- (instancetype)initWithType:(MCCashierChooseCardType)type {
    self = [super init];
    if (self) {
        UIView *titView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        titView.backgroundColor = UIColorWhite;
        [titView addSubview:self.closeButton];
        [titView addSubview:self.titleLab];
        [titView addSubview:self.addButton];
        self.type = type;
        if (type == MCCashierChooseCardXinyong) {
            self.titleLab.text = @"收款信用卡";
        } else {
            self.titleLab.text = @"到账储蓄卡";
        }
        [self.titleLab sizeToFit];
        self.addButton.right = titView.width;
        self.titleLab.center = titView.center;
        [self.bgView addSubview:titView];
        [self.bgView addSubview:self.tableview];
        self.tableview.frame = CGRectMake(0, titView.height + 1, self.bgView.width, self.bgView.height-titView.height-1);
        self.modal = [STModal modalWithContentView:self.bgView];
        self.modal.positionMode = STModelPositionCenterBottom;
        self.modal.hideWhenTouchOutside = YES;
        [self requestCards];
    }
    return self;
}
#pragma mark - Actions
- (void)show {
    [self.modal show:YES];
}
- (void)dismiss {
    [self.modal hide:YES];
}
- (void)onAddTouched:(UIButton *)sender {
    [self.modal hide:NO];
    [MCPagingStore pagingURL:rt_card_list];
}
- (void)onCloseTouched:(UIButton *)sender {
    [self dismiss];
}
- (void)requestCards {
    NSString *nature = self.type == MCCashierChooseCardXinyong ? @"0" : @"2";
    NSDictionary *param = @{@"userId":SharedUserInfo.userid,
                            @"type":nature,
                            @"nature":nature,
                            @"isDefault":@"0"
                            };
    [[MCSessionManager shareManager] mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [self.tableview.mj_header endRefreshing];
        self.dataSource = [MCChooseCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        [self.tableview reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
        [self.tableview.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
        [MCToast showMessage:error.localizedFailureReason];
        [self.tableview.mj_header endRefreshing];
    }];
    
}
#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCCashierChooseCell cellForTableView:tableView cardInfo:self.dataSource[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate cashierChoose:self DidSelectedCard:self.dataSource[indexPath.row]];
    }
    [self dismiss];
}

@end
