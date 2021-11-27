//
//  KDPayGatherViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/12.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPayGatherViewController.h"
#import "KDCommonAlert.h"
#import "LoginAndRegistHTTPTools.h"
#import "BRStringPickerView.h"
#import "KDCommonAlert.h"
#import "MCDateStore.h"
@interface KDPayGatherViewController ()//<WBQRCodeVCDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *validityLabel;
@property (weak, nonatomic) IBOutlet UILabel *safeCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property(nonatomic, copy) NSString *orderCode;//订单order
@property(nonatomic, copy) NSString *inprovincecode;//省code
@property(nonatomic, copy) NSString *incitycode;//市code
@property(nonatomic, copy) NSString *bindcardmessageid;//验证码id

@property (nonatomic, strong) BRStringPickerView *pickView1;
@property (nonatomic, strong) BRStringPickerView *pickView2;
@end

@implementation KDPayGatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inprovincecode = nil;
    self.incitycode = nil;
    [self.payBtn setTitle:@"确认" forState:0];
    self.nameLabel.text = self.cardModel.userName;
    self.cardNoLabel.text = self.cardModel.cardNo;
    self.validityLabel.text = self.cardModel.expiredTime;
    self.safeCodeLabel.text = self.cardModel.securityCode;
    self.phoneLabel.text = self.cardModel.phone;
    //鉴权绑卡界面
    if ([self.cardModel.jumpWhereVC isEqualToString:@"1"]){
        [self setNavigationBarTitle:@"绑卡确认" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
        self.change1TagLbl.text = @"手机号";
        self.change2TagLbl.text = @"验证码";
        self.change2Lbl.hidden = YES;
        self.codeBtn.hidden = self.codeView.hidden =  NO;
        self.phoneLabel.textColor = [UIColor blackColor];
        self.change2Lbl.textColor = [UIColor blackColor];
        self.phoneLabel.userInteractionEnabled = self.change2Lbl.userInteractionEnabled = NO;
    //交易界面
    }else if ([self.cardModel.jumpWhereVC isEqualToString:@"2"]) {
        [self setNavigationBarTitle:@"支付确认" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
        self.change1TagLbl.text = @"省份";
        self.phoneLabel.text = @"请选择省份";
        self.change2TagLbl.text = @"城市";
        self.change2Lbl.text = @"请选择城市";
        self.change2Lbl.hidden = NO;
        self.codeBtn.hidden = self.codeView.hidden =  YES;
        self.phoneLabel.textColor = [UIColor qmui_colorWithHexString:@"#B4B4B4"];
        self.change2Lbl.textColor = [UIColor qmui_colorWithHexString:@"#B4B4B4"];
        self.phoneLabel.userInteractionEnabled = self.change2Lbl.userInteractionEnabled = YES;
        //选择省
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectShengView:)];
        [self.phoneLabel addGestureRecognizer:tap1];
        //选择市
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectShiView:)];
        [self.change2Lbl addGestureRecognizer:tap2];
    }
    [self showGuidePage];
}
#pragma mark ---------------选择省-------------------
-(void)selectShengView:(id)sender{
    kWeakSelf(self);
    static NSTimeInterval time = 0;
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    //限制用户点击按钮的时间间隔大于1秒钟
        if (currentTime - time > 1) {
        //处理逻辑
            [MCSessionManager.shareManager mc_POST:@"/paymentgateway/topup/dy/getProvince" parameters:@{} ok:^(MCNetResponse * _Nonnull resp) {
                NSArray * resultArray = resp.result;
                NSMutableArray * resultShengArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in resp.result) {
                    [resultShengArray addObject:dic[@"cityName"]];
                }
                if (resultShengArray.count == 0) {
                    return;
                }
                __weak typeof(self) weakSelf = self;
                if (!weakself.pickView2) {
                    weakself.pickView2 = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
                }
                weakself.pickView2.dataSourceArr = [NSArray arrayWithArray:resultShengArray];
                weakself.pickView2.selectValue = resultShengArray[0];
                [weakself.pickView2 show];
                weakself.pickView2.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
                    weakself.phoneLabel.text = resultModel.value;
                    weakself.phoneLabel.textColor = [UIColor blackColor];
                    weakself.change2Lbl.textColor = [UIColor qmui_colorWithHexString:@"#B4B4B4"];
                    weakself.change2Lbl.text = @"请选择城市";
                    for (NSDictionary * dic in resp.result) {
                        if ([resultModel.value isEqualToString:dic[@"cityName"]]) {
                            weakself.inprovincecode = dic[@"cityCode"];
                        };
                    }
                };
                [weakself.pickView2 show];
            } other:^(MCNetResponse * _Nonnull resp) {
                [MCLoading hidden];
                [MCToast showMessage:resp.messege];
            }];
        }
    time = currentTime;

}
#pragma mark ---------------选择市-------------------
-(void)selectShiView:(id)sender{
    kWeakSelf(self);
    if ([self.phoneLabel.text isEqualToString:@"请选择省份"] || !self.inprovincecode) {
        [MCToast showMessage:@"请选择省份"];
        return;
    }
    static NSTimeInterval time = 0;
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    //限制用户点击按钮的时间间隔大于1秒钟
        if (currentTime - time > 1) {
        //处理逻辑
            [MCSessionManager.shareManager mc_POST:@"/paymentgateway/topup/dy/getCity" parameters:@{@"provinceId":self.inprovincecode} ok:^(MCNetResponse * _Nonnull resp) {
                NSArray * resultArray = resp.result;
                NSMutableArray * resultShengArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in resp.result) {
                    [resultShengArray addObject:dic[@"cityName"]];
                }
                if (resultShengArray.count == 0) {
                    return;
                }
                if (!weakself.pickView1) {
                    weakself.pickView1 = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
                }
                weakself.pickView1.dataSourceArr = [NSArray arrayWithArray:resultShengArray];
                weakself.pickView1.selectValue = resultShengArray[0];
                [weakself.pickView1 show];
                weakself.pickView1.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
                    weakself.change2Lbl.text = resultModel.value;
                    weakself.change2Lbl.textColor = [UIColor blackColor];
                    for (NSDictionary * dic in resp.result) {
                        if ([resultModel.value isEqualToString:dic[@"cityName"]]) {
                            weakself.incitycode = dic[@"cityCode"];
                        };
                    }
                };
                [weakself.pickView1 show];
            } other:^(MCNetResponse * _Nonnull resp) {
                [MCLoading hidden];
                [MCToast showMessage:resp.messege];
            }];
        }
    time = currentTime;
    
}
#pragma mark ---------------获取验证码-------------------
- (IBAction)getCodeAction:(UIButton *)sender {
    // 发送验证码
    __weak typeof(self) weakSelf = self;
    [LoginAndRegistHTTPTools getBindCardSMS:self.cardModel result:^(NSString * _Nonnull result) {
        weakSelf.bindcardmessageid = result;
        [self changeSendBtnText:weakSelf.codeBtn];

    }];
}
#pragma mark ---------------绑卡确认请求方法-------------------
-(void)requestBindCardVCAction{
    if ([self.codeView.text isEqualToString:@""]) {
        [MCToast showMessage:@"请填写正确的验证码"];
        return;
    }
    if (!self.bindcardmessageid) {
        [MCToast showMessage:@"请获取验证码"];
        return;
    }
    NSDictionary *params =
    @{
        @"phone":self.cardModel.phone,
        @"idCard":self.cardModel.idcard,
        @"bankCard":self.cardModel.cardNo,
        @"bankName":self.cardModel.bankName,
        @"smsCode":self.codeView.text,
        @"bindcardmessageid":self.bindcardmessageid
     };
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/paymentgateway/topup/dy/bindCard" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.cardModel setJumpWhereVC:@"2"];
        [MCPagingStore pagingURL:rt_card_add withUerinfo:@{@"param":self.cardModel}];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
    }];
}
#pragma mark ---------------收款确认请求方法-------------------
-(void)requestShouKuanAction{
    if ([self.phoneLabel.text isEqualToString:@"请选择省份"] || !self.inprovincecode) {
        [MCToast showMessage:@"请选择省份"];
        return;
    }
    if ([self.change2Lbl.text isEqualToString:@"请选择城市"] || !self.incitycode) {
        [MCToast showMessage:@"请选择城市"];
        return;
    }
    NSDictionary *params =
    @{
        @"orderCode":self.cardModel.orderCode,
        @"inprovincecode":self.inprovincecode,
        @"incitycode":self.incitycode,
        @"money":self.cardModel.money
     };
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/paymentgateway/topup/dy/Pay" parameters:params ok:^(MCNetResponse * _Nonnull resp) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCToast showMessage:resp.messege];
        });
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:SharedUserInfo.userid forKey:@"userId"];
        [params setValue:BCFI.brand_id forKey:@"brandId"];
        [params setValue:[MCDateStore getYear] forKey:@"year"];
        [params setValue:[MCDateStore getMonth] forKey:@"month"];

        [self.sessionManager mc_POST:@"/transactionclear/app/add/querypaybycard/make/information" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
            if ([resp.result[@"content"][0] count] == 0) {
                //这里是确认收款后，跳转收款界面，多做了一个判断防止闪退
                if ([[weakSelf.navigationController viewControllers] count] > 1) {
                    [weakSelf.navigationController popToViewController:[weakSelf.navigationController viewControllers][1] animated:YES];
                }else{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }else{
                    [MCPagingStore pagingURL:rt_card_shoukuanxiangqing withUerinfo:@{@"param":resp.result[@"content"][0]}];
            }
        }];



    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
    }];
}
#pragma mark ---------------底部按钮的公共方法-------------------
- (IBAction)payBtnAction:(UIButton *)sender {
    //鉴权绑卡界面
    if ([self.cardModel.jumpWhereVC isEqualToString:@"1"]){
        [self requestBindCardVCAction];
    //交易界面
    }else if ([self.cardModel.jumpWhereVC isEqualToString:@"2"]) {
        [self requestShouKuanAction];
    }
}

#pragma mark ---------------获取上一个界面的参数，不常用-------------------
- (instancetype)initWithClassification:(MCBankCardModel *)cardModel{
    self = [super init];
    if (self) {
        self.cardModel = cardModel;
    }
    return self;
}
-(void)showGuidePage{
    //空白的frame
    
    CGRect emptyRect = CGRectMake(0, 40+kTopHeight,KScreenWidth, 340);
    NSString * imgStri = [self.cardModel.jumpWhereVC isEqualToString:@"1"] ? @"guide6":@"guide9";
    //图片的frame
    CGRect imgRect = CGRectMake(50,40+kTopHeight+340,kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeXinYongKaShouKuan emptyRect:emptyRect imgRect:imgRect imgStr:imgStri completion:^{}];
}
@end
