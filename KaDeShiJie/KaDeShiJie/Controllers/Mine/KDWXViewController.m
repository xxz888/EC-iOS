//
//  KDWXViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDWXViewController.h"
#import "KDWXViewCell.h"
#import "KDWXModel.h"

@interface KDWXViewController ()<QMUITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KDWXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [self setNavigationBarTitle:@"官方社群微信号" tintColor:[UIColor whiteColor]];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.rowHeight = 373;
    
    [self getWXInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDWXViewCell *cell = [KDWXViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)getWXInfo
{
    [self.sessionManager mc_POST:@"/user/app/WeChatGroup/user/query" parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        self.dataArray = [KDWXModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        [self.mc_tableview reloadData];
    }];
}
@end
