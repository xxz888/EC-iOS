//
//  KDAisleDetailViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDAisleDetailViewController.h"
#import "KDAisleDetailHeaderView.h"
#import "KDAisleDetailViewCell.h"
#import "KDAisleDetailModel.h"

@interface KDAisleDetailViewController ()<QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation KDAisleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:self.model.name tintColor:[UIColor whiteColor]];
    self.mc_tableview.tableHeaderView = [[KDAisleDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.rowHeight = 51;
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getData];
}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDAisleDetailViewCell *cell = [KDAisleDetailViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)getData {
    [self.sessionManager mc_POST:@"/paymentchannel/app/supportbankbytag/query" parameters:@{@"channelTag":self.model.channelTag} ok:^(MCNetResponse * _Nonnull resp) {
        self.dataArray = [KDAisleDetailModel mj_objectArrayWithKeyValuesArray:resp.result];
        [self.mc_tableview reloadData];
    }];
}
@end
