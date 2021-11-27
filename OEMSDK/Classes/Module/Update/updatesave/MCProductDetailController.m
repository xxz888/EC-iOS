//
//  MCProductDetailController.m
//  MCOEM
//
//  Created by wza on 2020/5/13.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCProductDetailController.h"
#import "MCProductDetailCell.h"
#import "MCFeilvModel.h"

@interface MCProductDetailController () <QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, strong) UIView *header;

@property(nonatomic, strong) MCProductModel *productModel;

@property(nonatomic, copy) NSMutableArray<NSMutableArray<MCFeilvModel *> *> *feilvDataSource;

@end

@implementation MCProductDetailController

- (NSMutableArray<NSMutableArray<MCFeilvModel *> *> *)feilvDataSource {
    if (!_feilvDataSource) {
        _feilvDataSource = [NSMutableArray new];
    }
    return _feilvDataSource;
}

- (instancetype)initWithProductModel:(MCProductModel *)model {
    self = [super init];
    if (self) {
        self.productModel = model;
    }
    return self;
}
- (UIView *)header {
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 100)];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage mc_imageNamed:[NSString stringWithFormat:@"product_logo_icon_%d",self.productModel.grade.intValue]]];
        imgView.top = 25;
        imgView.centerX = SCREEN_WIDTH/2;
        [_header addSubview:imgView];
        UILabel *lab = [[UILabel alloc] init];
        lab.font = UIFontMake(16);
        lab.textColor = UIColorGrayDarken;
        lab.text = self.productModel.name;
        [lab sizeToFit];
        lab.top = imgView.bottom + 10;
        lab.centerX = imgView.centerX;
        [_header addSubview:lab];
    }
    return _header;
}
- (void)layoutTableView {
    self.mc_tableview.frame = CGRectMake(0, self.header.bottom+10, SCREEN_WIDTH, SCREEN_HEIGHT-self.header.bottom-10);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"产品详情" tintColor:nil];
    [self.view addSubview:self.header];
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self requestFeilvWithProductID:self.productModel.ID];
}


- (void)requestFeilvWithProductID:(NSString *)productId {
    
    NSDictionary *param = @{@"thirdLevelId":productId};
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/thirdlevel/rate/query/thirdlevelid/" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        
        NSArray *tempArr = [MCFeilvModel mj_objectArrayWithKeyValuesArray:resp.result];
        NSMutableArray *tempHuankuan = [NSMutableArray new];
        NSMutableArray *tempShoukuan = [NSMutableArray new];
        for (MCFeilvModel *model in tempArr) {
            if ([model.subName containsString:@"还款"]) {
                [tempHuankuan addObject:model];
            } else if (model.status.intValue == 1 || model.channelNo.intValue == 1 || model.channelNo.intValue == 2 || model.channelNo.intValue == 5) {
                [tempShoukuan addObject:model];
            }
        }
        NSMutableArray *tempMut = [[NSMutableArray alloc] initWithArray:@[tempHuankuan, tempShoukuan]];
        weakSelf.feilvDataSource = tempMut;
        [weakSelf.mc_tableview reloadData];
    }];
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.feilvDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feilvDataSource[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCProductDetailCell cellWithTableview:tableView channelModel:self.feilvDataSource[indexPath.section][indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.000001f;
    } else {
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

@end
