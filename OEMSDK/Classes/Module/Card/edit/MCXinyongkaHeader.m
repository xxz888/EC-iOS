//
//  MCXinyongkaHeader.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCXinyongkaHeader.h"
#import "BankCardTextField.h"
#import <BRPickerView/BRPickerView.h>
#import "MCTXManager.h"
#import "KDCVNAlertContent.h"
#import "KDPhoneAlertContent.h"
#import "DDPhotoViewController.h"
@interface MCXinyongkaHeader ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet BankCardTextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;
@property (weak, nonatomic) IBOutlet UITextField *textField6;
@property (weak, nonatomic) IBOutlet UITextField *textField7;


@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UILabel *desc2;

@property (weak, nonatomic) IBOutlet UIView *bg1;
@property (weak, nonatomic) IBOutlet UIView *bg2;

@property(nonatomic, copy) NSString *lastDate;

@property(nonatomic, strong) BRStringPickerView *zdDayPicker;   //账单日
@property(nonatomic, strong) BRStringPickerView *hkDayPicker;   //还款日

@property (weak, nonatomic) IBOutlet QMUIButton *scanBtn;

@end



@implementation MCXinyongkaHeader



- (BRStringPickerView *)zdDayPicker {
    if (!_zdDayPicker) {
        _zdDayPicker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        _zdDayPicker.title = @"请选择账单日";
        NSMutableArray *tempA = [NSMutableArray new];
        for (int i=1; i<32; i++) {
            [tempA addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _zdDayPicker.dataSourceArr = tempA;
        __weak __typeof(self)weakSelf = self;
        _zdDayPicker.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            //MCLog(@"%@",resultModel.value);
            weakSelf.textField6.text = [NSString stringWithFormat:@"%@日",resultModel.value];
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
        _hkDayPicker.dataSourceArr = tempA;
        __weak __typeof(self)weakSelf = self;
        _hkDayPicker.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            //MCLog(@"%@",resultModel.value);
            weakSelf.textField7.text = [NSString stringWithFormat:@"%@日",resultModel.value];
        };
    }
    return _hkDayPicker;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.desc2.textColor =  UIColor.mainColor;
    
    [self.sureButton setBackgroundColor:[UIColor mainColor]];
    self.sureButton.layer.cornerRadius = self.sureButton.height/2;
    
    self.textField1.text = SharedUserInfo.realname;
    self.textField2.delegate = self;
    
    [self.textField3 addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.textField4 addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.textField5 addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.textField6.delegate = self;
    self.textField7.delegate = self;
    
    self.scanBtn.imagePosition = QMUIButtonImagePositionTop;
    self.scanBtn.spacingBetweenImageAndTitle = 2;
    
    self.bg1.layer.cornerRadius = 12;
    self.bg2.layer.cornerRadius = 12;

//    self.textField2.text = @"6225767784298952";
//    self.textField3.text = @"13383773800";
//    self.textField4.text = @"905";
//    self.textField5.text = @"06/21";
//    self.textField6.text = @"16日";
//    self.textField7.text = @"4日";
    
//    self.textField2.text = @"6222525629158895";
//    self.textField3.text = @"13383773800";
//    self.textField4.text = @"589";
//    self.textField5.text = @"11/24";
//    self.textField6.text = @"16日";
//    self.textField7.text = @"4日";
}

- (void)textChanged:(UITextField *)textField {
    
    if (textField == self.textField3 && textField.text.length >= 11) {
        textField.text = [textField.text substringToIndex:11];
        return;
    }
    if (textField == self.textField4 && textField.text.length >= 4) {
        textField.text = [textField.text substringToIndex:4];
        return;
    }
    if(textField == self.textField5) { //有效期
        if(self.textField5.text.length == 2){
            if(self.lastDate.length == 3){
                self.textField5.text = [NSString stringWithFormat:@"%@", [self.textField5.text substringToIndex:1]];
            } else {
                self.textField5.text = [NSString stringWithFormat:@"%@/", self.textField5.text];
            }
        }
        if (textField.text.length >= 5) {
            textField.text = [textField.text substringToIndex:5];
        }
        self.lastDate = self.textField5.text;
        return;
    }
}

- (IBAction)buttonTouched:(id)sender {

    if ([self verifyFailedTextField:self.textField1] ||
        [self verifyFailedTextField:self.textField2] ||
        [self verifyFailedTextField:self.textField3] ||
        [self verifyFailedTextField:self.textField4] ||
        [self verifyFailedTextField:self.textField5] ||
        [self verifyFailedTextField:self.textField6] ||
        [self verifyFailedTextField:self.textField7] ) {
        return;
    }
    if (self.model) {   //修改
        [self modifyXinyong];
    } else {    //新增
        [self bindXinyong];
    }
    
}
//新增信用卡
- (void)bindXinyong {

    NSString *cardNo = [self.textField2.mc_realText qmui_stringByReplacingPattern:@" " withString:@""];
    NSDictionary *param = @{@"realname":self.textField1.text,
                            @"idcard":SharedUserInfo.idcard,
                            @"bankcard":cardNo,
                            @"mobile":self.textField3.text,
                            @"securitycode":self.textField4.text,
                            @"expiretime":self.textField5.text,
                            @"repaymentDay":[self.textField7.text substringToIndex:self.textField7.text.length-1],
                            @"billDay":[self.textField6.text substringToIndex:self.textField6.text.length-1]
                            };
    //MCLog(@"%@",param);
    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/add/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:resp.messege];
        
        //新增成功之后发送一个通知让 KDWebContainer 重新加载
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mcNotificationWebContainnerReset" object:nil];
        });
        
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    }];
}
//修改信用卡
- (void)modifyXinyong {
    NSString *cardNo = [self.textField2.mc_realText qmui_stringByReplacingPattern:@" " withString:@""];
    NSDictionary *param = @{@"userId":SharedUserInfo.userid,
                            @"bankCardNumber":cardNo,
                            @"securityCode":self.textField4.text,
                            @"expiredTime":self.textField5.text,
                            @"billDay":[self.textField6.text substringToIndex:self.textField6.text.length-1],
                            @"repaymentDay":[self.textField7.text substringToIndex:self.textField7.text.length-1]
                            };
    //MCLog(@"%@",param);
    [MCSessionManager.shareManager mc_POST:@"/user/app/bank/set/bankinfo" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:resp.messege];
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    }];
}

