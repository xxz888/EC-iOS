//
//  MCRateRankViewController.m
//  AFNetworking
//
//  Created by SS001 on 2020/7/22.
//

#import "MCRateRankViewController.h"
#import "MCRateRankViewCell.h"
#import "MCIncomeRateModel.h"
#import "MCRateRankHeaderView.h"

@interface MCRateRankViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MCRateRankViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"收益排行榜" tintColor:[UIColor whiteColor]];
    
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.rowHeight = 96;
    
    [self pullRateDataFromService];
}

//获取排名
-(void)pullRateDataFromService{
    NSDictionary *params = @{@"brandId":MCModelStore.shared.brandConfiguration.brand_id,
                             @"userId":MCModelStore.shared.userInfo.userid,
                             @"startDate":@"2018-09-01"};
    __weak __typeof(self)weakSelf = self;
    [[MCSessionManager shareManager] mc_POST:@"/user/app/rebate/query/ranking/list" parameters:params ok:^(MCNetResponse * _Nonnull okResponse) {
        NSArray *arr = [MCIncomeRateModel mj_objectArrayWithKeyValuesArray:okResponse.result];
        NSArray *array = [arr sortedArrayUsingComparator:^NSComparisonResult(MCIncomeRateModel *obj1, MCIncomeRateModel *obj2) {
            return obj1.ranking.intValue > obj2.ranking.intValue;
        }];
        [weakSelf.dataArray addObjectsFromArray:array];
//        [weakSelf setupTopView];
        [weakSelf.mc_tableview reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.dataArray.count - 3;
    if (count >= 7) {
        return 7;
    } else if (count > 0) {
        return count;
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCRateRankViewCell *cell = [MCRateRankViewCell cellWithTableView:tableView];
    NSInteger offset=self.dataArray.count>3?3:0;
    MCIncomeRateModel* model=self.dataArray[indexPath.row+offset];
    cell.model = model;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MCRateRankHeaderView *headView = [[MCRateRankHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 245)];
    headView.dataArray = self.dataArray;
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 245;
}
@end
