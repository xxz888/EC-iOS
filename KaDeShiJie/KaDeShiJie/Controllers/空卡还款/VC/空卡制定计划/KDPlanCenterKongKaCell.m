//
//  KDPlanCenterKongKaCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanCenterKongKaCell.h"
#import "KDRefundTimeView.h"
#import "KDDirectPushChoseStatusView.h"
#import "KDPlanAlertView.h"

#import "KDCalendarView.h"
#import "MSSCalendarHeaderModel.h"
#import "KDPlanKongKaPreviewViewController.h"

#import "KDRepaymentDetailModel.h"
#import "KDTotalAmountModel.h"

@interface KDPlanCenterKongKaCell ()<KDRefundTimeViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *markView;

// 每日还款次数
@property (weak, nonatomic) IBOutlet QMUIButton *refundCountBtn;

// 地址按钮
@property (weak, nonatomic) IBOutlet QMUIButton *addressBtn;
// 指定计划
@property (weak, nonatomic) IBOutlet KDFillButton *planBtn;
// 选择地址view
@property (nonatomic, strong) BRAddressPickerView *addressPicker;

@property(nonatomic, strong) QMUIModalPresentationViewController *modalVC;
@property(nonatomic, strong) KDCalendarView *calendar;

/** 还款总金额 */
@property (weak, nonatomic) IBOutlet UITextField *refundMoneyView;
/** 手续费 */
@property (weak, nonatomic) IBOutlet UITextField *cardBalanceView;

//启动计划,需要的两个参数
@property (nonatomic, strong) NSString * city;  //浙江省-杭州市-330000-330100
@property (nonatomic, strong) NSString * extra;//
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;

@property (nonatomic, strong) BRResultModel * provinceModel;
@property (nonatomic, strong) BRResultModel * cityModel;

@property (nonatomic, strong) NSString * executeDate;//
@property (nonatomic, strong) NSString * dayRepaymentCount;//
@property (nonatomic, strong) NSString * sumRepaymentCount;//
@property (nonatomic, strong) NSString * reservedAmount;//

@end

@implementation KDPlanCenterKongKaCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 10;
    self.markView.layer.cornerRadius = 3;
    self.refundCountBtn.imagePosition = QMUIButtonImagePositionRight;
    self.planBtn.layer.cornerRadius = 24.5;
    self.addressBtn.imagePosition = QMUIButtonImagePositionRight;
    
    [self.refundMoneyView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.addressBtn setTitle:@"请选择消费地区" forState:UIControlStateNormal];
    self.cardBalanceView.delegate = self;
    
    self.dayRepaymentCount = @"2";
    
    self.planBtn.userInteractionEnabled = NO;
    [self.planBtn setupDisAppearance];
}


#pragma mark ------------------选择地址------------------------
- (IBAction)clickAddressBtn:(QMUIButton *)sender {
    [self.cardBalanceView endEditing:NO];
    [self requestProvice];
}
#pragma mark ------------------选择还款次数------------------------
- (IBAction)clickRefundCountBtn:(QMUIButton *)sender {
    [self.cardBalanceView endEditing:NO];
    QMUIModalPresentationViewController *diaVC = [[QMUIModalPresentationViewController alloc] init];
    KDDirectPushChoseStatusView *typeView = [[KDDirectPushChoseStatusView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    diaVC.contentView = typeView;
    typeView.titleArray = @[@"1次/日", @"2次/日", @"3次/日"];
    diaVC.contentViewMargins = UIEdgeInsetsZero;
    [diaVC showWithAnimated:YES completion:nil];
    kWeakSelf(self);
    typeView.choseStatus = ^(NSString * _Nonnull status) {
        if ([status isEqualToString:@"取消"]) {
            [diaVC hideWithAnimated:YES completion:nil];
            return;
        }
        [weakself.refundCountBtn setTitle:[status componentsSeparatedByString:@"/日"][0] forState:UIControlStateNormal];
        weakself.dayRepaymentCount = [status componentsSeparatedByString:@"次/日"][0];
        [diaVC hideWithAnimated:YES completion:nil];
        //实时请求手续费
        [weakself requestEmptyShouXuFei];
        
    };
}

#pragma mark -----------------请求省份------------------------
-(void)requestProvice{
    NSString * proviceUrl = @"";
    kWeakSelf(self);
    //请求省市
    //https://api.flyaworld.com/v1.0/paymentgateway/topup/ttf/province
    [MCLATESTCONTROLLER.sessionManager mc_POST:proviceUrl parameters:@{} ok:^(MCNetResponse * _Nonnull resp) {
        NSArray * result = resp.result;
        NSMutableArray * modelArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in result) {
            BRResultModel * model = [[BRResultModel alloc]init];
            model.key = dic[@"id"];
            model.value = dic[@"divisionName"];
            [modelArray addObject:model];
        }
        BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        pickView.title = @"请选择省份";
        pickView.dataSourceArr = modelArray;
        [pickView show];
        pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            weakself.provinceModel = resultModel;
            [weakself requestCity:resultModel.key];
        };
        pickView.cancelBlock = ^{[UIView animateWithDuration:0.5 animations:^{}]; };
    }];
}
#pragma mark -----------------请求城市------------------------
-(void)requestCity:(NSString *)cityKey{
    kWeakSelf(self);
    //请求市
    NSString * cityUrl = @"";
    //https://api.flyaworld.com/v1.0/paymentgateway/topup/ttf/city
    [MCLATESTCONTROLLER.sessionManager mc_POST:cityUrl parameters:@{@"parentId":cityKey} ok:^(MCNetResponse * _Nonnull resp) {
        NSArray * result = resp.result;
        NSMutableArray * modelArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in result) {
            BRResultModel * model = [[BRResultModel alloc]init];
            model.key = dic[@"id"];
            model.value = dic[@"divisionName"];
            [modelArray addObject:model];
        }
        BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        pickView.title = @"请选择城市";
        pickView.dataSourceArr = modelArray;
        [pickView show];
        pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            weakself.cityModel = resultModel;
            [weakself.addressBtn setTitle:[NSString stringWithFormat:@"%@-%@",weakself.provinceModel.value,weakself.cityModel.value] forState:UIControlStateNormal];
        };
        pickView.cancelBlock = ^{[UIView animateWithDuration:0.5 animations:^{}];};
    }];
}

