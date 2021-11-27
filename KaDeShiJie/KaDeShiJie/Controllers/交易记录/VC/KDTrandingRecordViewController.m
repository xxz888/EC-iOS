//
//  KDTrandingRecordViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//
// 交易记录

#import "KDTrandingRecordViewController.h"
#import "KDTrandingRecordHeaderView.h"
#import "KDTrandingRecordViewCell.h"
#import "KDSlotCardHistoryModel.h"
#import "KDRepaymentModel.h"
#import "KDSlotCardHistoryViewCell.h"
#import "KDSlotCardOrderInfoViewController.h"
#import "KDPlanPreviewViewController.h"
#import "KDPlanKongKaPreviewViewController.h"
@interface KDTrandingRecordViewController ()<KDTrandingRecordHeaderViewDelegate, QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) KDTrandingRecordHeaderView *headerView;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *repaymentArray;
@end

@implementation KDTrandingRecordViewController

- (NSMutableArray *)repaymentArray
{
    if (!_repaymentArray) {
        _repaymentArray = [NSMutableArray array];
    }
    return _repaymentArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (KDTrandingRecordHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDTrandingRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 202)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    
    self.year = [MCDateStore getYear];
    self.month = [MCDateStore getMonth];
    self.mc_tableview.tableHeaderView = self.headerView;
    self.mc_tableview.rowHeight = 130;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyView];

    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getHistory];
    }];
    self.type = 1;
}
-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationBarTitle:@"交易记录" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];

    [self getHistory];
}
#pragma mark - KDTrandingRecordHeaderViewDelegate
- (void)headerViewDelegateWithTime:(NSString *)time
{
    self.year = [time substringWithRange:NSMakeRange(0, 4)];
    self.month = [time substringWithRange:NSMakeRange(4, 2)];
    
    [self getHistory];
}
- (void)headerViewDelegateWithType:(NSInteger)type
{
    self.type = type;
    [self getHistory];
}

#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        return 94;
    } else {
        return 130;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == 1) {
        return self.dataArray.count;
    } else {
        return self.repaymentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        KDSlotCardHistoryViewCell *cell = [KDSlotCardHistoryViewCell cellWithTableView:tableView];
        KDSlotCardHistoryModel *model = self.dataArray[indexPath.row];
        model.orderType = 1;
        cell.slotHistoryModel = model;
        return cell;
    } else {
        KDTrandingRecordViewCell *cell = [KDTrandingRecordViewCell cellWithTableView:tableView];
        KDRepaymentModel *model = self.repaymentArray[indexPath.row];
        model.orderType = self.type;
        cell.repaymentModel = model;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.type == 1) {
        KDSlotCardOrderInfoViewController *vc = [[KDSlotCardOrderInfoViewController alloc] init];
        vc.slotHistoryModel = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //余额还款
    if (self.type == 2) {
        KDRepaymentModel *repaymentModel = self.repaymentArray[indexPath.row];
        //新的余额还款
        KDPlanPreviewViewController *vc = [[KDPlanPreviewViewController alloc] init];
        vc.repaymentModel = repaymentModel;
        vc.orderType = self.type;
        vc.isCanDelete = YES;
        vc.whereCome = 2;// 1 下单 2 历史记录 3 信用卡还款进来
        if (repaymentModel.balance) {
            vc.balancePlanId = repaymentModel.itemId;
        }
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    }
    
    
    //空卡还款
    if (self.type == 3) {
        KDRepaymentModel *repaymentModel = self.repaymentArray[indexPath.row];
        [MCLoading show];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:SharedUserInfo.userid forKey:@"userId"];
        [[MCSessionManager manager] mc_POST:@"/creditcardmanager/app/get/creditcard/by/userid/new" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
            [MCLoading hidden];
            KDDirectRefundModel * directRefundModel = nil;
            NSArray * directModelArray = [KDDirectRefundModel mj_objectArrayWithKeyValuesArray:resp.result];
            for (KDDirectRefundModel * model in directModelArray) {
                if ([model.cardNo isEqualToString:repaymentModel.creditCardNumber]) {
                    directRefundModel = model;
                    break;
                }
            }
            KDPlanKongKaPreviewViewController * vc = [[KDPlanKongKaPreviewViewController alloc]init];
            directRefundModel.hasWaitingEmptyOrder = NSIntegerToNSString(repaymentModel.itemId);
            vc.directModel = directRefundModel;
            vc.whereCome = 2;// 1 下单 2 历史记录 3空卡列表点击进来
            KDTrandingRecordViewCell *cell = [self.mc_tableview cellForRowAtIndexPath:indexPath];
            vc.stateString = cell.statusLabel.text;
            [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        } other:^(MCNetResponse * _Nonnull resp) {
            [MCLoading hidden];
        } failure:^(NSError * _Nonnull error) {
            [MCLoading hidden];
        }];
        
    }
}


