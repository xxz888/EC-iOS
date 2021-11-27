//
//  KDJFOrderListViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFAdressListViewController.h"
#import "KDJFAdressListTableViewCell.h"

@interface KDJFAdressListViewController ()<QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KDJFAdressListViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.mc_tableview.rowHeight = 130;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyView];
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

    }];
    [self setNavigationBarTitle:@"收货地址" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    
    [self.mc_tableview reloadData];

    [self requestData];
}
-(void)requestData{
    kWeakSelf(self);
    [self.sessionManager mc_Post_QingQiuTi:@"facade/app/coin/order/list" parameters:@{@"status":@"1",
                                                                                      @"count":@"1",
                                                                                      @"startTime":@"2021-06-1 00:00:00",
                                                                                      @"endTime":@"2021-12-31 00:00:00"} ok:^(MCNetResponse * _Nonnull resp) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:resp.result[@"content"]];
        [weakself.mc_tableview reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
    }];
}
#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 200;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    KDJFAdressListTableViewCell *cell = [KDJFAdressListTableViewCell cellWithTableView:tableView];
//
//
//    return cell;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
