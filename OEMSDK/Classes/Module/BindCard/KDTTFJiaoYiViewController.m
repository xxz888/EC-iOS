//
//  KDTTFJiaoYiViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/12.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDTTFJiaoYiViewController.h"
#import "KDCommonAlert.h"
#import "LoginAndRegistHTTPTools.h"
#import "BRStringPickerView.h"
#import "KDCommonAlert.h"
#import "MCDateStore.h"

@interface KDTTFJiaoYiViewController ()
@property (nonatomic, strong) MCCustomModel   * lastParamsExtendModel;
@property (nonatomic, strong) BRStringPickerView *pickView1;
@property (nonatomic, strong) BRStringPickerView *pickView2;
@property (nonatomic, strong) NSTimer * timer;
@end
@implementation KDTTFJiaoYiViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.provinceCode = nil;
    self.incitycode = nil;
    [self setNavigationBarTitle:@"支付确认" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    self.nameLabel.text = self.cardModel.userName;
    self.cardNoLabel.text = self.cardModel.cardNo;
    self.validityLabel.text = self.cardModel.expiredTime;
    self.safeCodeLabel.text = self.cardModel.securityCode;
    self.shengLbl.textColor = [UIColor qmui_colorWithHexString:@"#B4B4B4"];
    self.shiLbl.textColor = [UIColor qmui_colorWithHexString:@"#B4B4B4"];
    self.shanghuLbl.textColor = [UIColor qmui_colorWithHexString:@"#B4B4B4"];

    //选择省
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectShengView:)];
    [self.shengView addGestureRecognizer:tap1];
    //选择市
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectShiView:)];
    [self.shiView addGestureRecognizer:tap2];
    //选择商户
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectShangHuView:)];
    [self.shanghuView addGestureRecognizer:tap3];
    
    
    //如果是工易付收款进来
    if ([self.extendModel.bindChannelName isEqualToString:GYFPay_KJ_QUICK] || [self.extendModel.bindChannelName isEqualToString:BJFFPay_KJ_QUICK]) {
        self.stackViewHeight.constant = 318;
        self.yanzhengmaView.hidden = YES;
    }else{
        self.stackViewHeight.constant = 370;
        self.yanzhengmaView.hidden = NO;
    }
    [self showGuidePage];
    

    
}
#pragma mark ---------------选择省-------------------
-(void)selectShengView:(id)sender{
    __weak typeof(self) weakSelf = self;
    static NSTimeInterval time = 0;
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    //限制用户点击按钮的时间间隔大于1秒钟
        if (currentTime - time > 1) {
        //处理逻辑/v1.0/paymentgateway/verification/getcitycode
            NSString * provinceUrl =  @"/paymentgateway/verification/getcitycode" ;
            NSDictionary * dic = @{@"type":@"1",@"channelTag":self.extendModel.bindChannelName};
            [MCSessionManager.shareManager mc_POST:provinceUrl parameters:dic ok:^(MCNetResponse * _Nonnull resp) {
                NSArray * resultArray = resp.result;
                NSMutableArray * resultShengArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in resp.result) {
                    [resultShengArray addObject:dic[@"cityName"]];
                }
                if (resultShengArray.count == 0) {
                    return;
                }
                if (!weakSelf.pickView1) {
                    weakSelf.pickView1 = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
                }
                weakSelf.pickView1.dataSourceArr = [NSArray arrayWithArray:resultShengArray];
                weakSelf.pickView1.selectValue = resultShengArray[0];
                [weakSelf.pickView1 show];
                weakSelf.pickView1.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
                    weakSelf.shengLbl.text = resultModel.value;
                    weakSelf.shengLbl.textColor = [UIColor blackColor];
                    weakSelf.shiLbl.textColor = [UIColor qmui_colorWithHexString:@"#B4B4B4"];
                    weakSelf.shiLbl.text = @"请选择城市";
                    for (NSDictionary * dic in resp.result) {
                        if ([resultModel.value isEqualToString:dic[@"cityName"]]) {
                            weakSelf.provinceCode = dic[@"cityCode"];
                        };
                    }
                };
            } other:^(MCNetResponse * _Nonnull resp) {
                [MCLoading hidden];
                [MCToast showMessage:resp.messege];
            }];
        }
    time = currentTime;
    
    
      
}
#pragma mark ---------------选择市-------------------
-(void)selectShiView:(id)sender{
    if ([self.shengLbl.text isEqualToString:@"请选择省份"] || !self.provinceCode) {
        [MCToast showMessage:@"请选择省份"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    static NSTimeInterval time = 0;
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    //限制用户点击按钮的时间间隔大于1秒钟
        if (currentTime - time > 1) {
            NSString * provinceUrl =  @"/paymentgateway/verification/getcitycode" ;
            NSDictionary * dic = @{@"type":@"2",@"channelTag":self.extendModel.bindChannelName,@"provinceCode":self.provinceCode};
            [MCSessionManager.shareManager mc_POST:provinceUrl parameters:dic ok:^(MCNetResponse * _Nonnull resp) {
                NSArray * resultArray = resp.result;
                NSMutableArray * resultShengArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in resp.result) {
                    [resultShengArray addObject:dic[@"cityName"]];
                }
                if (resultShengArray.count == 0) {
                    return;
                }
                if (!weakSelf.pickView2) {
                    weakSelf.pickView2 = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
                }
                weakSelf.pickView2.dataSourceArr = [NSArray arrayWithArray:resultShengArray];
                weakSelf.pickView2.selectValue = resultShengArray[0];
                [weakSelf.pickView2 show];
                __weak typeof(self) weakSelf = self;
                weakSelf.pickView2.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
                    weakSelf.shiLbl.text = resultModel.value;
                    weakSelf.shiLbl.textColor = [UIColor blackColor];
                    for (NSDictionary * dic in resp.result) {
                        if ([resultModel.value isEqualToString:dic[@"cityName"]]) {
                            weakSelf.incitycode = dic[@"cityCode"];
                        }
                    }
                };
            } other:^(MCNetResponse * _Nonnull resp) {
                [MCLoading hidden];
                [MCToast showMessage:resp.messege];
            }];
        }
    time = currentTime;
   
}
#pragma mark ---------------发送验证码-------------------
- (IBAction)codeAction:(id)sender {
    if ([self.shengLbl.text isEqualToString:@"请选择省份"] || !self.provinceCode) {
        [MCToast showMessage:@"请选择省份"];
        return;
    }
    if ([self.shiLbl.text isEqualToString:@"请选择城市"] || !self.incitycode) {
        [MCToast showMessage:@"请选择城市"];
        return;
    }
    NSMutableDictionary * dicParams = [MCSessionManager dictionaryWithUrlString:self.extendModel.api];
    NSString * url = [self.extendModel.api split:@"?"][0];
    [dicParams setValue:self.provinceCode forKey:@"provinceCode"];
    [dicParams setValue:self.incitycode forKey:@"city"];
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_POST:url parameters:dicParams ok:^(MCNetResponse * _Nonnull resp) {
        //拼凑的model
        [weakSelf changeSendBtnText:weakSelf.codeBtn];
        weakSelf.lastParamsExtendModel = [[MCCustomModel alloc]init];
        [weakSelf.lastParamsExtendModel setValue:resp.result forKey:@"api"];
        
        
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        //统统付的返回999998,跳转短信界面,等待银行出款中！
        if ([resp.code isEqualToString:@"999998"]) {
            [weakSelf changeSendBtnText:weakSelf.codeBtn];
            //拼凑的model
            weakSelf.lastParamsExtendModel = [[MCCustomModel alloc]init];
            [weakSelf.lastParamsExtendModel setValue:url forKey:@"smsApi"];
            [weakSelf.lastParamsExtendModel setValue:dicParams forKey:@"smsParameters"];
            [weakSelf.lastParamsExtendModel setValue:resp.result forKey:@"api"];
            
        }else{
            //失败处理
            [MCToast showMessage:resp.messege];
        }

    } failure:^(NSError * _Nonnull error) {
        //失败处理
//        [MCToast showMessage:@"网络请求失败"];
        [MCLoading hidden];
    }];
    
}
#pragma mark ---------------最后调用下单接口，最后一步,统统付的短信界面-------------------
- (IBAction)payBtnAction:(UIButton *)sender {
    kWeakSelf(self);
    NSMutableDictionary * dic = @{};
    NSString * requestUrl = @"";
    if ([self.extendModel.bindChannelName isEqualToString:GYFPay_KJ_QUICK] || [self.extendModel.bindChannelName isEqualToString:BJFFPay_KJ_QUICK]) {
        dic = [MCSessionManager dictionaryWithUrlString:self.extendModel.api];
        if ([[self.extendModel.api split:@"?"] count] > 0 ) {
            requestUrl = [self.extendModel.api split:@"?"][0];
        }else{
            [MCToast showMessage:@"请获取验证码"];
            return;
        }
        
        if (!requestUrl) {
            [MCToast showMessage:@"请获取验证码"];
            return;
        }
        [dic setValue:self.incitycode forKey:@"cityCode"];
    }else{
        dic = [MCSessionManager dictionaryWithUrlString:self.lastParamsExtendModel.api];
        
        if ([[self.lastParamsExtendModel.api split:@"?"] count] > 0 ) {
            requestUrl = [self.lastParamsExtendModel.api split:@"?"][0];
        }else{
            [MCToast showMessage:@"请获取验证码"];
            return;
        }
      
        if (!requestUrl) {
            [MCToast showMessage:@"请获取验证码"];
            return;
        }
        if ([self.codeView.text isEqualToString:@""]) {
            [MCToast showMessage:@"请填写正确的验证码"];
            return;
        }
        [dic setValue:self.codeView.text forKey:@"smsMsg"];
    }

    [[MCSessionManager shareManager] mc_POST:requestUrl parameters:dic ok:^(MCNetResponse * _Nonnull okResponse) {
        [weakself commonAction];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        if ([resp.code isEqualToString:@"999998"]) {
            //计时器开启，每隔1秒查询一次结果，如果查询成功
            [weakself fiveSecondTimerSearch:resp.result];
        }else{
            //失败处理
            [MCToast showMessage:resp.messege];
        }

    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
        //失败处理
        [MCToast showMessage:@"网络请求失败"];
    }];
}
#pragma mark ---------------获取上一个界面的参数，不常用-------------------
- (instancetype)initWithClassification:(MCBankCardModel *)cardModel extend:(MCCustomModel *)extendModel{
    self = [super init];
    if (self) {
        self.cardModel      = cardModel;
        self.extendModel    = extendModel;
    }
    return self;
}
- (void)dealloc{
    [_timer invalidate];
}

