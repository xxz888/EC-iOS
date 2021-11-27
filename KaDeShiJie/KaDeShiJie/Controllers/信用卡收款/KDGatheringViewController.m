//
//  KDGatheringViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDGatheringViewController.h"
#import "KDSlotCardAisleViewController.h"
#import "KDCommonAlert.h"

@interface KDGatheringViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet QMUIButton *addCreditBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *addDepositBtn;
@property (weak, nonatomic) IBOutlet UIImageView *creditImg;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UIImageView *depositImg;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *gatherBtn;
@property (weak, nonatomic) IBOutlet UIView *keyboardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardBottomCons;
@property (weak, nonatomic) IBOutlet UITextField *moneyView;
@property(nonatomic, strong) MCBankCardModel *xinyongInfo;
@property(nonatomic, strong) MCBankCardModel *chuxuInfo;
@property(nonatomic, strong) KDCommonAlert * commonAlert;


@end

@implementation KDGatheringViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardVCBack:) name:@"mcNotificationWebContainnerReset" object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.moneyView.text = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;

    //显示光标，但隐藏键盘
    [self.moneyView becomeFirstResponder];
    self.moneyView.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.moneyView.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.moneyView reloadInputViews];
    UITextInputAssistantItem* item = [self.moneyView inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
    
    self.moneyView.delegate = self;
    // 设置按钮显示
    self.addCreditBtn.imagePosition = QMUIButtonImagePositionRight;
    self.addDepositBtn.imagePosition = QMUIButtonImagePositionRight;
    self.gatherBtn.titleLabel.numberOfLines = 0;
    
    // 设置topView
    self.topView.layer.cornerRadius = 17;
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 10;
    
    [self setNavigationBarTitle:@"信用卡收款" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"使用说明" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];

    [self requestDefaultChuXuCards];


    
}
#pragma mark - 获取默认卡
- (void)requestDefaultChuXuCards {
    
    __weak __typeof(self)weakSelf = self;
    //默认储蓄卡
    NSDictionary *p2 = @{@"userId":SharedUserInfo.userid,
                         @"type":@"2",
                         @"nature":@"2",
                         @"isDefault":@"1"};
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:p2 ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temp = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (MCBankCardModel *model in temp) {
            weakSelf.chuxuInfo = model;
            break;
        }
        [weakSelf setChuxuInfo:weakSelf.chuxuInfo];
        //绑定过储蓄卡的话，就看是否绑定过信用卡
        [weakSelf requestDefaultXinYongCards];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        if ([resp.code isEqualToString:@"666666"]) {
            [weakSelf nocardAlertShowWithMessage:@"你还未添加到账提现卡(储蓄卡)，是否前往添加？" type:MCBankCardTypeChuxuka cardModel:nil];
            [weakSelf showChuXuGuidePage];
        } else {
            [MCToast showMessage:resp.messege];
        }
    }];

}
- (void)requestDefaultXinYongCards {
    __weak __typeof(self)weakSelf = self;
    //默认信用卡
    NSDictionary *p1 = @{@"userId":SharedUserInfo.userid,
                         @"type":@"0",
                         @"nature":@"0",
                         @"isDefault":@"1"};
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:p1 ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temp = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        
        for (MCBankCardModel *model in temp) {
            if (!model.billDay || !model.repaymentDay) {
                [weakSelf nocardAlertShowWithMessage:@"您的信用卡信息填写不完整，请补充完整" type:MCBankCardTypeXinyongka cardModel:model];
            } else {
                [weakSelf showGuidePage2];

            }
            weakSelf.xinyongInfo = model;

            break;
        }
        [weakSelf setXinyongInfo:weakSelf.xinyongInfo];

    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        if ([resp.code isEqualToString:@"666666"]) {
            [weakSelf nocardAlertShowWithMessage:@"你还未添加收款充值卡(信用卡)，是否前往添加？" type:MCBankCardTypeXinyongka cardModel:nil];
            weakSelf.xinyongInfo = nil;
            [weakSelf showXinYongGuidePage];
        } else {
            [MCToast showMessage:resp.messege];
        }
    }];
}
-(void)showChuXuGuidePage{
    CGPoint point = [self.commonAlert.rightBtn convertPoint:CGPointMake(0,0) toView:[UIApplication sharedApplication].windows.lastObject];
    //空白的frame
    CGRect emptyRect = CGRectMake(point.x, point.y,self.commonAlert.rightBtn.width_sd, self.commonAlert.rightBtn.height_sd);
    //图片的frame
    CGRect imgRect = CGRectMake(point.x-self.commonAlert.rightBtn.width_sd, point.y+self.commonAlert.rightBtn.height_sd, kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeXinYongKaShouKuan emptyRect:emptyRect imgRect:imgRect imgStr:@"guide10" completion:^{
        [weakself.commonAlert.qmuiAlter hideWithAnimated:YES completion:^(BOOL finished) {
            [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(MCBankCardTypeChuxuka), @"isLogin":@(NO),@"whereCome":@"1"}];
        }];


    }];
}
-(void)showXinYongGuidePage{
    CGPoint point = [self.commonAlert.rightBtn convertPoint:CGPointMake(0,0) toView:[UIApplication sharedApplication].windows.lastObject];
    //空白的frame
    CGRect emptyRect = CGRectMake(point.x, point.y,self.commonAlert.rightBtn.width_sd, self.commonAlert.rightBtn.height_sd);
    //图片的frame
    CGRect imgRect = CGRectMake(point.x-self.commonAlert.rightBtn.width_sd, point.y+self.commonAlert.rightBtn.height_sd, kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeXinYongKaShouKuan emptyRect:emptyRect imgRect:imgRect imgStr:@"guide2" completion:^{
        [weakself.commonAlert.qmuiAlter hideWithAnimated:YES completion:^(BOOL finished) {
            [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(MCBankCardTypeXinyongka), @"isLogin":@(NO),@"whereCome":@"1"}];
        }];


    }];
}
- (void)clickRightBtnAction
{
    [MCPagingStore pushWebWithTitle:@"使用说明" classification:@"功能跳转"];
}
- (IBAction)hideKeyboard:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.keyboardBottomCons.constant = -self.keyboardView.ly_height;
    }];
}
- (IBAction)clickTextView:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.keyboardBottomCons.constant = 0;
    }];
}

