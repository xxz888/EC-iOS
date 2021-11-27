//
//  MCVideoController.m
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCVideoController.h"
#import "MCBannerView.h"
#import "MCNewsModel.h"

@interface MCVideoController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, copy) NSMutableArray<MCNewsModel *> *dataSource;
@property(nonatomic, strong) MCBannerView *bannerView;


@end

@implementation MCVideoController

- (NSMutableArray<MCNewsModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (MCBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[MCBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175*MCSCALE) bannerType:3];
    }
    return _bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"视频教程" tintColor:nil];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    self.mc_tableview.tableHeaderView = self.bannerView;
    [self requestData];
}

- (void)requestData {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/news/getnewsby/brandidandclassification/andpage" parameters:@{@"brandId":BCFI.brand_id,@"classifiCation":@"视频教程",@"size":@"100"} ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temp = [MCNewsModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        [weakSelf.dataSource removeAllObjects];
        for (MCNewsModel *model in temp) {
            if (SharedUserInfo.brandStatus.intValue !=0 || SharedUserInfo.grade.intValue >= model.onOff.intValue) {
                [weakSelf.dataSource addObject:model];
            }
        }
        [weakSelf.mc_tableview reloadData];
    }];
}

#pragma mark - Tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = UIColorBlack;
    cell.textLabel.text = self.dataSource[indexPath.row].title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MCPagingStore pushWebWithTitle:self.dataSource[indexPath.row].title classification:@"视频教程"];
}
@end
