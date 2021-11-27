//
//  KDSlotCardAisleViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDSlotCardAisleViewController.h"
#import "KDSlotCardAisleHeaderView.h"
#import "KDSlotCardAisleViewCell.h"
#import "KDPayGatherViewController.h"
#import "KDCommonAlert.h"
#import "MCCustomModel.h"
@interface KDSlotCardAisleViewController ()<QMUITableViewDelegate, QMUITableViewDataSource, WBQRCodeVCDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *orderCode;
@end

@implementation KDSlotCardAisleViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    KDSlotCardAisleHeaderView *header = [[KDSlotCardAisleHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    header.moneyView.text = [NSString stringWithFormat:@"%@元", self.money];
    self.mc_tableview.tableHeaderView = header;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self getData];
    self.mc_tableview.rowHeight = 115;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setNavigationBarTitle:@"选择刷卡通道" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    
    [self showGuidePage];
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
    KDSlotCardAisleViewCell *cell = [KDSlotCardAisleViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

       [self payAction:self.dataArray[indexPath.row] cardModel:self.xinyongInfo];
}

- (void)payAction:(MCChannelModel *)channelModel cardModel:(MCBankCardModel *)cardModel
{
    NSString *phone = SharedUserInfo.phone;
    NSString *order_desc = [NSString stringWithFormat:@"%@%@", channelModel.name,channelModel.channelParams];
    NSString *channe_tag = [NSString stringWithFormat:@"%@", channelModel.channelTag];
    
    NSDictionary *param = @{
                            @"amount":self.money,
                            @"orderDesc":order_desc,
                            @"phone":phone,
                            @"channeTag":channe_tag,
                            @"brandId":SharedConfig.brand_id,
                            @"userId":SharedUserInfo.userid,
                            @"bankCard":cardModel.cardNo,
                            @"creditBankName":cardModel.bankName};
    kWeakSelf(self);
    [MCSessionManager.shareManager mc_POST:@"/facade/app/topup/new" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        NSString * result = resp.result;
        [weakself.xinyongInfo setMoney:weakself.money];
        //电银的通道
        if ([channe_tag containsString:DYPay_QUICK]) {
            NSString * orderCode = [result componentsSeparatedByString:@"orderCode="][1];
            if ([[orderCode componentsSeparatedByString:@"&"] count] > 0) {
                orderCode = [orderCode componentsSeparatedByString:@"&"][0];
                [weakself.xinyongInfo setOrderCode:orderCode];
                [weakself.xinyongInfo setJumpWhereVC:[resp.messege containsString:@"跳转交易页面"] ? @"2" : @"1"];
                [MCPagingStore pagingURL:rt_card_add withUerinfo:@{@"param":weakself.xinyongInfo}];
            }
        //其它通道
        }else{
            //拼凑的model
            MCCustomModel * customModel = [[MCCustomModel alloc]init];
            [customModel setValue:result forKey:@"api"];    //短信的api
            [customModel setValue:shoukuan_jianquan forKey:@"whereCome"];//收款界面
            [customModel setValue:channe_tag forKey:@"bindChannelName"];//通道
            //在判断是鉴权还是交易
            [MCPagingStore pagingURL:[resp.messege containsString:@"跳转交易页面"] ? rt_card_jiaoyi : rt_card_jianquan  withUerinfo:@{@"param":weakself.xinyongInfo,@"extend":customModel}];
        }
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        if ([resp.code isEqualToString:@"666666"]) {
            if (resp.result && [resp.result isKindOfClass:[NSString class]] && [resp.result containsString:@"http"]) {  //花呗身份校验
                [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp.result}];
            } else {
                [MCToast showMessage:resp.result];
            }
        } else {
            [MCToast showMessage:resp.messege];
        }
    }];
}
- (void)getData {
    NSDictionary *param = @{@"userId":SharedUserInfo.userid,
                            @"bankCard":self.xinyongInfo.cardNo,
                            @"amount":self.money,
                            @"brandId":BCFI.brand_id,
                            @"recommend":@(2),
                            @"status":@"1"
                            };
    /*
     long userId,
     Integer brandId,
     String bankCard,
     String amount,
     String channelNo, //不传时默认为2，表示只查快捷通道
     String channelTag,//可以不传，传了只查一个通道
     String status //状态1：启用，0：未启用
     
     **/
    [self.sessionManager mc_POST:@"/user/app/channel/getchannel/bybankcard/andamount" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        self.dataArray = [MCChannelModel mj_objectArrayWithKeyValuesArray:resp.result];
        [self.mc_tableview reloadData];
    }];
}
#pragma mark - WBQRCodeVCDelegate
- (void)scancodeViewControllerComplete:(NSString *)str {
//    if (!str || str.length < 1) {
//        return;
//    }
//
//    NSString *msg = [NSString stringWithFormat:@"您正在发起一笔%@元的收款，确定后将从对方支付宝账户自动扣款", self.money];
//    QMUIModalPresentationViewController * alert = [[QMUIModalPresentationViewController alloc]init];
//    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
//    [commonAlert initKDCommonAlertTitle:@"温馨提示" content:msg leftBtnTitle:@"取消" rightBtnTitle:@"确定" ];
//    alert.contentView = commonAlert;
//    commonAlert.leftActionBlock = ^{
//        [alert hideWithAnimated:YES completion:nil];
//    };
//    commonAlert.rightActionBlock = ^{
//        NSDictionary *param = @{@"authCode":str,@"orderCode":self.orderCode};
//        [MCSessionManager.shareManager mc_POST:@"/facade/topup/yxhb/trade" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
//            if (resp.result && [resp.result isKindOfClass:[NSString class]] && [resp.result containsString:@"http"]) {
//                [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp.result}];
//            }
//        }];
//    };
//    [alert showWithAnimated:YES completion:nil];
    
    
//    NSString *msg = [NSString stringWithFormat:@"您正在发起一笔%@元的收款，确定后将从对方支付宝账户自动扣款", self.money];
//    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:QMUIAlertControllerStyleAlert];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//
//        NSDictionary *param = @{@"authCode":str,@"orderCode":self.orderCode};
//        [MCSessionManager.shareManager mc_POST:@"/facade/topup/yxhb/trade" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
//            if (resp.result && [resp.result isKindOfClass:[NSString class]] && [resp.result containsString:@"http"]) {
//                [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp.result}];
//            }
//        }];
//
//    }]];
//    [alert showWithAnimated:YES];
}
-(void)showGuidePage{
    //空白的frame
    CGRect emptyRect = CGRectMake(0, 160+kTopHeight,KScreenWidth, 115*2);
    //图片的frame
    CGRect imgRect = CGRectMake(100,160+kTopHeight+230, kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeXinYongKaShouKuan emptyRect:emptyRect imgRect:imgRect imgStr:@"guide5" completion:^{}];
}
@end