#pragma mark - 数据请求
- (void)getHistory
{
    kWeakSelf(self);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [params setValue:BCFI.brand_id forKey:@"brandId"];
    [params setValue:self.year forKey:@"year"];
    [params setValue:self.month forKey:@"month"];
    //刷卡
    if (self.type == 1) {
        [self.sessionManager mc_POST:@"/transactionclear/app/add/querypaybycard/make/information" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
            self.dataArray = [KDSlotCardHistoryModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
            [self.mc_tableview reloadData];
        }];
    }else{

        NSMutableDictionary * kongkaParams = [NSMutableDictionary dictionary];
        [kongkaParams setValue:@"0" forKey:@"page"];
        [kongkaParams setValue:@"100" forKey:@"size"];
        [kongkaParams setValue:SharedUserInfo.userid forKey:@"userId"];
        NSString * minDateTime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",self.year,self.month];
        [kongkaParams setValue:minDateTime forKey:@"minDateTime"];
        [kongkaParams setValue:[self getMaxDateTime] forKey:@"maxDateTime"];
        //余额还款和刷卡
        NSString * url = self.type == 2 ? @"/creditcardmanager/app/balance/plan/list" : @"/creditcardmanager/app/empty/card/plan/list";
        [self.sessionManager mc_Post_QingQiuTi:url parameters:kongkaParams ok:^(MCNetResponse * _Nonnull resp) {
            NSMutableArray * newArray = [[NSMutableArray alloc]initWithArray:resp.result[@"content"]];
            //如果是type=2是余额还款，要兼容老的，所以要再请求一下老的,拼接在一起
            if (weakself.type == 2) {
                [params setValue:@(self.type) forKey:@"orderType"];
                [weakself.sessionManager mc_POST:@"/creditcardmanager/app/add/queryrepayment/make/informationn" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
                    
                    if ([resp.result[@"content"] count] > 0) {
                        [newArray addObjectsFromArray:resp.result[@"content"]];
                    }
                    weakself.repaymentArray = [KDRepaymentModel mj_objectArrayWithKeyValuesArray:newArray];
                    [weakself.mc_tableview reloadData];
                }];

            }else{
                weakself.repaymentArray = [KDRepaymentModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
                [weakself.mc_tableview reloadData];
            }
           
        } other:^(MCNetResponse * _Nonnull resp) {
            [MCLoading hidden];
        } failure:^(NSError * _Nonnull error) {
            [MCLoading hidden];
        }];
    }
    
    [self.mc_tableview.mj_header endRefreshing];
}

-(NSString *)getMaxDateTime{
    NSString * maxMonth = @"";
    NSString * maxYear = [MCDateStore getYear];
    //如果12月
    if ([self.month isEqualToString:@"12"]) {
        maxMonth = @"1";
        maxYear  = NSUIntegerToNSString([maxYear integerValue] + 1);
    }else{
        maxMonth = NSIntegerToNSString([self.month integerValue] + 1);
    }
    return [NSString stringWithFormat:@"%@-%@-01 00:00:00",maxYear,maxMonth];
}

@end