-(void)commonAction{
    if (_timer) {
        [_timer invalidate];
    }
    kWeakSelf(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [params setValue:BCFI.brand_id forKey:@"brandId"];
    [params setValue:[MCDateStore getYear] forKey:@"year"];
    [params setValue:[MCDateStore getMonth] forKey:@"month"];

    [self.sessionManager mc_POST:@"/transactionclear/app/add/querypaybycard/make/information" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.result[@"content"] count] == 0) {
            //这里是确认收款后，跳转收款界面，多做了一个判断防止闪退
            if ([[weakself.navigationController viewControllers] count] > 1) {
                [weakself.navigationController popToViewController:[weakself.navigationController viewControllers][1] animated:YES];
            }else{
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            
            [MCPagingStore pagingURL:rt_card_shoukuanxiangqing withUerinfo:@{@"param":resp.result[@"content"][0]}];
        }
    }];
}
//计时器开启，每隔1秒查询一次结果，如果查询成功
-(void)fiveSecondTimerSearch:(NSString *)url{
    kWeakSelf(self);
    __block NSInteger count = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        count++;
        if (count > 4) {
            [weakself commonAction];
        }else{
            [weakself request999998:url];
        }
    }];
}
-(void)request999998:(NSString *)url{
    kWeakSelf(self);
    NSMutableDictionary * dic = [MCSessionManager dictionaryWithUrlString:url];
    NSString * requestUrl = [url split:@"?"][0];
    [[MCSessionManager shareManager] mc_POST:requestUrl parameters:dic ok:^(MCNetResponse * _Nonnull okResponse) {
        [weakself commonAction];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        
        [MCLoading hidden];
        [MCToast showMessage:@"网络请求失败"];
    }];
}
-(void)showGuidePage{
    //空白的frame
    CGRect emptyRect = CGRectMake(0, 40+kTopHeight,KScreenWidth, 380);
    //图片的frame
    CGRect imgRect = CGRectMake(50,40+kTopHeight+380,kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeXinYongKaShouKuan emptyRect:emptyRect imgRect:imgRect imgStr:@"guide7" completion:^{}];
}
@end
