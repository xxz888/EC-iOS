//
//  MCNewsListController.m
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCNewsListController.h"
#import "MCNewsModel.h"
#import "MCNewsCell.h"

@interface MCNewsListController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, copy) NSString *classification;
@property(nonatomic, copy) NSMutableArray<MCNewsModel *> *dataSource;

@end

@implementation MCNewsListController
- (NSMutableArray<MCNewsModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (instancetype)initWithClassification:(NSString *)classification {
    self = [super init];
    if (self) {
        self.classification = classification;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:self.classification tintColor:nil];
    
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    
    [self requstData];
}
- (void)requstData {
    NSDictionary *param = @{@"brandId":SharedConfig.brand_id,@"size":@"999",@"classifiCation":self.classification};
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/news/getnewsby/brandidandclassification/andpage" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        weakSelf.dataSource = [MCNewsModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        [weakSelf.mc_tableview reloadData];
    }];
}

#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCNewsCell cellWithTableview:tableView newsModel:self.dataSource[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataSource[indexPath.row].title;
    [MCPagingStore pushWebWithTitle:title classification:self.classification];
}


@end
