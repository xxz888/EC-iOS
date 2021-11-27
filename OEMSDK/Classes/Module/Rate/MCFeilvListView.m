//
//  MCFeilvListView.m
//  MCOEM
//
//  Created by wza on 2020/4/25.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCFeilvListView.h"
#import "MCFeilvCell.h"

@interface MCFeilvListView ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, strong) QMUITableView *tableView;
@property(nonatomic, strong) UIView *hkSectionHeader;
@property(nonatomic, strong) UIView *skSectionHeader;

@end

@implementation MCFeilvListView

- (void)setFeilvDataSource:(NSMutableArray<NSMutableArray<MCFeilvModel *> *> *)feilvDataSource {
    _feilvDataSource = feilvDataSource;
    [self.tableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self addSubview:self.tableView];
}

- (UIView *)creatSectionHeader:(NSString *)type {
    CGFloat sepH = [type isEqualToString:@"huankuan"] ? 0 : 10;
    UIView * sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60+sepH)];
    sectionHeader.backgroundColor = UIColorWhite;
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sepH)];
    sep.backgroundColor = UIColorSeparator;
    [sectionHeader addSubview:sep];
    QMUILabel *lab1 = [[QMUILabel alloc] init];
    lab1.font = UIFontBoldMake(15);
    lab1.textColor = UIColorBlack;
    lab1.textAlignment = NSTextAlignmentCenter;
    QMUILabel *lab2 = [[QMUILabel alloc] init];
    [lab2 qmui_setTheSameAppearanceAsLabel:lab1];
    QMUILabel *lab3 = [[QMUILabel alloc] init];
    [lab3 qmui_setTheSameAppearanceAsLabel:lab1];
    lab1.text = @"通道名称";
    lab2.text = [type isEqualToString:@"huankuan"] ? @"代还费率" : @"刷卡费率";
    lab3.text = @"单笔限额";
    UIStackView *stack = [[UIStackView alloc] initWithFrame:CGRectMake(0, sepH, sectionHeader.qmui_width, sectionHeader.qmui_height-10)];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.spacing = 0;
    [stack addArrangedSubview:lab1];
    [stack addArrangedSubview:lab2];
    [stack addArrangedSubview:lab3];
    [sectionHeader addSubview:stack];
    
    return sectionHeader;
}
- (UIView *)hkSectionHeader {
    if (!_hkSectionHeader) {
        _hkSectionHeader = [self creatSectionHeader:@"huankuan"];
    }
    return _hkSectionHeader;
}
- (UIView *)skSectionHeader {
    if (!_skSectionHeader) {
        _skSectionHeader = [self creatSectionHeader:@"shuaka"];
    }
    return _skSectionHeader;
}
- (QMUITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[QMUITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorWhite;
        _tableView.ly_emptyView = [MCEmptyView emptyView];
    }
    return _tableView;
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.feilvDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feilvDataSource[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCFeilvCell *cell = [MCFeilvCell cellWithTableView:tableView];
    MCFeilvModel *model = self.feilvDataSource[indexPath.section][indexPath.row];
    
    cell.channelName.text = [NSString stringWithFormat:@"%@ %@", model.name, model.channelParams];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.log] placeholderImage:SharedAppInfo.icon];
    cell.feilvLab.text = [NSString stringWithFormat:@"%.2f%%",model.rate.floatValue*100];
    NSString *maxLimit;
    if (model.singleMaxLimit.floatValue < 10000) {
        maxLimit = [NSString stringWithFormat:@"%.f",model.singleMaxLimit.floatValue];
    } else {
        maxLimit = [NSString stringWithFormat:@"%.0f万", model.singleMaxLimit.floatValue/10000];
    }
    cell.limitLab.text = [NSString stringWithFormat:@"%@-%@",model.singleMinLimit,maxLimit];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    } else {
        return 70;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.hkSectionHeader;
    } else {
        return self.skSectionHeader;
    }
}









@end
