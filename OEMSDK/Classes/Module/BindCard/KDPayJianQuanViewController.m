//
//  KDPayJianQuanViewController.m
//  OEMSDK
//
//  Created by apple on 2020/11/28.
//

#import "KDPayJianQuanViewController.h"
#import "KDCommonAlert.h"
#import "LoginAndRegistHTTPTools.h"
#import "KDCommonAlert.h"
#import "KDChannelView.h"
#import "KDBindChannelManager.h"
@interface KDPayJianQuanViewController ()
@property(nonatomic, copy) NSString * bindUrl;//接收验证码获取成功返回的url
@end
@implementation KDPayJianQuanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"绑卡确认" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    self.codeBtn.hidden = self.codeView.hidden =  NO;
    self.phoneLabel.textColor = [UIColor blackColor];
    self.nameLabel.text = self.cardModel.userName;
    self.cardNoLabel.text = self.cardModel.cardNo;
    self.validityLabel.text = self.cardModel.expiredTime;
    self.safeCodeLabel.text = self.cardModel.securityCode;
    self.phoneLabel.text = self.cardModel.phone;

    [self showGuidePage];
}
#pragma mark ---------------获取验证码-------------------
- (IBAction)getCodeAction:(UIButton *)sender {
    kWeakSelf(self);
    //收款
    if ([self.extendModel.whereCome isEqualToString:shoukuan_jianquan]) {
        [self shoukuan_jianquan_SendMessage];
    }
    //空卡还款
    if ([self.extendModel.whereCome isEqualToString:kongkahuankuan_jianquan]) {
        [self kongkahuankuan_jianquan_SendMessage];
    }
    //余额还款
    if ([self.extendModel.whereCome isEqualToString:yuehuankuan_jianquan]) {
        [self yuehuankuan_jianquan_SendMessage];
    }
}
#pragma mark ---------------①发送验证码,收款界面进来-------------------
-(void)shoukuan_jianquan_SendMessage{
    kWeakSelf(self);
    NSMutableDictionary * dic = [MCSessionManager dictionaryWithUrlString:self.extendModel.api];
    NSString * url = [self.extendModel.api split:@"?"][0];
    [[MCSessionManager shareManager] mc_POST:url parameters:dic ok:^(MCNetResponse * _Nonnull okResponse) {
        // 发送验证码
        [weakself changeSendBtnText:weakself.codeBtn];
        weakself.bindUrl  = okResponse.result;
    }];
}
#pragma mark ---------------②发送验证码,空卡还款界面进来-------------------
-(void)kongkahuankuan_jianquan_SendMessage{
    //聚合空卡
    if ([self.extendModel.bindChannelName isEqualToString:TYDE_8920_QUICK] ) {
        [self sendMessageCommonAction];

    }
    if ([self.extendModel.bindChannelName isEqualToString:DFPay_QUICK]) {
        [self sendMessageCommonAction];

    }
}
#pragma mark ---------------③发送验证码,余额还款界面进来-------------------
-(void)yuehuankuan_jianquan_SendMessage{
    //余额还款界面进来，公用一个发送验证码的方法，改掉了之前分开的，我了增加通道，前端不用改变
    [self sendMessageCommonAction];
}
-(void)sendMessageCommonAction{
    kWeakSelf(self);
    NSDictionary * dic = @{@"bankCard":self.cardModel.cardNo,
                           @"idCard":self.cardModel.idcard,
                           @"phone":self.cardModel.phone,
                           @"userName":self.cardModel.userName,
                           @"bankName":self.cardModel.bankName,
                           
                           @"expiredTime":self.cardModel.expiredTime,
                           @"securityCode":self.cardModel.securityCode,
                           @"channelTag":self.cardModel.channelTag,
                           @"rate":self.cardModel.rate,
                           @"extraFee":self.cardModel.extraFee,

                           @"dbankCard":self.cardModel.dbankCard,
                           @"dbankName":self.cardModel.dbankName,
                           @"dphone":self.cardModel.dphone,
                           @"userId":SharedUserInfo.userid
    };
    [[MCSessionManager shareManager] mc_POST:self.extendModel.smsApi parameters:dic ok:^(MCNetResponse * _Nonnull okResponse) {
        // 发送验证码
        [weakself changeSendBtnText:weakself.codeBtn];
        weakself.bindUrl  = okResponse.result ? okResponse.result : @"";
    }];
}




