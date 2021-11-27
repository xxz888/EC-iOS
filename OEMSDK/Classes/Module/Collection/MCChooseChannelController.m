//
//  MCChooseChannelController.m
//  MCOEM
//
//  Created by wza on 2020/5/6.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCChooseChannelController.h"
#import "MCChooseChannelCell.h"

@interface MCChooseChannelController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, copy) NSString *cardNo;
@property(nonatomic, copy) NSString *amount;

@property(nonatomic, strong) NSMutableArray<MCChannelModel *> *dataSource;
@property(nonatomic, strong) chooseChannelBlock handler;

@end

@implementation MCChooseChannelController

- (instancetype)initWithCardNo:(NSString *)no amount:(NSString *)amount handler:(chooseChannelBlock)handeler {
    self = [super init];
    if (self) {
        self.cardNo = no;
        self.amount = amount;
        self.handler = handeler;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"选择收款通道" tintColor:nil];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self requstChannels];
}

#pragma mark - Actions
- (void)requstChannels {
    NSDictionary *param = @{
                                @"userId":SharedUserInfo.userid,
                                @"bankCard":self.cardNo,
                                @"amount":self.amount,
                                @"brandId":SharedConfig.brand_id,
                                @"recommend":@"2"};
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/channel/getchannel/bybankcard/andamount" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        weakSelf.dataSource = [MCChannelModel mj_objectArrayWithKeyValuesArray:resp.result];
        [weakSelf.mc_tableview reloadData];
    }];
    
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [MCChooseChannelCell cellFromTableView:tableView channelInfo:self.dataSource[indexPath.row] amount:self.amount];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.navigationController qmui_popViewControllerAnimated:YES completion:^{
        if (self.handler) {
            self.handler(self.dataSource[indexPath.row]);
        }
    }];
}
@end
