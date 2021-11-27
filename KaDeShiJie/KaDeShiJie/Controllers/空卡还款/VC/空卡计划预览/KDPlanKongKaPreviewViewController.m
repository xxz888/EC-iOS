//
//  KDPlanKongKaPreviewViewController.m
//  KaDeShiJie
//
//  Created by apple on 2020/12/1.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanKongKaPreviewViewController.h"
#import "KDDirectRefundViewController.h"
#import "KDCommonAlert.h"
#import "KDKongKaViewController.h"
@interface KDPlanKongKaPreviewViewController ()<UITableViewDataSource, KDPlanPreviewViewDelegate, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * previewArray;//下单进来，带过来数据筛选的数组
@end
@implementation KDPlanKongKaPreviewViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 1 下单 2 历史记录 3 信用卡还款进来  下单进来直接带的数据，其余进来是请求的数据
    self.whereCome == 1 ? [self setDataWhere1] : [self setDataWhere1Where2or3];
}
-(void)setUI{
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH - 20,90);
    gl.startPoint = CGPointMake(1, 0.5);
    gl.endPoint = CGPointMake(0, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:254/255.0 green:69/255.0 blue:87/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:253/255.0 green:109/255.0 blue:92/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.topView.layer.cornerRadius = 12;
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 8;
    [self.topView.layer insertSublayer:gl atIndex:0];

    self.topBgView.layer.cornerRadius = 12;
    self.bottomBtn.titleLabel.font = [UIFont qmui_systemFontOfSize:16 weight:QMUIFontWeightBold italic:NO];
    self.bottomBtn.layer.cornerRadius = 25;
    self.bottomBtn.layer.masksToBounds = YES;
    self.centerView.layer.cornerRadius = 12;
    
    self.bottomBtn2.titleLabel.font = [UIFont qmui_systemFontOfSize:16 weight:QMUIFontWeightBold italic:NO];
    self.bottomBtn2.layer.cornerRadius = 25;
    self.bottomBtn2.layer.masksToBounds = YES;
    
    // 1 下单 2 历史记录 3 信用卡还款进来
    [self setNavigationBarTitle:self.whereCome == 1 ? @"空卡计划预览" :
                                self.whereCome == 2 ? @"空卡计划详情":
                                                      @"空卡计划详情" tintColor:UIColor.whiteColor];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
}
#pragma mark -------------------------where=1,下单进来直接带过来数据-------------------------
- (void)setDataWhere1{
    self.titleStatusLblTag.hidden =   YES;

    // 1 下单 2 历史记录 3 信用卡还款进来
    if (self.whereCome == 1) {
        self.bottomBtn.hidden = NO;
        self.bottomBtn2.hidden = YES;//空卡状态为4 新加的按钮
        [self.bottomBtn setTitle:@"启动计划" forState:UIControlStateNormal];
        self.statusLabelWidth.constant = 15;
        self.titleStatusLblTag.hidden = YES;
        
        self.previewArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in self.startDic[@"emptyCardPlanItemList"]) {
            if ([dic[@"type"] integerValue] != 2) {
                [self.previewArray addObject:dic];
            }
        }
        [self.tableView reloadData];
    }else if(self.whereCome == 2 || self.whereCome == 3){
//空卡还款计划状态（字段：status）：
//        1：初始状态
//        2：审核通过
//        3：运行中状态
//        4：暂停状态（普通暂停）
//        5：严重暂停（由于消费失败而产生的暂停）
//        6：完成状态
//        7：停止状态（用户点取消，还未退还手续费时的状态）
//        8：取消状态（用户点取消，退还手续费后的状态）
        NSInteger status = [self.startDic[@"status"] integerValue];

        if (status == 4) {
            [self.bottomBtn setTitle:@"重启计划" forState:UIControlStateNormal];
            [self.bottomBtn2 setTitle:@"终止计划" forState:UIControlStateNormal];
            self.bottomBtn2.hidden = NO;
            self.bottomBtn.hidden = NO;
            self.bottomHeight.constant = 50;
        }else if (status == 5) {
            [self.bottomBtn setTitle:@"重启计划" forState:UIControlStateNormal];
            self.bottomBtn.hidden = NO;
            self.bottomBtn2.hidden = YES;

            self.bottomHeight.constant = 50;
        }else if(status == 1 || status == 2 || status == 3){
            [self.bottomBtn setTitle:@"终止计划" forState:UIControlStateNormal];
            self.bottomBtn.hidden = NO;
            self.bottomBtn2.hidden = YES;
            self.bottomHeight.constant = 50;

        }else{
            self.bottomBtn2.hidden = YES;
            self.bottomBtn.hidden = YES;
            self.bottomHeight.constant = 0;

        }
        self.statusLabelWidth.constant = 60;
        self.titleStatusLblTag.hidden =  NO;
    }else{
        self.statusLabelWidth.constant = 60;
        self.titleStatusLblTag.hidden =  NO;
    }
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:self.directModel.bankName];
    self.iconView.image = info.logo;
    self.topView.backgroundColor = [info.cardCellBackgroundColor qmui_colorWithAlphaAddedToWhite:0.6];
    NSString *cardNo = [NSString stringWithFormat:@"(%@)", [self.directModel.cardNo substringFromIndex:[self.directModel.cardNo length] - 4]];
    NSString *desStr = [NSString stringWithFormat:@"%@%@", self.directModel.bankName, cardNo];
    NSRange range = [desStr rangeOfString:cardNo];
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:desStr];
    [atts addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    self.nameLabel.attributedText = atts;
    self.desLabel.text = [NSString stringWithFormat:@"账单日 每月%ld日｜还款日 每月%ld日", self.directModel.billDay, self.directModel.repaymentDay];
    //还款总次数
    self.lab1.text = [NSIntegerToNSString([self.startDic[@"taskCount"] integerValue]) append:@"次"];
    //还款总金额
    self.lab3.text = [doubleToNSString([self.startDic[@"taskAmount"] doubleValue]) append:@"元"];
    //已还金额
    if (self.whereCome == 1) {
        self.lab4.text = @"0.00元";
    }else{
        self.lab4.text = [doubleToNSString([self.startDic[@"repaymentedAmount"] doubleValue]) append:@"元"];
    }
    //预计手续费
    self.lab5.text = [doubleToNSString([self.startDic[@"totalServiceCharge"] doubleValue]) append:@"元"];
}
#pragma mark -------------------------where=2或者3,请求数据-------------------------
- (void)setDataWhere1Where2or3{
    kWeakSelf(self);
    [self.sessionManager mc_POST:@"/creditcardmanager/app/empty/card/plan/get" parameters:@{@"planId":self.directModel.hasWaitingEmptyOrder} ok:^(MCNetResponse * _Nonnull resp) {
        weakself.previewArray = [[NSMutableArray alloc]init];
        weakself.startDic = [[NSMutableDictionary alloc]init];
        [weakself.startDic setValue:resp.result[@"taskCount"] forKey:@"taskCount"];
        [weakself.startDic setValue:resp.result[@"taskAmount"] forKey:@"taskAmount"];
        [weakself.startDic setValue:resp.result[@"totalServiceCharge"] forKey:@"totalServiceCharge"];
        [weakself.startDic setValue:resp.result[@"repaymentedAmount"] forKey:@"repaymentedAmount"];
        [weakself.startDic setValue:resp.result[@"status"] forKey:@"status"];
        [weakself setDataWhere1];
        for (NSDictionary * dic in resp.result[@"emptyCardPlanItemList"]) {
            if ([dic[@"type"] integerValue] != 2) {
                [weakself.previewArray addObject:dic];
            }
        }
        [weakself.tableView reloadData];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.previewArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KDPlanKongKaPreviewCell *cell = [KDPlanKongKaPreviewCell cellWithTableView:tableView];
    cell.whereCome = self.whereCome;
    [cell setOrderStartDic:self.previewArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.previewArray[indexPath.row][@"status"] integerValue] == 4) {
        [self.sessionManager mc_POST:@"/creditcardmanager/app/empty/card/plan/error/message" parameters:@{@"planItemId":self.previewArray[indexPath.row][@"id"]} ok:^(MCNetResponse * _Nonnull resp) {
            KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
            [commonAlert initKDCommonAlertContent:resp.messege isShowClose:YES];
        }];
    }
 
    
//    KDConsumptionDetailView *detailView = [[KDConsumptionDetailView alloc] init];
//    detailView.orderModel = self.previewArray[indexPath.row];
//    [detailView showView];

}
#pragma mark -------------------------底部按钮方法-------------------------
- (IBAction)clickBottomAction:(KDFillButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"启动计划"]) {
        [self creditcardSaveTask1];
    }
    if ([sender.titleLabel.text isEqualToString:@"终止计划"]) {
        [self creditcardStopTask1];
    }
    if ([sender.titleLabel.text isEqualToString:@"重启计划"]) {
        [self creditcardAgainTask1];
    }
}
#pragma mark -------------------------空卡启动计划先弹出弹框第一步1-------------------------
-(void)creditcardSaveTask1{
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    NSString * string = [NSString stringWithFormat:@"空卡计划设置后，系统将首次扣除手续费%.2f元，同时在卡内多预留25元空间的余额，便于系统验卡。为避免逾期，请检查卡片是否有限额、超限、分期利息未扣除等异常状态，感谢您的支持与配合，祝您生活愉快！",[self.startDic[@"totalServiceCharge"] doubleValue]];
    [commonAlert initKDCommonAlertContent:string isShowClose:NO];
    //点击确认按钮
    kWeakSelf(self);
    commonAlert.rightActionBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself creditcardSaveTask2];
        });
    };
}
#pragma mark -------------------------空卡启动计划查看是否鉴权，没有鉴权直接跳转鉴权界面第二步2-------------------------
-(void)creditcardSaveTask2{
    
    //判断是否鉴权
    kWeakSelf(self);
    NSDictionary * dic = @{@"userId":SharedUserInfo.userid,@"creditCardNumber":self.startDic[@"creditCardNumber"],@"version":self.version};
    [MCSessionManager.shareManager mc_POST:@"/creditcardmanager/app/empty/card/verify/card" parameters:dic ok:^(MCNetResponse * _Nonnull resp) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:SharedUserInfo.userid forKey:@"userId"];
        [params setValue:weakself.startDic[@"creditCardNumber"] forKey:@"creditCardNumber"];
        
        
        [self.sessionManager mc_POST:@"/creditcardmanager/app/empty/card/plan/save" parameters:self.startDic ok:^(MCNetResponse * _Nonnull resp) {
            KDKongKaViewController * directRefundVC = nil;
            for (UIViewController * vc in [self.navigationController viewControllers]) {
                if ([vc isKindOfClass:[KDKongKaViewController class]]) {
                    directRefundVC = (KDKongKaViewController *)vc;
                }
            }
            //返回
            if (directRefundVC) {
                [weakself.navigationController popToViewController:directRefundVC animated:YES];
            }else{
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MCToast showMessage:resp.messege];
            });
        } other:^(MCNetResponse * _Nonnull resp) {
            
        }];
    } other:^(MCNetResponse * _Nonnull resp) {
         //"resp_message": "需要鉴权绑卡!", "resp_code": "999992"
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
             customModel.whereCome = kongkahuankuan_jianquan;
             customModel.smsApi = [resp.result[@"ipAddress"] append:resp.result[@"getSmsUrlNew"]];
             customModel.api    = [resp.result[@"ipAddress"] append:resp.result[@"confirmSmsUrl"]];
             customModel.kongKa_Save_Parameters = [NSDictionary dictionaryWithDictionary:dic];
             [MCPagingStore pagingURL:rt_card_jianquan withUerinfo:@{@"param":cardModel,@"extend":customModel}];
         }
    }];
    
    
    

}


