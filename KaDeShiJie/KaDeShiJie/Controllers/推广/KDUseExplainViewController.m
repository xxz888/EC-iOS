//
//  KDUseExplainViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/15.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDUseExplainViewController.h"

@interface KDUseExplainViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, copy) NSMutableArray<MCNewsModel *> *dataSource;
@property(nonatomic, strong) UIImageView *topView;


@end

@implementation KDUseExplainViewController

- (NSMutableArray<MCNewsModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UIImageView *)topView
{
    if (!_topView) {
        _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _topView.image = [UIImage imageNamed:@"kd_share_use_top"];
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"使用说明" tintColor:nil];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    self.mc_tableview.tableHeaderView = self.topView;
    [self requestData];
}

- (void)requestData {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/news/getnewsby/brandidandclassification/andpage" parameters:@{@"brandId":BCFI.brand_id,@"classifiCation":@"使用说明",@"size":@"100"} ok:^(MCNetResponse * _Nonnull resp) {
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
    [MCPagingStore pushWebWithTitle:self.dataSource[indexPath.row].title classification:@"使用说明"];
}

@end
