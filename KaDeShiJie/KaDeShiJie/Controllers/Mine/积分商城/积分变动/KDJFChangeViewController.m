//
//  KDJFOrderListViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFChangeViewController.h"
#import "KDJFChangeTableViewCell.h"

@interface KDJFChangeViewController ()<QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KDJFChangeViewController

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
    [self setNavigationBarTitle:@"积分变动" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    
    [self.mc_tableview reloadData];

    [self requestData];
}
-(void)requestData{
    kWeakSelf(self);

    [self.sessionManager mc_Post_QingQiuTi:@"user/app/coin/list" parameters:@{@"page":@"1",@"size":@"10"} ok:^(MCNetResponse * _Nonnull resp) {
        if (resp) {
            [weakself.dataArray removeAllObjects];
            [weakself.dataArray addObjectsFromArray:resp.result];
            [weakself.mc_tableview reloadData];
        }

    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
    }];
}
#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 30;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDJFChangeTableViewCell *cell = [KDJFChangeTableViewCell cellWithTableView:tableView];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.timeLbl.text = dic[@"createTime"];
    cell.contentLbl.text = dic[@"name"];
    cell.countLBl.text = [NSString stringWithFormat:@"%@积分+%@元",dic[@"totalCoin"],dic[@"totalPrice"]];

    return cell;
}


@end
