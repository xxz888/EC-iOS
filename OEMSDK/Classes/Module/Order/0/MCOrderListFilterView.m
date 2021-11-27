//
//  MCOrderListFilterView.m
//  MCOEM
//
//  Created by wza on 2020/4/25.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCOrderListFilterView.h"
#import "MCStatusCell.h"


@interface MCOrderListFilterView ()<QMUITableViewDataSource, QMUITableViewDelegate>

@property(nonatomic, strong) QMUITableView *typeTable;

@property(nonatomic, strong) NSMutableArray<MCOrderFilterModel *> *typeDataSource;
@property(nonatomic, strong) NSMutableArray<MCOrderFilterModel *> *statusDataSource;

@property(nonatomic, strong) NSMutableArray<MCFilterButton *> *statusButtons;

@property(nonatomic, assign) BOOL changed;

@property(nonatomic, assign) MCOrderListType type;

@end

@implementation MCOrderListFilterView
- (NSMutableArray<MCFilterButton *> *)statusButtons {
    if (!_statusButtons) {
        _statusButtons = [NSMutableArray new];
    }
    return _statusButtons;
}

- (MCFilterButton *)creatStatusButton {
    MCFilterButton *button = [MCFilterButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderColor = UIColorGray.CGColor;
    button.layer.borderWidth = 1;
    [button setTitleColor:UIColorBlack forState:UIControlStateNormal];
    [button setTitleColor:UIColorWhite forState:UIControlStateSelected];
    
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage qmui_imageWithColor:MAINCOLOR] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(onStatusTouched:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4;
    button.clipsToBounds = YES;
    return button;
}


- (QMUITableView *)typeTable {
    if (!_typeTable) {
        _typeTable = [[QMUITableView alloc] initWithFrame:CGRectMake(0, 0, self.typeView.width, self.typeView.height-70) style:UITableViewStylePlain];
        _typeTable.dataSource = self;
        _typeTable.delegate = self;
        _typeTable.backgroundColor = [UIColor clearColor];
        _typeTable.allowsMultipleSelection = YES;
        _typeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _typeTable;
}
- (STModal *)typeModal {
    if (!_typeModal) {
        _typeModal = [self creatModalWithContentView:self.typeView];
    }
    return _typeModal;
}
- (STModal *)statusModal {
    if (!_statusModal) {
        _statusModal = [self creatModalWithContentView:self.statusView];
    }
    return _statusModal;
}
- (STModal *)creatModalWithContentView:(UIView *)view {
    STModal *modal = [STModal modalWithContentView:view];
    modal.positionMode = STModelPositionCenterTop;
    modal.hideWhenTouchOutside = YES;
    modal.coverFrame = CGRectMake(0, self.qmui_bottom, SCREEN_WIDTH, SCREEN_HEIGHT-self.qmui_bottom);
    __weak __typeof(self)weakSelf = self;
    modal.didTouchOutsideControlBlock = ^{
        weakSelf.typeButton.selected = NO;
        weakSelf.statusButton.selected = NO;
    };
    
    modal.dimBackgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    return modal;
}
- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _statusView.backgroundColor = UIColorWhite;
        UIStackView *stackV = [[UIStackView alloc] initWithFrame:CGRectMake(15, 20, _statusView.width-30, 90)];
        stackV.axis = UILayoutConstraintAxisVertical;
        stackV.distribution = UIStackViewDistributionFillEqually;
        stackV.spacing = 15;
        
        UIStackView *stackH1 = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, _statusView.width, 40)];
        stackH1.axis = UILayoutConstraintAxisHorizontal;
        stackH1.distribution = UIStackViewDistributionFillEqually;
        stackH1.spacing = 20;
        
        UIStackView *stackH2 = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, _statusView.width, 40)];
        stackH2.axis = UILayoutConstraintAxisHorizontal;
        stackH2.distribution = UIStackViewDistributionFillEqually;
        stackH2.spacing = 20;
        
        for (int i=0; i<self.statusDataSource.count; i++) {
            MCFilterButton *button = [self creatStatusButton];
            [self.statusButtons addObject:button];
            if (i<3) {
                [stackH1 addArrangedSubview:button];
            } else {
                [stackH2 addArrangedSubview:button];
            }
        }
        [stackV addArrangedSubview:stackH1];
        [stackV addArrangedSubview:stackH2];
        [_statusView addSubview:stackV];
        
        [_statusView addSubview:({
            QMUIFillButton *button = [[QMUIFillButton alloc] initWithFillColor:MAINCOLOR titleTextColor:UIColorWhite];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            button.frame = CGRectMake(10, _statusView.height-60, SCREEN_WIDTH-20, 50);
            button.cornerRadius = 4;
            [button addTarget:self action:@selector(statusSureTouched:) forControlEvents:UIControlEventTouchUpInside];
            button;
        })];
    }
    return _statusView;
}
- (UIView *)typeView {
    if (!_typeView) {
        _typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
        [_typeView addSubview:self.typeTable];
        _typeView.backgroundColor = UIColorWhite;
        __weak __typeof(self)weakSelf = self;
        [_typeView addSubview:({
            QMUIFillButton *button = [[QMUIFillButton alloc] initWithFillColor:MAINCOLOR titleTextColor:UIColorWhite];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            button.frame = CGRectMake(10, _typeView.height-60, SCREEN_WIDTH-20, 50);
            button.cornerRadius = 4;
            [button addTarget:weakSelf action:@selector(typeSureTouched:) forControlEvents:UIControlEventTouchUpInside];
            button;
        })];
    }
    return _typeView;
}
- (MCFilterButton *)typeButton {
    if (!_typeButton) {
        _typeButton = [self creatButtonWithTitle:@"订单类型"];
    }
    return _typeButton;
}
- (MCFilterButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [self creatButtonWithTitle:@"订单状态"];
    }
    return _statusButton;
}
- (MCFilterButton *)creatButtonWithTitle:(NSString *)title {
    MCFilterButton *button = [MCFilterButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitleColor:UIColor.redColor forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:MAINCOLOR forState:UIControlStateSelected];
    [button setTitleColor:UIColorBlack forState:UIControlStateNormal];
    [button setImage:[UIImage mc_imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    UIImage *selImg = [[UIImage mc_imageNamed:@"arrow_up"] imageWithColor:MAINCOLOR];
    [button setImage:selImg forState:UIControlStateSelected];
    button.titleLabel.font = UIFontMake(15);
    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    button.imagePosition = QMUIButtonImagePositionRight;
    button.spacingBetweenImageAndTitle = 10;
    return button;
}
- (instancetype)initWithFrame:(CGRect)frame type:(MCOrderListType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = UIColorWhite;
    __weak __typeof(self)weakSelf = self;
    [self addSubview:({
        UIStackView *stack = [[UIStackView alloc] init];
        [stack addArrangedSubview:weakSelf.statusButton];
        if (weakSelf.type == MCOrderListTypeNormal) {
            [stack insertArrangedSubview:weakSelf.typeButton atIndex:0];
        }
        stack.axis = UILayoutConstraintAxisHorizontal;
        stack.distribution = UIStackViewDistributionFillEqually;
        stack.spacing = 0;
        stack.frame = weakSelf.bounds;
        stack;
    })];
    NSArray *typeArr = @[
    @{@"code":@"",@"name":@"不限",@"isSelected":@NO},
    @{@"code":@"0",@"name":@"订单充值",@"isSelected":@NO},
    @{@"code":@"1",@"name":@"订单支付",@"isSelected":@NO},
    @{@"code":@"2",@"name":@"订单提现",@"isSelected":@NO},
    @{@"code":@"3",@"name":@"订单退款",@"isSelected":@NO},
    @{@"code":@"7",@"name":@"信用卡还款",@"isSelected":@NO},
    @{@"code":@"8",@"name":@"信用卡充值",@"isSelected":@NO},
    @{@"code":@"9",@"name":@"信用卡消费",@"isSelected":@NO},
    @{@"code":@"10",@"name":@"新信用卡消费",@"isSelected":@NO},
    @{@"code":@"11",@"name":@"新信用卡还款",@"isSelected":@NO}];
    
    NSArray *typeTemp = [MCOrderFilterModel mj_objectArrayWithKeyValuesArray:typeArr];
    self.typeDataSource = [[NSMutableArray alloc] initWithArray:typeTemp];
    
    NSArray *statusArr = @[
    @{@"code":@"",@"name":@"不限",@"isSelected":@NO},
    @{@"code":@"0",@"name":@"待完成",@"isSelected":@NO},
    @{@"code":@"1",@"name":@"已成功",@"isSelected":@NO},
    @{@"code":@"2",@"name":@"已取消",@"isSelected":@NO},
    @{@"code":@"3",@"name":@"待处理",@"isSelected":@NO},
    @{@"code":@"4",@"name":@"待结算",@"isSelected":@NO}];
    NSArray *statusTemp = [MCOrderFilterModel mj_objectArrayWithKeyValuesArray:statusArr];
    self.statusDataSource = [[NSMutableArray alloc] initWithArray:statusTemp];
    
    
    
    
    
}
- (void)reloadStatusView {
    for (int i=0; i<self.statusButtons.count; i++) {
        MCOrderFilterModel *model = self.statusDataSource[i];
        MCFilterButton *button = self.statusButtons[i];
        button.selected = model.isSelected;
        [button setTitle:model.name forState:UIControlStateNormal];
    }
}
#pragma mark - Actions
- (void)overSelected {
    [self.typeModal hide:YES];
    [self.statusModal hide:YES];
    self.typeButton.selected = NO;
    self.statusButton.selected = NO;
}
- (void)statusSureTouched:(QMUIFillButton *)sender {
    [self overSelected];
    if (self.changed && self.delegate) {
        [self.delegate filterDidChangedTypes:self.typeDataSource status:self.statusDataSource];
    }
}
- (void)typeSureTouched:(QMUIFillButton *)sender {
    [self overSelected];
    if (self.changed && self.delegate) {
        [self.delegate filterDidChangedTypes:self.typeDataSource status:self.statusDataSource];
    }
}


- (void)buttonTouched:(QMUIButton *)sender {
    
    if (sender.isSelected) {
        return;
    }
    
    if (sender == self.typeButton) {
        self.statusButton.selected = NO;
        [self.statusModal hide:NO];
        [self.typeModal show:YES];
        [self.typeTable reloadData];
    } else {
        self.typeButton.selected = NO;
        [self.typeModal hide:NO];
        [self.statusModal show:YES];
        [self reloadStatusView];
    }
    
    self.typeButton.selected = NO;
    self.statusButton.selected = NO;
    sender.selected = YES;
    //初始化
    self.changed = NO;
}

- (void)onStatusTouched:(MCFilterButton *)sender {
    self.changed = YES;
    if (sender == self.statusButtons[0]) {
        for (MCOrderFilterModel *model in self.statusDataSource) {
            model.isSelected = NO;
        }
        [self reloadStatusView];
        return;
    }
    sender.selected = !sender.isSelected;
    self.statusDataSource[[self.statusButtons indexOfObject:sender]].isSelected = sender.selected;
}
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCStatusCell *cell = [MCStatusCell cellForTableView:tableView];
    __block MCOrderFilterModel *model = self.typeDataSource[indexPath.row];
    [cell.button setTitle:model.name forState:UIControlStateNormal];
    cell.button.selected = model.isSelected;
    __weak __typeof(self)weakSelf = self;
    cell.touchBlock = ^(QMUIButton * _Nonnull button) {
        weakSelf.changed = YES;
        if (indexPath.row == 0) {
            for (MCOrderFilterModel *model in weakSelf.typeDataSource) {
                model.isSelected = NO;
            }
        } else {
            model.isSelected = button.isSelected;
        }
        [tableView reloadData];
    };
    
    return cell;
}

- (void)dealloc
{
    MCLog(@"filterView dealloc");
}


@end

@implementation MCOrderFilterModel
@end