- (IBAction)keyboardBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    NSString *moneyText = self.moneyView.text;
    if ([title isEqualToString:@"删除"]) {
        if (moneyText.length != 0) {
            self.moneyView.text = [moneyText substringToIndex:moneyText.length - 1];
        }
    } else {
        if ([moneyText rangeOfString:@"."].location != NSNotFound) { // 有小数
            if (moneyText.length >= 14 && sender.tag != 5011) {
                return;
            }
        } else { // 不含小数
            if (moneyText.length >= 11 && sender.tag != 5011) {
                return;
            }
        }
        // 判断小数
        if ([moneyText containsString:@"."] && sender.tag != 5011) {
            NSRange range = [moneyText rangeOfString:@"."];
            if ((moneyText.length-(range.location+1))==2) {
                return;
            }
        }
        // 拼接数字
        // 一位数
        if (moneyText.length == 0) {
            // 输入 0 或者 .
            if (sender.tag == 5010 || sender.tag == 5011) {
                self.moneyView.text = [NSString stringWithFormat:@"0."];
            }
            // 1~9
            if (sender.tag >= 5001 && sender.tag <= 5009) {
                self.moneyView.text = title;
            }
        } else {
            // 拼接0~9
            if (sender.tag >= 5001 && sender.tag <= 5010) {
                self.moneyView.text = [moneyText stringByAppendingString:title];
            }
            // 拼接小数点
            if (sender.tag == 5011) {
                // 判断是否已经有小数点
                if ([moneyText rangeOfString:@"."].location != NSNotFound) {
                    self.moneyView.text = [moneyText stringByAppendingString:@""];
                }else {
                    self.moneyView.text = [moneyText stringByAppendingString:@"."];
                }
            }
        }
        // 4. 判断是否有小数点
        if (sender.tag == 5011) {
            // 判断是否已经有小数点
            if ([moneyText rangeOfString:@"."].location != NSNotFound) {
                self.moneyView.text = [moneyText stringByAppendingString:@""];
            }else {
                self.moneyView.text = [moneyText stringByAppendingString:@"."];
            }
        }
    }
}
//获取某个字符串或者汉字的首字母.