#pragma mark ---------------输入验证码，绑卡鉴权-------------------
- (IBAction)bingCardAction:(id)sender {
    if ([self.codeView.text isEqualToString:@""]) {
        [MCToast showMessage:@"请填写正确的验证码"];
        return;
    }
    kWeakSelf(self);
    //收款 目前只有统统付和电银
    if ([self.extendModel.whereCome isEqualToString:shoukuan_jianquan]) {
        [self shoukuan_jianquan_Bind];
    }
    //空卡还款 只有聚合空卡
    if ([self.extendModel.whereCome isEqualToString:kongkahuankuan_jianquan]) {
        [self kongkahuankuan_jianquan_Bind];
    }
    //余额还款
    if ([self.extendModel.whereCome isEqualToString:yuehuankuan_jianquan]) {
        [self yuehuankuan_jianquan_Bind];
    }
}
#pragma mark ---------------①最后绑定,收款界面进来-------------------
-(void)shoukuan_jianquan_Bind{
    kWeakSelf(self);
    //统统付
    if (!self.bindUrl) {
        [MCToast showMessage:@"请获取验证码"];
        return;
    }
    NSMutableDictionary * dic = [MCSessionManager dictionaryWithUrlString:self.bindUrl];
    NSString * requestUrl = [self.bindUrl split:@"?"][0];
    [dic setValue:self.codeView.text forKey:@"smsCode"];
    [[MCSessionManager shareManager] mc_POST:requestUrl parameters:dic ok:^(MCNetResponse * _Nonnull okResponse) {
        //拼凑的model
        MCCustomModel * customModel = [[MCCustomModel alloc]init];
        [customModel setValue:okResponse.result forKey:@"api"];
        [customModel setValue:shoukuan_jianquan forKey:@"whereCome"];//收款界面
        [customModel setValue:self.extendModel.bindChannelName forKey:@"bindChannelName"];//通道
        
        [MCPagingStore pagingURL:rt_card_jiaoyi withUerinfo:@{@"param":weakself.cardModel,@"extend":customModel}];
    }];
}
#pragma mark ---------------②最后绑定,空卡还款界面进来-------------------
-(void)kongkahuankuan_jianquan_Bind{
    kWeakSelf(self);
    //聚合空卡
    if ([self.extendModel.bindChannelName isEqualToString:TYDE_8920_QUICK] ||
        [self.extendModel.bindChannelName isEqualToString:DFPay_QUICK]) {
        kWeakSelf(self);
        NSDictionary * dic = @{@"bankCard":self.cardModel.cardNo,
                               @"idCard":self.cardModel.idcard,
                               @"phone":self.cardModel.phone,
                               @"userName":self.cardModel.userName,
                               @"bankName":self.cardModel.bankName,
                               
                               @"expiredTime":self.cardModel.expiredTime,
                               @"securityCode":self.cardModel.securityCode,
                               @"channelTag":self.cardModel.channelTag,
                               @"rate":self.cardModel.rate,
                               @"extraFee":self.cardModel.extraFee,

                               @"dbankCard":self.cardModel.dbankCard,
                               @"dbankName":self.cardModel.dbankName,
                               @"dphone":self.cardModel.dphone,
                               @"userId":SharedUserInfo.userid,
                               @"smsCode":self.codeView.text
        };
        [[MCSessionManager shareManager] mc_POST:self.extendModel.api parameters:dic ok:^(MCNetResponse * _Nonnull okResponse) {
            //如果是空卡鉴权成功之后再跳转对应的列表界面
            [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/empty/card/plan/save" parameters:self.extendModel.kongKa_Save_Parameters ok:^(MCNetResponse * _Nonnull resp) {
                //跳转空卡还款列表界面
                [weakself saveSuccessJumpVC:resp];
            } other:^(MCNetResponse * _Nonnull resp) {
                [MCLoading hidden];
                [weakself saveSuccessJumpVC:resp];
            } failure:^(NSError * _Nonnull error) {
                [MCLoading hidden];
            }];
        }];
    }
}
#pragma mark ---------------③最后绑定,余额还款界面进来-------------------
-(void)yuehuankuan_jianquan_Bind{
    //余额界面进来，公用一个绑卡的方法，改掉了之前分开的，我了增加通道，前端不用改变
    [self bindCommonAction];
}
-(void)bindCommonAction{
    kWeakSelf(self);
    NSDictionary * dic = @{@"bankCard":self.cardModel.cardNo,
                           @"idCard":self.cardModel.idcard,
                           @"phone":self.cardModel.phone,
                           @"userName":self.cardModel.userName,
                           @"bankName":self.cardModel.bankName,
                           
                           @"expiredTime":self.cardModel.expiredTime,
                           @"securityCode":self.cardModel.securityCode,
                           @"channelTag":self.cardModel.channelTag,
                           @"smsCode":self.codeView.text,
                           @"userId":SharedUserInfo.userid,
    };
    //绑定
    [[MCSessionManager shareManager] mc_POST:self.extendModel.api parameters:dic ok:^(MCNetResponse * _Nonnull okResponse) {
        //再次查询鉴权
        [weakself.sessionManager mc_POST:@"/creditcardmanager/app/balance/verify/band/card" parameters:weakself.extendModel.xinYongKa_Save_Parameters ok:^(MCNetResponse * _Nonnull resp) {
            //保存计划
            [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/balance/plan/save" parameters:weakself.extendModel.xinYongKa_Save_Parameters ok:^(MCNetResponse * _Nonnull resp) {
                [MCLoading hidden];
                [KDBindChannelManager sharedConfig].creditCardNumber = weakself.cardModel.cardNo;
                [KDBindChannelManager sharedConfig].channelTag = weakself.cardModel.channelTag;
                //查询多通道
                [[KDBindChannelManager sharedConfig] getAllXinYongKaList];
            }];
        } other:^(MCNetResponse * _Nonnull resp) {
            //需要鉴权
            if ([resp.code isEqualToString:@"999992"]) {
                MCBankCardModel * cardModel = [[MCBankCardModel alloc]init];
                cardModel.cardNo = resp.result[@"bankCard"];
                cardModel.bankName = resp.result[@"bankName"];
                cardModel.channelTag = resp.result[@"channelTag"];
                cardModel.expiredTime = resp.result[@"expiredTime"];
                cardModel.idcard = resp.result[@"idCard"];
                
                cardModel.phone = resp.result[@"phone"];
                cardModel.securityCode = resp.result[@"securityCode"];
                cardModel.userName = resp.result[@"userName"];
                cardModel.rate = resp.result[@"rate"];
                cardModel.extraFee = resp.result[@"extraFee"];

                cardModel.dbankCard = resp.result[@"dbankCard"];
                cardModel.dbankName = resp.result[@"dbankName"];
                cardModel.dphone    = resp.result[@"dphone"];
                //拼凑的model
                MCCustomModel * customModel = [[MCCustomModel alloc]init];
                customModel.bindChannelName = resp.result[@"channelTag"];
                customModel.whereCome = yuehuankuan_jianquan;
                customModel.smsApi = [resp.result[@"ipAddress"] append:resp.result[@"getSmsUrlNew"]];
                customModel.api    = [resp.result[@"ipAddress"] append:resp.result[@"confirmSmsUrl"]];
                customModel.xinYongKa_Save_Parameters = self.extendModel.xinYongKa_Save_Parameters;
                [MCPagingStore pagingURL:rt_card_jianquan withUerinfo:@{@"param":cardModel,@"extend":customModel}];
            }else{
                [MCToast showMessage:resp.messege];
            }
            [MCLoading hidden];
        }];

    }other:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"999999"] && [resp.messege isEqualToString:@"已绑卡成功,请返回首页重新下单"]){
            //保存计划
            [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/balance/plan/save" parameters:weakself.extendModel.xinYongKa_Save_Parameters ok:^(MCNetResponse * _Nonnull resp) {
                [MCLoading hidden];
                [KDBindChannelManager sharedConfig].creditCardNumber = weakself.cardModel.cardNo;
                [KDBindChannelManager sharedConfig].channelTag = weakself.cardModel.channelTag;
                //查询多通道
                [[KDBindChannelManager sharedConfig] getAllXinYongKaList];
            }];
        }else{
            [MCToast showMessage:resp.messege];
        }
        
    }];
}


