//
//  KDProfitViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDProfitViewController.h"
#import "KDProfitHeaderView.h"
#import "KDProfitViewCell.h"
#import "KDProfitCellHeaderView.h"
#import "KDProfitDirectPushViewController.h"
#import "KDProfitModel.h"

@interface KDProfitViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>
@property (nonatomic, strong) KDProfitHeaderView *headView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *choseTime;
@property (nonatomic, strong) NSString *centerTitle;
@property (nonatomic, copy) NSString *queryType;
@property (nonatomic, strong) KDProfitModel *profitModel;
@end

@implementation KDProfitViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        
        NSArray *arr = @[@{
                             @"name":@"直推",
                             @"slotcard":@"0.00",
                             @"profit":@"0.00"
        }, @{
                             @"name":@"间推",
                             @"slotcard":@"0.00",
                             @"profit":@"0.00"
        }, @{
                             @"name":@"二级间推",
                             @"slotcard":@"0.00",
                             @"profit":@"0.00"
        }];
        _dataArray = [NSMutableArray arrayWithArray:arr];
    }
    return _dataArray;
}

- (KDProfitHeaderView *)headView
{
    if (!_headView) {
        _headView = [[KDProfitHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 325)];
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.choseTime = [NSString stringWithFormat:@"%@年%@月", [MCDateStore getYear], [MCDateStore getMonth]];
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.headView.navTitle = self.viewType;
    self.mc_tableview.tableHeaderView = self.headView;
    __weak typeof(self) weakSelf = self;
    self.headView.getDataWithReloadData = ^(KDProfitModel * _Nonnull profitModel) {
        weakSelf.profitModel = profitModel;
    };
    self.mc_tableview.delegate = self;
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
    titleLabel.text = self.viewType;
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
}

- (void)setProfitModel:(KDProfitModel *)profitModel
{
    _profitModel = profitModel;
    
    [self.dataArray removeAllObjects];
    NSArray *arr = @[@{
                         @"name":@"直推",
                         @"slotcard":profitModel.direc1.amount,
                         @"profit":profitModel.direc1.rebate ? profitModel.direc1.rebate : @"0.00"
    }, @{
                         @"name":@"间推",
                         @"slotcard":profitModel.direc2.amount,
                         @"profit":profitModel.direc2.rebate ? profitModel.direc2.rebate : @"0.00"
    }, @{
                         @"name":@"二级间推",
                         @"slotcard":profitModel.direc3.amount,
                         @"profit":profitModel.direc3.rebate ? profitModel.direc3.rebate : @"0.00"
    }];
    //MCLog(@"%@", arr);
    _dataArray = [NSMutableArray arrayWithArray:arr];
    [self.mc_tableview reloadData];
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    KDProfitCellHeaderView *head = [[KDProfitCellHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if ([self.viewType isEqualToString:@"刷卡分润"]) {
        self.centerTitle = @"刷卡（元）";
    }
    if ([self.viewType isEqualToString:@"还款分润"]) {
        self.centerTitle = @"还款（元）";
    }
    if ([self.viewType isEqualToString:@"空卡分润"]) {
        self.centerTitle = @"空卡（元）";
    }
    if ([self.viewType isEqualToString:@"共享智还分润"]) {
        self.centerTitle = @"共享智还（元）";
    }
    if ([self.viewType isEqualToString:@"花呗分润"]) {
        self.centerTitle = @"花呗收款（元）";
    }
    head.centerView.text = self.centerTitle;
    return head;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDProfitViewCell *cell = [KDProfitViewCell cellWithTableView:tableView];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.nameView.text = dict[@"name"];
    cell.centerView.text = [NSString stringWithFormat:@"%.2f", [dict[@"slotcard"] floatValue]];
    cell.rightView.text = [NSString stringWithFormat:@"%.2f", [dict[@"profit"] floatValue]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choseTime = [self.headView.yearBtn.currentTitle stringByAppendingFormat:@"%@", self.headView.monthBtn.currentTitle];
    NSDictionary *dict = self.dataArray[indexPath.row];
    KDProfitDirectPushViewController *vc = [[KDProfitDirectPushViewController alloc] init];
    vc.titleString = dict[@"name"];
    vc.timeString = self.choseTime;
    vc.centerTitle = self.centerTitle;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