- (BOOL)verifyFailedTextField:(UITextField *)textField {
    
    if (textField == self.textField2 && textField.text.length < 16) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField3 && textField.text.length < 11) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField4 && textField.text.length < 2) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField5 && textField.text.length < 4) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField6 && textField.text.length == 0) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField7 && textField.text.length == 0) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    return NO;
}

- (void)setModel:(MCBankCardModel *)model {
    _model = model;
    if (!model) {
        return;
    }
    [self.sureButton setTitle:@"确认修改" forState:UIControlStateNormal];
    for (int i=2000; i<2003; i++) {
        UIView *vv = [self viewWithTag:i];
        vv.userInteractionEnabled = NO;
        vv.alpha = 0.3;
    }
    self.scanBtn.hidden = YES;
    self.textField1.text = model.userName;
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < model.cardNo.length; i++) {
        [string appendString:[model.cardNo substringWithRange:NSMakeRange(i, 1)]];
        if (i % 4 == 3) {
            [string appendString:@" "];
        }
    }
    self.textField2.text = string;
    self.textField3.text = model.phone;
    self.textField4.text = model.securityCode;
    self.textField5.text = model.expiredTime;
    
    self.textField6.text = [NSString stringWithFormat:@"%ld日",(long)model.billDay];
    
    self.textField7.text = [NSString stringWithFormat:@"%ld日",(long)model.repaymentDay];

    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField2) {
        [textField bankNoshouldChangeCharactersInRange:range replacementString:string];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.textField6) {
        [self endEditing:YES];
        [self.zdDayPicker show];
        return NO;
    }
    if (textField == self.textField7) {
        [self endEditing:YES];
        [self.hkDayPicker show];
        return NO;
    }
    return YES;
}