#pragma mark ------------------检查界面参数------------------------
-(BOOL)checkParameters{
    //检查还款总金额参数
    if ([self inRefundMoneyToNewMoney] == 0) {
        [MCToast showMessage:@"请填写还款总金额"];
        return NO;
        //检查卡余额参数
    }
    if ([self.addressBtn.titleLabel.text isEqualToString:@"请选择消费地区"] || !self.provinceModel || !self.cityModel){
        [MCToast showMessage:@"请选择消费地区"];
        return NO;
    }
    return YES;
}
#pragma mark ------------------制定计划------------------------
- (IBAction)clickPlanBtn:(KDFillButton *)sender {
    [self requestZhiDingJiHua];
}
- (void)requestZhiDingJiHua{
    if (![self checkParameters]) {return;}
/*
 userId: 80035715
 creditCardNumber: 6225767784298952
 taskAmount: 11111
 version: 99-6
 dayRepaymentCounts: 2
 city: {"provinceId":"078451CF91A3410A89B3FCA7939AC061,广东省","cityCode":"38C5C40BD79146CFB6CC529E1E7FBA6C,中山市","merprovince":"广东省","mercity":"中山市","merarea":"38C5C40BD79146CFB6CC529E1E7FBA6C"}

 **/
    //拼凑起最后制定计划接口所需的参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [params setValue:self.directModel.cardNo forKey:@"creditCardNumber"];//卡号
    
    [params setValue:[NSString stringWithFormat:@"%.2f",[self inRefundMoneyToNewMoney]] forKey:@"taskAmount"];// 还款金额
    [params setValue:self.dayRepaymentCount forKey:@"dayRepaymentCounts"];//单日还款笔数
    [params setValue:self.version forKey:@"version"];//通道的版本号
    
    NSDictionary * cityDic = @{
                               @"provinceId":[NSString stringWithFormat:@"%@,%@",self.provinceModel.key,self.provinceModel.value],
                               @"cityCode"  :[NSString stringWithFormat:@"%@,%@",self.cityModel.key    ,self.cityModel.value],
                               @"merprovince":self.provinceModel.value,
                               @"mercity":self.cityModel.value,
                               @"merarea":self.cityModel.key
                               };
    [params setValue:[NSString toJSONData:cityDic] forKey:@"city"];//城市
    kWeakSelf(self);
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/creditcardmanager/app/empty/card/plan/apply" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        //一切
        if ([resp.code isEqualToString:@"000000"]) {
            [MCToast showMessage:resp.messege];
            [weakself respCode000000:resp.result];
        }
    }];
}
-(void)respCode000000:(NSDictionary *)resp{
    KDPlanKongKaPreviewViewController * vc = [[KDPlanKongKaPreviewViewController alloc]init];
    vc.directModel = self.directModel;
    vc.startDic = resp;
    vc.whereCome = 1;// 1 下单 2 历史记录 3 信用卡还款进来
    vc.version = self.version;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}
//获取总金额
-(CGFloat)inRefundMoneyToNewMoney{
    CGFloat money = [self.refundMoneyView.text doubleValue];
    return money;
}
//设置选择地址的可点击状态
-(void)changeBtnStatus{
    if ([self inRefundMoneyToNewMoney] < 600) {
        [self.planBtn setupDisAppearance];
        self.planBtn.userInteractionEnabled = NO;
    }else{
        [self.planBtn setupAppearance];
        self.planBtn.userInteractionEnabled = YES;

    }
}
//还款总金额
- (void)textFieldDidChange:(UITextField *)textView{

    [self changeBtnStatus];
    //实时请求手续费
    [self requestEmptyShouXuFei];
}
-(void)requestEmptyShouXuFei{
    if ([self inRefundMoneyToNewMoney] < 600) {
        self.cardBalanceView.text = @"0.00";
        return;
    }
    self.cardBalanceView.text = [NSString stringWithFormat:@"%.2f",[self inRefundMoneyToNewMoney] * 0.0125];
}

- (void)setDirectModel:(KDDirectRefundModel *)directModel{
    _directModel = directModel;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"planCenterKongKaCell";
    KDPlanCenterKongKaCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDPlanCenterKongKaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

@end
