//
//  MCChoosePayment.m
//  Project
//
//  Created by Li Ping on 2019/6/3.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCChoosePayment.h"
#import "MJExtension.h"
#import "MCChoosePaymentCell.h"

#import "MCPayStore.h"
#import "MCPayPWDInputView.h"
#import "KDCommonAlert.h"

static NSString * PAYMENT_CELL_ID = @"MCChoosePaymentCell";

static MCChoosePayment *_singlePayment = nil;

@interface MCChoosePayment ()

@property (nonatomic, assign) double amount;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *coupon_id;

@property(nonatomic, copy) NSString *payForPhone;

@end

@implementation MCChoosePayment

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_singlePayment == nil) {
            _singlePayment = [[self alloc]init];
        }
    });
    return _singlePayment;
}

+ (void)payForWithAmount:(double)amount productId:(NSString *)product_id productName:(NSString *)name couponId:(NSString *)coupon_id payForPhone:(NSString *)payForPhone {
    NSString *message = [NSString stringWithFormat:@"尊敬的会员:您即将购买《%@》产品,如您以后想购买更高等级的产品,则需重新购买,无法补差价哦!【升级之前请先仔细阅读产品费率详情说明】", name];
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:message  isShowClose:NO];
    commonAlert.rightActionBlock = ^{
        MCChoosePayment *instance = [MCChoosePayment shareInstance];
        instance.payForPhone = payForPhone;
        [instance showWithAmount:amount productId:product_id couponId:coupon_id];
    };
    
//    [MCAlertStore showWithTittle:@"温馨提示" message:message buttonTitles:@[@"我知道了",@"立即升级"] sureBlock:^{
//        MCChoosePayment *instance = [MCChoosePayment shareInstance];
//        instance.payForPhone = payForPhone;
//        [instance showWithAmount:amount productId:product_id couponId:coupon_id];
//    } cancelBlock:^{
//
//    }];
}

+ (void)popAlertBeforeShowWithAmount:(double)amount productId:(NSString *)product_id productName:(NSString *)name couponId:(NSString *)coupon_id {
    
    NSString *message = [NSString stringWithFormat:@"尊敬的会员:您即将购买《%@》产品,如您以后想购买更高等级的产品,则需重新购买,无法补差价哦!【升级之前请先仔细阅读产品费率详情说明】", name];
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:message  isShowClose:NO];
    commonAlert.rightActionBlock = ^{
        MCChoosePayment *instance = [MCChoosePayment shareInstance];
        instance.payForPhone = nil;
        [instance showWithAmount:amount productId:product_id couponId:coupon_id];
    };
    
    
//    NSString *title = @"温馨提示";
//    [MCAlertStore showWithTittle:title message:message buttonTitles:@[@"我知道了",@"立即升级"] sureBlock:^{
//        MCChoosePayment *instance = [MCChoosePayment shareInstance];
//        instance.payForPhone = nil;
//        [instance showWithAmount:amount productId:product_id couponId:coupon_id];    } cancelBlock:^{
//
//    }];
}
+ (void)popAlertBeforeShowWithTypes:(NSArray<NSNumber *>*)types amount:(double)amount productId:(NSString *)product_id productName:(NSString *)name couponId:(NSString *)coupon_id {
    
    NSString *message = [NSString stringWithFormat:@"尊敬的会员:您即将购买《%@》产品,如您以后想购买更高等级的产品,则需重新购买,无法补差价哦!【升级之前请先仔细阅读产品费率详情说明】", name];
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:message  isShowClose:NO];
    commonAlert.rightActionBlock = ^{
        MCChoosePayment *instance = [MCChoosePayment shareInstance];
        instance.payForPhone = nil;
        [instance showWithAmount:amount productId:product_id couponId:coupon_id];
    };
    
    
//    NSString *title = @"温馨提示";
//    NSString *message = [NSString stringWithFormat:@"尊敬的会员:您即将购买《%@》产品,如您以后想购买更高等级的产品,则需重新购买,无法补差价哦!【升级之前请先仔细阅读产品费率详情说明】", name];
//    [MCAlertStore showWithTittle:title message:message buttonTitles:@[@"我知道了",@"立即升级"] sureBlock:^{
//        MCChoosePayment *instance = [MCChoosePayment shareInstance];
//        instance.payForPhone = nil;
//        [instance showWithAmount:amount productId:product_id couponId:coupon_id];    } cancelBlock:^{
//
//    }];
    
}