- (NSString *)firstCharactorWithString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];

}
// 立即收款
- (IBAction)clickGatherBtnAction:(QMUIButton *)sender {
    
    [[KDGuidePageManager shareManager] requestShiMing:^{
        if (self.moneyView.text.floatValue <= 0 || [[self firstCharactorWithString:self.moneyView.text] isEqualToString:@"."]) {
            [MCToast showMessage:@"请输入正确的金额" position:MCToastPositionCenter];
            return;
        }
    #ifndef __OPTIMIZE__
        
    #else
        if (self.moneyView.text.floatValue < 100) {
            [MCToast showMessage:@"收款金额不能低于100元" position:MCToastPositionCenter];
            return;
        }
    #endif
       
        if (!self.xinyongInfo) {
            [MCToast showMessage:@"请选择支付的信用卡" position:MCToastPositionCenter];
            return;
        }
        if (!self.chuxuInfo) {
            [MCToast showMessage:@"请选择到账的储蓄卡" position:MCToastPositionCenter];
            return;
        }
        
        //先把储蓄卡设为默认
        __weak __typeof(self)weakSelf = self;
        [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/default/%@",TOKEN] parameters:@{@"cardno":self.chuxuInfo.cardNo} ok:^(MCNetResponse * _Nonnull resp) {
            KDSlotCardAisleViewController *vc = [[KDSlotCardAisleViewController alloc] init];
            vc.money = self.moneyView.text;
            vc.xinyongInfo = self.xinyongInfo;
            vc.chuxuInfo = self.chuxuInfo;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }];
    
    



}
/** 添加信用卡 */
- (IBAction)clickAddCreditCardBtn:(QMUIButton *)sender {
    __weak __typeof(self)weakSelf = self;

    [[KDGuidePageManager shareManager] requestShiMing:^{
        //默认信用卡
        NSDictionary *p1 = @{@"userId":SharedUserInfo.userid,
                             @"type":@"0",
                             @"nature":@"0",
                             @"isDefault":@"1"};
        [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:p1 ok:^(MCNetResponse * _Nonnull resp) {
            [weakSelf pushCardVCWithType:MCBankCardTypeXinyongka];
        } other:^(MCNetResponse * _Nonnull resp) {
            [MCLoading hidden];
            if ([resp.code isEqualToString:@"666666"]) {
                [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(MCBankCardTypeXinyongka), @"isLogin":@(NO),@"whereCome":@"1"}];
            } else {
                [MCToast showMessage:resp.messege];
            }
        }];
    }];


    
    

    
    
    
    
    
   
}
/** 添加储蓄卡 */
- (IBAction)clickAddDepositCardBtn:(QMUIButton *)sender {
    [[KDGuidePageManager shareManager] requestShiMing:^{ [self pushCardVCWithType:MCBankCardTypeChuxuka]; }];
    
}
#pragma mark - 数据请求

