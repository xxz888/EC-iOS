//
//  KDReturnMoneyViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDReturnMoneyViewController.h"
#import "KDProfitDirectPushViewCell.h"
#import "KDReturnMoneyHeaderView.h"
#import "KDProfitDirectPushModel.h"

@interface KDReturnMoneyViewController ()<QMUITableViewDataSource, KDReturnMoneyHeaderViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, strong) KDReturnMoneyHeaderView *header;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger page;

@end

@implementation KDReturnMoneyViewController

- (KDReturnMoneyHeaderView *)header
{
    if (!_header) {
        _header = [[KDReturnMoneyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _header.delegate = self;
    }
    return _header;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    self.mc_tableview.tableHeaderView = self.header;
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSString *first = [self.header.yearBtn.titleLabel.text substringWithRange:NSMakeRange(0, 4)];
    NSString *last = [self.header.monthBtn.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
    self.time = [NSString stringWithFormat:@"%@%@", first, last];
    
    self.mc_tableview.rowHeight = 44;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page =0;
        [self getData];
    }];
    self.mc_tableview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self getData];
    }];
    
    [self getData];
    
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyViewWithKDTitle:@"返现"];
    // 导航条
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [self setNavigationBarHidden];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"返现";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}
- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - QMUITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDProfitDirectPushViewCell *cell = [KDProfitDirectPushViewCell cellWithTableView:tableView];
    cell.nameView.hidden = YES;
    cell.fanyongModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)getData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"5" forKey:@"queryType"];
    [params setValue:self.time forKey:@"queryDate"];
    [params setValue:@"1" forKey:@"level"];
    [params setValue:@(self.page) forKey:@"page"];
    [params setValue:@(20) forKey:@"size"];

    [self.sessionManager mc_POST:@"/transactionclear/app/query/profit/detail" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if ([self.mc_tableview.mj_header isRefreshing]) {
            [self.mc_tableview.mj_header endRefreshing];
        }
        if ([self.mc_tableview.mj_footer isRefreshing]) {
            [self.mc_tableview.mj_footer endRefreshing];
        }
        
        
        if (self.page == 0) {
            self.dataArray = [KDProfitDirectPushModel mj_objectArrayWithKeyValuesArray:resp.result];
        }else{
            NSMutableArray * plusArray = [KDProfitDirectPushModel mj_objectArrayWithKeyValuesArray:resp.result];
            [self.dataArray addObjectsFromArray:plusArray];
        }
        
        
        [self.mc_tableview reloadData];
        
    }];
}
- (void)returnMoneyHeaderViewGetTime:(NSString *)yearMonth
{
    self.page = 0;
    self.time = yearMonth;
    [self getData];
}
@end
