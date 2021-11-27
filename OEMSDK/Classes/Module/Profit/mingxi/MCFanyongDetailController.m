//
//  MCFanyongDetailController.m
//  MCOEM
//
//  Created by yujia tian on 2020/5/10.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCFanyongDetailController.h"

@interface MCFanyongDetailController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property (nonatomic, strong) MCFanyongModel *model;
@property(nonatomic, copy) NSArray<NSArray<NSDictionary *> *> *dataSource;

@end

@implementation MCFanyongDetailController

- (instancetype)initWithFanyongModel:(MCFanyongModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:@"返佣详情" tintColor:UIColor.whiteColor];
    self.mc_tableview.mj_header = nil;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.rowHeight = 50;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    
    self.dataSource=@[
//    @[
//        @{@"title":@"收益人号码",@"subTitle":_model.acqphone},
//        @{@"title":@"收益人费率",@"subTitle":[NSString stringWithFormat:@"%.2f%%",[_model.acqratio floatValue]*100]}],
    @[
        @{@"title":@"刷卡人号码",@"subTitle":_model.oriphone},
        @{@"title":@"刷卡人金额",@"subTitle":_model.amount},
        @{@"title":@"订单号",@"subTitle":_model.ordercode},
        @{@"title":@"交易时间",@"subTitle":_model.createTime},
        @{@"title":@"备注",@"subTitle":_model.remark}
    ]
    ];
    
    [self.mc_tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    cell.detailTextLabel.text = [dic objectForKey:@"subTitle"];
    cell.textLabel.textColor = UIColorBlack;
    cell.detailTextLabel.textColor = UIColorGrayDarken;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    header.backgroundColor = UIColorForBackground;
    return header;
}


@end