- (void)nocardAlertShowWithMessage:(NSString *)msg type:(MCBankCardType)cardType cardModel:(MCBankCardModel *)cardModel {
    __weak __typeof(self)weakSelf = self;
    self.commonAlert = [KDCommonAlert newFromNib];
    [self.commonAlert initKDCommonAlertContent:msg  isShowClose:NO];
    self.commonAlert.rightActionBlock = ^{
        [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":cardType==MCBankCardTypeXinyongka?@(MCBankCardTypeXinyongka):@(MCBankCardTypeChuxuka), @"isLogin":@(NO),@"whereCome":@"1"}];

//        [weakSelf pushCardVCWithType:cardType];
        
    };
}
- (void)pushCardVCWithType:(MCBankCardType)cardType
{
    MCCardManagerController *vc = [[MCCardManagerController alloc] init];
    if (cardType == MCBankCardTypeXinyongka) {
        vc.titleString = @"选择信用卡";
    } else {
        vc.titleString = @"选择储蓄卡";
    }
    [self.navigationController pushViewController:vc animated:YES];
    vc.selectCard = ^(MCBankCardModel * _Nonnull cardModel, NSInteger type) {
        if (type == 0) {
            self.xinyongInfo = cardModel;
        } else {
            self.chuxuInfo = cardModel;
        }
    };
}

// 设置储蓄卡按钮信息
- (void)setChuxuInfo:(MCBankCardModel *)chuxuInfo
{
    _chuxuInfo = chuxuInfo;
    if (!chuxuInfo) {
        self.depositImg.hidden = YES;
        self.depositLabel.hidden = YES;
        return;
    }
    MCBankCardInfo *ii = [MCBankStore getBankCellInfoWithName:chuxuInfo.bankName];
    self.depositImg.image = ii.logo;
    self.depositImg.hidden = NO;
    NSString *cardNo = chuxuInfo.cardNo;
    if (cardNo && cardNo.length > 4) {
        NSString *bankName = [NSString stringWithFormat:@"%@ (%@)",chuxuInfo.bankName,[cardNo substringFromIndex:cardNo.length-4]];
        self.depositLabel.text = bankName;
    }
    self.depositLabel.hidden = NO;
    [self.addDepositBtn setTitle:@"更换" forState:UIControlStateNormal];
}
// 设置信用卡按钮信息
- (void)setXinyongInfo:(MCBankCardModel *)xinyongInfo
{
    _xinyongInfo = xinyongInfo;
    if (!xinyongInfo) {
        self.creditImg.hidden = YES;
        self.creditLabel.hidden = YES;
        return;
    }
    MCBankCardInfo *ii = [MCBankStore getBankCellInfoWithName:xinyongInfo.bankName];
    self.creditImg.image = ii.logo;
    self.creditImg.hidden = NO;
    NSString *cardNo = xinyongInfo.cardNo;
    if (cardNo && cardNo.length > 4) {
        NSString *bankName = [NSString stringWithFormat:@"%@ (%@)",xinyongInfo.bankName,[cardNo substringFromIndex:cardNo.length-4]];
        self.creditLabel.text = bankName;
    }
    self.creditLabel.hidden = NO;
    [self.addCreditBtn setTitle:@"更换" forState:UIControlStateNormal];
}


//时时获取输入框输入的新内容   return NO：输入内容清空   return YES：输入内容不清空， string 输入内容 ，range输入的范围
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {
            //数据格式正确
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian) {
                    //text中还没有小数点
                    isHaveDian = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                //存在小数点
                if (isHaveDian) {
                    //判断小数点的位数，2 代表位数，可以
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{
            //输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    return YES;
}

-(void)cardVCBack:(NSNotification *)notification{
    [self requestDefaultChuXuCards];
}
-(void)showGuidePage2{
    //空白的frame
    CGRect emptyRect = CGRectMake(23, 101+kStatusBarHeight+40,KScreenWidth-46, 60);
    //图片的frame
    CGRect imgRect = CGRectMake(23, 101+kStatusBarHeight+100, kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeXinYongKaShouKuan emptyRect:emptyRect imgRect:imgRect imgStr:@"guide4" completion:^{}];
}
@end
