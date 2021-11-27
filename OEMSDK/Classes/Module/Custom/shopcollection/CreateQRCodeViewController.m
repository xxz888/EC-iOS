//
//  CreateQRCodeViewController.m
//  Project
//
//  Created by SS001 on 2019/11/30.
//  Copyright © 2019 LY. All rights reserved.
//

#import "CreateQRCodeViewController.h"
#import "QRCodeView.h"
#import "STModal.h"
#import <OEMSDK.h>

@interface CreateQRCodeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyView;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@end

@implementation CreateQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavigationBarTitle:@"设置金额" tintColor:nil];
    
    [self.createBtn setBackgroundColor:MAINCOLOR];
    self.createBtn.layer.cornerRadius = 8;
    self.createBtn.layer.masksToBounds = YES;
//    [self.moneyView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        if (x.length != 0) {
//            self.moneyView.font = LYFont(39);
//            self.moneyView.text = x;
//        } else {
//            self.moneyView.font = LYFont(19);
//        }
//    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
                        // 判断数字是否过大
                        if (textField.text.floatValue > 999999.99) {
                            return NO;
                        }
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
                            // 判断数字是否过大
                            if (textField.text.floatValue > 999999.99) {
                                return NO;
                            }
                            return YES;
                        }else{
                            return NO;
                        }
                    }else{
                        // 判断数字是否过大
                        if (textField.text.floatValue > 999999.99) {
                            return NO;
                        }
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.moneyView.font = [UIFont systemFontOfSize:39];
    } else {
        self.moneyView.font = [UIFont systemFontOfSize:19];
    }
}

- (IBAction)createCodeView:(UIButton *)sender {
    
    NSString *money = self.moneyView.text;
    if (money.floatValue <= 0) {
        [MCToast showMessage:@"请输入的金额不得小于0元"];
        return;
    }
    NSDictionary *params = @{@"amount" : money};
    
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/facade/app/create/gathering/qrcode" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.view endEditing:YES];
        // 显示二维码
        NSString *str = resp.result;
        QRCodeView *codeView = [QRCodeView newFromNib];
        codeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        UIImage *img = [MCImageStore creatQrcodeImageWithUrlString:str width:100];
        codeView.codeView.image = [MCImageStore addImage:[MCImageStore getAppIcon] on:img frame:CGRectMake((img.size.width - 20) * 0.5, (img.size.width - 20) * 0.5, 20, 20)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        dispatch_async(dispatch_get_main_queue(), ^{
            [window addSubview:codeView];
        });
    }];
}

@end
