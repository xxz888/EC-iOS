//
//  MCPayPWDInputView.m
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCPayPWDInputView.h"
#import "MCResetPWDController.h"
#import "STModal.h"

@interface MCPayPWDInputView ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *lostButton;

@property (weak, nonatomic) IBOutlet UIView *view2;


@end
 
@implementation MCPayPWDInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    self.view2.layer.cornerRadius = 8;
    self.view2.clipsToBounds = YES;
    [self.commitButton setBackgroundColor:MAINCOLOR];
    [self.lostButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    self.textField.maximumTextLength = 6;
}
- (IBAction)onCommitTouched:(id)sender {
    if (self.textField.text.length < 6) {
        [MCToast showMessage:@"请输入6位支付密码"];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [self.modal hideWithAnimated:YES completion:^(BOOL finished) {
        [weakSelf.delegate payPWDInputViewDidCommited:self.textField.text];
    }];
}
- (IBAction)onLostTouched:(id)sender {
    
    
    [self.modal hideWithAnimated:NO completion:^(BOOL finished) {
        [MCLATESTCONTROLLER.navigationController pushViewController:[[MCResetPWDController alloc] initWithType:MCResetPWDTypeTrade] animated:YES];
    }];
}

- (IBAction)onCloseTouched:(id)sender {
    [self.modal hideWithAnimated:YES completion:nil];
}

- (void)dealloc
{
    MCLog(@"MCPayPWDInputView dealloc");
}

@end