#pragma mark ---------------获取上一个界面的参数，不常用-------------------
- (instancetype)initWithClassification:(MCBankCardModel *)cardModel extend:(MCCustomModel *)extendModel{
    self = [super init];
    if (self) {
        self.cardModel   = cardModel;
        self.extendModel = extendModel;
    }
    return self;
}

#pragma mark ---------------空卡鉴权成功后，跳转空卡列表界面,信用卡鉴权成功，要查询是否有其它通道可绑定 111-------------------
-(void)jumpKongKaListVC:(MCNetResponse *)resp{
        kWeakSelf(self);

}

#pragma mark ---------------信用卡和空卡鉴权成功，跳转到相对应列表界面 333-------------------
-(void)saveSuccessJumpVC:(MCNetResponse *)resp{
    //这里是确认收款后，跳转收款界面，多做了一个判断防止闪退
    if ([[self.navigationController viewControllers] count] > 1) {
        [self.navigationController popToViewController:[self.navigationController viewControllers][1] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MCToast showMessage:resp.messege];
    });
}


-(void)showGuidePage{
    //空白的frame
    CGRect emptyRect = CGRectMake(0, 40+kTopHeight,KScreenWidth, 380);
    //图片的frame
    CGRect imgRect = CGRectMake(50,40+kTopHeight+380,kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeXinYongKaShouKuan emptyRect:emptyRect imgRect:imgRect imgStr:@"guide6" completion:^{}];
}
@end