- (void)showWithAmount:(double)amount productId:(NSString *)product_id couponId:(NSString *)coupon_id{
    self.amount = amount;
    self.productId = product_id;
    self.coupon_id=coupon_id;
    [self fetchPaymentTypes];
}
- (void)showWithTypes:(NSArray<NSNumber *> *)types amount:(double)amount productId:(NSString *)product_id {
    NSMutableArray *typlist = [NSMutableArray new];
    self.amount = amount;
    self.productId = product_id;
    
    for (NSNumber *n in types) {
        MCChoosePaymentType type = n.intValue;
        if (type == MCChoosePaymentAliPay) {
            MCPaymentModel *model = [[MCPaymentModel alloc] init];
            model.subName = @"支付宝";
            model.channelTag = @"ALI";
            model.remarks = @"高效、安全、专用(消费)的支付方式";
            model.log = @"https://mc.mingchetech.com/link/img/zhifubaoPay.png";
            [typlist addObject:model];
            
        }
        if (type == MCChoosePaymentWXPay) {
            MCPaymentModel *model = [[MCPaymentModel alloc] init];
            model.subName = @"微信";
            model.channelTag = @"WX";
            model.remarks = @"五大安全保障，打造\"智慧生活\"";
            model.log = @"https://mc.mingchetech.com/link/img/walletPay.png";
            [typlist addObject:model];
            
        }
        if (type == MCChoosePaymentBalance) {
            MCPaymentModel *model = [[MCPaymentModel alloc] init];
            model.subName = @"余额";
            model.channelTag = @"BALANCE_PAY";
            model.remarks = @"方便、快捷、0手续费";
            model.log = @"http://mc.mingchetech.com/link/img/yue.png";
            [typlist addObject:model];
            
        }
        if (type == MCChoosePaymentYinlian) {
            //:TODO
            
        }
    }
    
    [self presentPayMent:typlist];
}

- (void)fetchPaymentTypes{
    
    [MCSessionManager.shareManager mc_POST:@"/user/app/channel/query/all/brandid" parameters:@{@"user_id":SharedUserInfo.userid,@"isPurchaseUpgrade":@"1"} ok:^(MCNetResponse * _Nonnull resp) {
        
        NSArray *typeObjs = [MCPaymentModel mj_objectArrayWithKeyValuesArray:resp.result];
        if (typeObjs.count == 0) {
            [MCToast showMessage:@"未配置支付方式"];
            return;
        }
        NSMutableArray *types = [NSMutableArray new];
        for (MCPaymentModel *m in typeObjs) {
            if ([m.channelNo isEqualToString:@"6"] ) {
                [types addObject:m];
                break;
            }
        }
        for (MCPaymentModel *m in typeObjs) {
            if ([m.channelNo isEqualToString:@"7"]) {
                [types addObject:m];
                break;
            }
        }
        for (MCPaymentModel *m in typeObjs) {
            if ([m.channelNo isEqualToString:@"8"]) {
                [types addObject:m];
                break;
            }
        }
        for (MCPaymentModel *m in typeObjs) {
            if ([m.channelNo isEqualToString:@"9"]) {
                [types addObject:m];
                break;
            }
        }
        [self presentPayMent:types];
    }];
}

- (void)presentPayMent:(NSArray<MCPaymentModel*>*)types {
    if (types.count == 0) {
        [MCToast showMessage:@"未获取到支付方式！"];
        return ;
    }
    MCChoosePaymentController *vc = [[MCChoosePaymentController alloc] initWithTypes:types amount:self.amount productId:self.productId couponId:self.coupon_id];
    vc.payForPhone = self.payForPhone;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UIViewController *current = MCLATESTCONTROLLER;
    current.definesPresentationContext = YES;
    [current presentViewController:vc animated:NO completion:nil];
}

@end


@interface MCChoosePaymentController()<UITableViewDelegate, UITableViewDataSource, MCPayPWDInputViewDelegate>

@property (nonatomic, strong) UITableView *paymentTableView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<MCPaymentModel *> *typeList;

@property (nonatomic, assign) double amount;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *orderDesc;
@property (nonatomic, copy) NSString *coupon_id;
@property(nonatomic, strong) MCPaymentModel *payentModel;


@end

//  view 占屏幕比例
static CGFloat viewScale = 0.5;

@implementation MCChoosePaymentController

- (instancetype)initWithTypes:(NSArray<MCPaymentModel*>*)types amount:(double)amount productId:(NSString*)product_id couponId:(NSString *)coupon_id
{
    self = [super init];
    if (self) {
        self.typeList = [NSMutableArray arrayWithArray:types];
        self.amount = amount;
        self.productId = product_id;
        self.orderDesc = @"购买产品";
        self.coupon_id=coupon_id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
- (void)setup {
    
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeSystem];
    cover.backgroundColor  = [UIColor colorWithWhite:0 alpha:0.3];
    cover.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*viewScale);
    [cover addTarget:self action:@selector(onCoverTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    
    UIView * sview = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*viewScale, SCREEN_WIDTH, SCREEN_HEIGHT*viewScale)];
    sview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sview];
    
    UILabel* title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    title.font=[UIFont boldSystemFontOfSize:18];
    title.text=@"请选择充值方式";
    title.textAlignment=NSTextAlignmentCenter;
    [sview addSubview:title];
    
    CALayer* layer=[CALayer new];
    layer.frame=CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5);
    layer.backgroundColor=UIColor.groupTableViewBackgroundColor.CGColor;
    [sview.layer addSublayer:layer];
    
    [sview addSubview:self.scrollView];
}
- (void)onCoverTouched:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}




