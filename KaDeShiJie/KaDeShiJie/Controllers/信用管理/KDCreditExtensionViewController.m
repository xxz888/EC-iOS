//
//  KDCreditExtensionViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDCreditExtensionViewController.h"
#import "KDCreditExtensionHeaderView.h"
#import "KDNoCreditViewCell.h"
#import "KDCreditViewViewCell.h"
#import "KDCreditExtensionModel.h"

@interface KDCreditExtensionViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *creditArray; // 已授信
@property (nonatomic, strong) NSMutableArray *dataArray; // 未授信
/** 2:未授信 1:已授信 */
@property (nonatomic, copy) NSString *type;
/** 筛选手机号 */
@property (nonatomic, strong) NSString *userSonPhone;
@property (nonatomic, strong) NSString *searchText;
@end

@implementation KDCreditExtensionViewController

- (NSMutableArray *)creditArray
{
    if (!_creditArray) {
        _creditArray = [NSMutableArray array];
    }
    return _creditArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = @"2";
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    KDCreditExtensionHeaderView *header = [[KDCreditExtensionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 289)];
    [self.view addSubview:header];
    __weak typeof(self) weakSelf = self;
    header.selectIndex = ^(NSInteger type) {
        
        weakSelf.type = [NSString stringWithFormat:@"%ld", (long)type];
        [weakSelf getCreditUserInfo];
    };
    header.searchCredit = ^(NSString * _Nonnull searchStr) {
        weakSelf.searchText = searchStr;
        [weakSelf getCreditUserInfo];
    };
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getCreditUserInfo];
    }];
    [self getCreditUserInfo];
    
    [self setNavigationBarHidden];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"授信管理";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, 289 - 78, SCREEN_WIDTH, SCREEN_HEIGHT - 289 + 78);
}

#pragma mark - QMUITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type.intValue == 2) {
        return self.dataArray.count;
    } else {
        return self.creditArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type.intValue == 2) {
        return 86;
    } else {
        return 116.5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type.intValue == 2) {
        KDNoCreditViewCell *cell = [KDNoCreditViewCell cellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    } else {
        KDCreditViewViewCell *cell = [KDCreditViewViewCell cellWithTableView:tableView];
        cell.model = self.creditArray[indexPath.row];
        return cell;
    }
}
- (void)getCreditUserInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.searchText.length != 0) {
        [params setValue:self.searchText forKey:@"userSonPhone"];
    }
    [params setValue:self.type forKey:@"isAccredit"];
    [self.sessionManager mc_POST:@"/creditcardmanager/app/get/user/son" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if (self.type.intValue == 2) {
            [self.dataArray removeAllObjects];
            self.dataArray = [KDCreditExtensionModel mj_objectArrayWithKeyValuesArray:resp.result];
        } else {
            [self.creditArray removeAllObjects];
            self.creditArray = [KDCreditExtensionModel mj_objectArrayWithKeyValuesArray:resp.result];
        }
        [self.mc_tableview reloadData];
    }];
}
@end
