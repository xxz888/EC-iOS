//
//  KDJFOrderListViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFOrderListViewController.h"
#import "KDJFOrderTableViewCellTableViewCell.h"
#import "KDJFOrderDetailViewController.h"

@interface KDJFOrderListViewController ()<QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KDJFOrderListViewController
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
    [self setNavigationBarTitle:@"我的订单" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDJFOrderTableViewCellTableViewCell *cell = [KDJFOrderTableViewCellTableViewCell cellWithTableView:tableView];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.orderTitle.text = dic[@"createTime"];
    cell.orderContent.text = dic[@"name"];
    NSInteger status = [dic[@"status"] integerValue];
    cell.orderStatus.text =
    status == 1 ? @"未支付" :
    status == 2 ? @"支付失败" :
    status == 3 ? @"取消" :
    status == 4 ? @"待发货" :
    status == 5 ? @"已发货" :
    status == 10 ? @"确认收货" :
    status == 15 ? @"完成" : @"";
    [cell.orderImv sd_setImageWithURL:dic[@"primaryMessage"]];
    cell.orderPrice.text = [NSString stringWithFormat:@"%@积分+%@元",dic[@"totalCoin"],dic[@"totalPrice"]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDJFOrderDetailViewController * vc = [[KDJFOrderDetailViewController alloc]init];
    vc.orderDic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