- (UITableView *)paymentTableView {
    if (!_paymentTableView) {
        _paymentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height - 50) style:UITableViewStylePlain];
        _paymentTableView.dataSource = self;
        _paymentTableView.delegate = self;
        _paymentTableView.rowHeight = 60;
        _paymentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_paymentTableView registerNib:[UINib nibWithNibName:PAYMENT_CELL_ID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:PAYMENT_CELL_ID];
        if (@available(iOS 11.0, *)) {
            _paymentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _paymentTableView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, self.view.bounds.size.height - 50)];
        [_scrollView addSubview:self.paymentTableView];
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MCChoosePaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:PAYMENT_CELL_ID];
    cell.model = self.typeList[indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        [self dismissViewControllerAnimated:true completion:^{
        if (self.payForPhone) {
            [self handleDaifu:indexPath];
        } else {
            [self handleSelection:indexPath];
        }
    }];
    
}


- (void)handleDaifu:(NSIndexPath *)indexPath {
    MCPaymentModel *model = self.typeList[indexPath.row];
    self.payentModel = model;
    NSString *channelTag;
    if (model.channelNo.intValue == 6) {    //支付宝
        channelTag=@"SPALI_PAY";
    } else if (model.channelNo.intValue == 7) { //微信
        channelTag=@"WX_WAP_PAY";
    } else if (model.channelNo.intValue == 8) { //余额
        channelTag=@"BALANCE_PAY";
    } else if (model.channelNo.intValue == 9) { //金币
        channelTag=@"REBATE_PAY";
    }
        
    NSString *sss=[NSString stringWithFormat:@"%@/v1.0/facade/app/hotboom/purchase?brandId=%@&gradePhone=%@&purchasePhone=%@&orderDesc=%@&produtId=%@&difference=0&channelTag=%@&token=%@",BCFI.pureHost,SharedConfig.brand_id,self.payForPhone,SharedUserInfo.phone,[NSString stringWithFormat:@"%@(代付:%@)",self.orderDesc,self.payForPhone],self.productId,channelTag,SharedDefaults.token];
    
    [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":sss}];
}
- (void)handleSelection:(NSIndexPath *)indexPath {
    MCPaymentModel *model = self.typeList[indexPath.row];
        self.payentModel = model;
        int channelNo = model.channelNo.intValue;
        if (channelNo == 6) {   //微信支付
            [MCPayStore aliPayWithAmount:[NSString stringWithFormat:@"%.2f",self.amount] productId:self.productId orderDesc:self.orderDesc channelTag:@"ALI" couponId:self.coupon_id];
        } else if (channelNo == 7) {    //支付宝支付
            [MCPayStore aliPayWithAmount:[NSString stringWithFormat:@"%.2f",self.amount] productId:self.productId orderDesc:self.orderDesc channelTag:@"WX" couponId:self.coupon_id];
        } else if (channelNo == 8 || channelNo == 9) { //余额、金币
            [self handleAccountPay];
//            MCPayPWDInputView *pwdV = [MCPayPWDInputView newFromNib];
//            pwdV.delegate = self;
//            [pwdV show];
        }
        
        [self dismissViewControllerAnimated:true completion:nil];
}


//使用余额、金币支付
- (void)handleAccountPay{
    int channelNo = self.payentModel.channelNo.intValue;
    if (channelNo == 8) {
        [MCPayStore balancePayWithAmount:[NSString stringWithFormat:@"%.2f",self.amount] productId:self.productId orderDesc:self.orderDesc channelTag:@"BALANCE_PAY" couponId:self.coupon_id];
    } else if (channelNo == 9) {
        [MCPayStore balancePayWithAmount:[NSString stringWithFormat:@"%.2f",self.amount] productId:self.productId orderDesc:self.orderDesc channelTag:@"REBATE_PAY" couponId:self.coupon_id];
    }
}

//#pragma mark - MCPayPWDInputViewDelegate
//- (void)payPWDInputViewDidCommited:(NSString *)pwd {
//    __weak __typeof(self)weakSelf = self;
//    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/paypass/auth/%@",TOKEN] parameters:@{@"paypass":pwd} ok:^(MCNetResponse * _Nonnull resp) {
//        [weakSelf handleAccountPay];
//    }];
//}


@end
