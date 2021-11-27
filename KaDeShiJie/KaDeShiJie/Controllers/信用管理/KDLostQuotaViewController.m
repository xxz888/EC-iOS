//
//  KDLostQuotaViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDLostQuotaViewController.h"
#import "KDLostQuotaViewCell.h"
#import "KDCreditExtensionModel.h"

@interface KDLostQuotaViewController ()<QMUITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KDLostQuotaViewController

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
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [self setNavigationBarTitle:@"丢失信用" tintColor:[UIColor mainColor]];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.rowHeight = 85;
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyView];
    [self getCreditUserInfo];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDLostQuotaViewCell *cell = [KDLostQuotaViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    if ([self.titleString isEqualToString:@"弥补"]) {
        cell.remedyBtn.hidden = NO;
    } else {
        cell.remedyBtn.hidden = YES;
    }
    return cell;
}

- (void)getCreditUserInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    [params setValue:@"0" forKey:@"isAccredit"];
    [params setValue:@"1" forKey:@"isLost"];
    [self.sessionManager mc_POST:@"/creditcardmanager/app/get/user/son" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        self.dataArray = [KDCreditExtensionModel mj_objectArrayWithKeyValuesArray:resp.result];
        [self.mc_tableview reloadData];
    }];
}
@end
