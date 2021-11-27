//
//  MCUpdateSaveController_Y.m
//  MCOEM
//
//  Created by wza on 2020/5/13.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCUpdateSaveController_Y.h"
#import "MLUpgradeSaveCell.h"
#import "LXUpgradeSaveHeader.h"
#import "MCProductModel.h"


@interface MCUpdateSaveController_Y ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, copy) NSMutableArray<MCProductModel *> *dataSource;
@end

@implementation MCUpdateSaveController_Y

- (NSMutableArray<MCProductModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"升级省钱" tintColor:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
       button.frame = CGRectMake(0, 0, 60, 30);
       [button setTitle:@"客服" forState:UIControlStateNormal];
       [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
       button.titleLabel.font = [UIFont systemFontOfSize:14];
       UIImage *img = [[UIImage mc_imageNamed:@"za_home_btn_kf_icon"] imageWithColor:[UIColor mainColor]];
       [button setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
       button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
       [button addTarget:self action:@selector(onRightTouched) forControlEvents:UIControlEventTouchUpInside];
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.backgroundColor = UIColorWhite;
    self.mc_tableview.rowHeight = UITableViewAutomaticDimension;
    [self requestData];
}

- (void)onRightTouched {
    [MCPagingStore pagingURL:rt_setting_service];
}

- (void)requestData {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/thirdlevel/prod/brand/%@",SharedBrandInfo.ID] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.dataSource removeAllObjects];
        NSArray *tempA = [[[MCProductModel mj_objectArrayWithKeyValuesArray:resp.result] reverseObjectEnumerator] allObjects];
        
        if (SharedUserInfo.brandStatus.boolValue) { //贴牌商
            weakSelf.dataSource = [NSMutableArray arrayWithArray:tempA];
        } else {
            [weakSelf.dataSource removeAllObjects];
            for (MCProductModel *model in tempA) {
                if (model.trueFalseBuy.intValue != 4) {
                    [weakSelf.dataSource addObject:model];
                }
            }
        }
        
        [weakSelf.mc_tableview reloadData];
    }];
}


#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLUpgradeSaveCell *cell = [MLUpgradeSaveCell cellFromTableView:tableView];
    if (self.cellImagesArray) {
        cell.cellImageArr = self.cellImagesArray;
    }
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSource.count) {
        MCProductModel *ptM = [MCProductModel new];
        ptM.grade = @"0";
        ptM.name = @"普通用户";
        NSMutableArray<MCProductModel *>*temp = [NSMutableArray arrayWithArray:self.dataSource];
        [temp insertObject:ptM atIndex:0];
        
        LXUpgradeSaveHeader *header = [[LXUpgradeSaveHeader alloc] initWithGrades:temp];
        header.backgroundColor = tableView.backgroundColor;
        
        return header;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.headerHeight) {
        return [self.headerHeight floatValue];
    }else{
        return 210;
    }
}

@end
