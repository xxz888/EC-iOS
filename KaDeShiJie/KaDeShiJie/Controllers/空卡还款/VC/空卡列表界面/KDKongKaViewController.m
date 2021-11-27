//
//  KDKongKaViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDKongKaViewController.h"
#import "KDKongKaTableViewCell.h"
#import "KDDirectRefundModel.h"
#import "KDTrandingRecordViewController.h"
#import "KDPlanKongKaPreviewViewController.h"
@interface KDKongKaViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *etyView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic, strong) QMUIPopupMenuView *menuView;
@property (nonatomic, strong) MCBankCardModel *xinyongInfo;
@property (nonatomic, strong) KDDirectRefundModel *refundModel;
@end

@implementation KDKongKaViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (QMUIPopupMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[QMUIPopupMenuView alloc] init];
        _menuView.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        _menuView.maskViewBackgroundColor = UIColorMask;// 使用方法 2 并且打开了 automaticallyHidesWhenUserTap 的情况下，可以修改背景遮罩的颜色
        _menuView.shouldShowItemSeparator = YES;
        _menuView.itemTitleFont = [UIFont systemFontOfSize:13];
        __weak __typeof(self)weakSelf = self;
        _menuView.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
            
            [aItem.button setTitleColor:UIColorBlack forState:UIControlStateNormal];
        };
        
        QMUIPopupMenuButtonItem *item1 = [QMUIPopupMenuButtonItem itemWithImage:[UIImage imageNamed:@"kd_direct_refund_0"] title:@"使用说明" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            [MCPagingStore pushWebWithTitle:@"空卡使用说明" classification:@"功能跳转"];
            [aItem.menuView hideWithAnimated:YES];
        }];
        
        QMUIPopupMenuButtonItem *item2 = [QMUIPopupMenuButtonItem itemWithImage:[UIImage imageNamed:@"kd_direct_refund_1"] title:@"交易记录" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            [weakSelf.navigationController pushViewController:[KDTrandingRecordViewController new] animated:YES];
            [aItem.menuView hideWithAnimated:YES];
        }];
        
        QMUIPopupMenuButtonItem *item3 = [QMUIPopupMenuButtonItem itemWithImage:[UIImage imageNamed:@"kd_direct_refund_2"] title:@"点击刷新" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            [weakSelf getDirectCardData];
            [aItem.menuView hideWithAnimated:YES];
        }];
        _menuView.items = @[item1, item2, item3];
    }
    return _menuView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getDirectCardData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:self.navTitle tintColor:UIColor.whiteColor];
    [self setupView];
}

- (void)setupView
{
    self.topView.layer.cornerRadius = 10;
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 150;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mc_tableviewRefresh)];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"使用说明" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];

}
- (void)clickRightBtnAction
{
    [MCPagingStore pushWebWithTitle:@"空卡使用说明" classification:@"功能跳转"];
}
- (void)setupNavigationItems {
    [super setupNavigationItems];
    
//    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithTitle:@"•••" target:self action:@selector(rightTouched:)];
//    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
//
//    self.navigationItem.rightBarButtonItem = rightItem;
//    self.menuView.sourceBarItem = rightItem;
}
-(void)mc_tableviewRefresh{
    [self getDirectCardData];
}
- (void)rightTouched:(UIBarButtonItem *)item {
    [self.menuView showWithAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDKongKaTableViewCell *cell = [KDKongKaTableViewCell cellWithTableView:tableView];
    cell.titleString = self.navTitle;
    cell.refundModel = self.dataArray[indexPath.row];
    
    cell.refreshUIBlock = ^{
        [self getDirectCardData];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (IBAction)clickBottomBtnAction:(id)sender {
    [[KDGuidePageManager shareManager] requestShiMing:^{
        [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(0), @"isLogin":@(YES)}];
    }];
}

- (void)getDirectCardData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    kWeakSelf(self);
    [MCLoading show];

    [self.sessionManager mc_POST:@"/creditcardmanager/app/get/creditcard/by/userid/new" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.dataArray removeAllObjects];
        weakself.dataArray = [KDDirectRefundModel mj_objectArrayWithKeyValuesArray:resp.result];
        if (weakself.dataArray == 0) {
            weakself.tableView.hidden = YES;
            weakself.etyView.hidden = NO;
        } else {
            weakself.tableView.hidden = NO;
            weakself.etyView.hidden = YES;
            [weakself.tableView reloadData];
        }
    }];
}
@end