#pragma mark -------------------------空卡终止计划第一步1-------------------------
-(void)creditcardStopTask1{
    kWeakSelf(self);
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    
    NSString * string = @"点'确定'删除后将不再执行'待执行'计划,如需执行请重新安排。";
    [commonAlert initKDCommonAlertContent:string isShowClose:NO];
    //点击确认按钮
    commonAlert.rightActionBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself creditcardStopTask2];
        });
    };
    

    
}
#pragma mark -------------------------空卡终止计划第一步2-------------------------
-(void)creditcardStopTask2{
    kWeakSelf(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [params setValue:self.directModel.hasWaitingEmptyOrder forKey:@"planId"];
    [self.sessionManager mc_POST:@"/creditcardmanager/app/empty/card/plan/stop" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        [weakself.navigationController popViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCToast showMessage:resp.messege];
        });
    }];
}
#pragma mark -------------------------重启计划第一步1-------------------------
-(void)creditcardAgainTask1{
    
    kWeakSelf(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [params setValue:self.directModel.hasWaitingEmptyOrder forKey:@"planId"];
    [self.sessionManager mc_POST:@"/creditcardmanager/app/empty/card/plan/reRun" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        [weakself.navigationController popViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCToast showMessage:resp.messege];
        });
    }];
}
#pragma mark - KDPlanPreviewViewDelegate
- (void)planPreviewViewWithType:(NSInteger)type{}

@end
