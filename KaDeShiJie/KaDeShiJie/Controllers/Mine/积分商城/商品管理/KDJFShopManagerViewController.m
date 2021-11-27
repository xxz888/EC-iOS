//
//  KDJFOrderListViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFShopManagerViewController.h"
#import "KDJFShopManagerTableViewCell.h"


@interface KDJFShopManagerViewController ()<QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KDJFShopManagerViewController
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
    [self setNavigationBarTitle:@"商品管理" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    
    [self.mc_tableview reloadData];

}

#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 150;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDJFShopManagerTableViewCell *cell = [KDJFShopManagerTableViewCell cellWithTableView:tableView];
    
    if (indexPath.row % 2 == 0) {
        [cell.priceBtn setTitle:@"修改价格" forState:0];
        [cell.priceBtn setBackgroundColor:[UIColor colorWithRed:51/255.0 green:136/255.0 blue:252/255.0 alpha:1.0]];
        ViewBorderRadius(cell.priceBtn, 4, 1,[UIColor colorWithRed:51/255.0 green:136/255.0 blue:252/255.0 alpha:1.0]);
    }else{
        [cell.priceBtn setTitle:@"立即设置" forState:0];
        [cell.priceBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:162/255.0 blue:28/255.0 alpha:1.0]];
        ViewBorderRadius(cell.priceBtn, 4, 1,[UIColor colorWithRed:255/255.0 green:162/255.0 blue:28/255.0 alpha:1.0]);
    }
    return cell;
}


@end
