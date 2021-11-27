//
//  KDEditDirectCardViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDEditDirectCardViewController.h"

@interface KDEditDirectCardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UITextField *safeCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *validLabel;
@property (weak, nonatomic) IBOutlet UITextField *billdayLabel;
@property (weak, nonatomic) IBOutlet UITextField *repaymentdayLabel;

@property(nonatomic, strong) BRStringPickerView *zdDayPicker;   //账单日
@property(nonatomic, strong) BRStringPickerView *hkDayPicker;   //还款日
@property (weak, nonatomic) IBOutlet KDFillButton *editBtn;
@end

@implementation KDEditDirectCardViewController

- (BRStringPickerView *)zdDayPicker {
    if (!_zdDayPicker) {
        _zdDayPicker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        _zdDayPicker.title = @"请选择账单日";
        NSMutableArray *tempA = [NSMutableArray new];
        for (int i=1; i<32; i++) {
            [tempA addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _zdDayPicker.selectValue = [NSString stringWithFormat:@"%ld", self.directModel.billDay];
        _zdDayPicker.dataSourceArr = tempA;
        __weak __typeof(self)weakSelf = self;
        _zdDayPicker.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            //MCLog(@"%@",resultModel.value);
            weakSelf.billdayLabel.text = [NSString stringWithFormat:@"%@",resultModel.value];
        };
    }
    return _zdDayPicker;
}
- (BRStringPickerView *)hkDayPicker {
    if (!_hkDayPicker) {
        _hkDayPicker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        _hkDayPicker.title = @"请选择还款日";
        NSMutableArray *tempA = [NSMutableArray new];
        for (int i=1; i<32; i++) {
            [tempA addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _hkDayPicker.selectValue = [NSString stringWithFormat:@"%ld", self.directModel.repaymentDay];
        _hkDayPicker.dataSourceArr = tempA;
        __weak __typeof(self)weakSelf = self;
        _hkDayPicker.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            //MCLog(@"%@",resultModel.value);
            weakSelf.repaymentdayLabel.text = [NSString stringWithFormat:@"%@",resultModel.value];
        };
    }
    return _hkDayPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"修改信息" tintColor:UIColor.whiteColor];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    self.editBtn.layer.cornerRadius = 25;
    self.editBtn.layer.masksToBounds = YES;
    NSString *first = [self.directModel.cardNo substringWithRange:NSMakeRange(0, 4)];
    NSString *last = [self.directModel.cardNo substringFromIndex:self.directModel.cardNo.length-4];
    self.cardNoLabel.text = [NSString stringWithFormat:@"%@ **** **** **** %@", first, last];
    self.safeCodeLabel.text = self.directModel.securityCode;
    self.validLabel.text = self.directModel.expiredTime;
    self.billdayLabel.text = [NSString stringWithFormat:@"%ld", self.directModel.billDay];
    self.repaymentdayLabel.text = [NSString stringWithFormat:@"%ld", self.directModel.repaymentDay];
}

- (IBAction)clickBilldayBtn:(id)sender {
    [self.view endEditing:YES];
    [self.zdDayPicker show];
}
- (IBAction)clickRepaymentBtn:(id)sender {
    [self.view endEditing:YES];
    [self.hkDayPicker show];
}
- (IBAction)editBtnAction:(id)sender {
    if (self.safeCodeLabel.text.length == 0) {
        [MCToast showMessage:@"请输入安全码"];
        return;
    }
    if (self.validLabel.text.length == 0) {
        [MCToast showMessage:@"请输入有效期"];
        return;
    }
    NSDictionary *param = @{@"userId":SharedUserInfo.userid,
                            @"bankCardNumber":self.directModel.cardNo,
                            @"securityCode":self.safeCodeLabel.text,
                            @"expiredTime":self.validLabel.text,
                            @"billDay":self.billdayLabel.text,
                            @"repaymentDay":self.repaymentdayLabel.text
                            };
    [MCSessionManager.shareManager mc_POST:@"/user/app/bank/set/bankinfo" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:resp.messege];
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    }];
}
@end