- (IBAction)scanTouched:(QMUIButton *)sender {
    __weak __typeof(self)weakSelf = self;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        [MCToast showMessage:@"请在设置-隐私-相机界面，打开相机权限"];
        return;
    }
    //调用身份证大小的相机
    DDPhotoViewController *vc = [[DDPhotoViewController alloc] init];
 
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.imageblock = ^(UIImage *image) {
        [weakSelf.scanBtn setImage:image forState:UIControlStateNormal];
        [self uploadBankImage:image];
    };
    [MCLATESTCONTROLLER presentViewController:vc animated:YES completion:nil];
    
//    [MCTXManager.shared startBankOcrCompletion:^(MCTXResult * _Nonnull result) {
//        if (result.error == nil) {
//            NSString *no = result.brankCardNo;
//            NSMutableString *string = [NSMutableString string];
//            for (int i = 0; i < no.length; i++) {
//                [string appendString:[no substringWithRange:NSMakeRange(i, 1)]];
//                if (i % 4 == 3) {
//                    [string appendString:@" "];
//                }
//            }
//            weakSelf.textField2.text = string;
//        }
//    }];
}
//#pragma mark - 上传银行卡图片
- (void)uploadBankImage:(UIImage *)image {
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_UPLOAD:@"/paymentchannel/app/auth/bankcardocr" parameters:@{@"brandId":SharedConfig.brand_id} images:@[image] remoteFields:@[@"bankFile"] imageNames:@[@"bankFile"] imageScale:0.1 imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
        //MCLog(@"%@",resp.result);
        if (resp.result[@"cardNum"] && [resp.result[@"cardNum"] length] > 10) {
        NSString * no = [NSString stringWithFormat:@"%@",resp.result[@"cardNum"]];
        NSMutableString *string = [NSMutableString string];
        for (int i = 0; i < no.length; i++) {
            [string appendString:[no substringWithRange:NSMakeRange(i, 1)]];
            if (i % 4 == 3) {
                [string appendString:@" "];
            }
        }
        weakSelf.textField2.text = [NSString stringWithFormat:@"%@",string];
        }else{
            [MCToast showMessage:@"卡号识别失败，请手动填写卡号"];
        }

    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
        MCTXResult *rr = [[MCTXResult alloc] init];
        rr.error = [NSError errorWithDomain:resp.messege code:resp.code.intValue userInfo:nil];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@", (long)error.code, error.localizedFailureReason]];
        MCTXResult *rr = [[MCTXResult alloc] init];
        rr.error = error;
    }];
}
- (IBAction)alertPhone:(UIButton *)sender {
    QMUIModalPresentationViewController *diaV = [[QMUIModalPresentationViewController alloc] init];
    KDPhoneAlertContent *content = [KDPhoneAlertContent newFromNib];
    __block QMUIModalPresentationViewController *blockDiav = diaV;
    content.touchBlock = ^{
        [blockDiav hideWithAnimated:YES completion:nil];
    };
    diaV.contentView = content;
    [diaV showWithAnimated:YES completion:nil];
}

- (IBAction)alertCVN:(UIButton *)sender {
    QMUIModalPresentationViewController *diaV = [[QMUIModalPresentationViewController alloc] init];
    KDCVNAlertContent *content = [KDCVNAlertContent newFromNib];
    __block QMUIModalPresentationViewController *blockDiav = diaV;
    content.touchBlock = ^{
        [blockDiav hideWithAnimated:YES completion:nil];
    };
    diaV.contentView = content;
    [diaV showWithAnimated:YES completion:nil];
}


@end
