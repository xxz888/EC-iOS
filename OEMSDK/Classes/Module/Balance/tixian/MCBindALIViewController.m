//
//  MCBindALIViewController.m
//  Project
//
//  Created by SS001 on 2020/8/5.
//  Copyright © 2020 LY. All rights reserved.
//

#import "MCBindALIViewController.h"
#import <OEMSDK/OEMSDK.h>

@interface MCBindALIViewController ()
@property (weak, nonatomic) IBOutlet QMUITextField *phoneView;
@property (weak, nonatomic) IBOutlet QMUITextField *codeView;
@property (weak, nonatomic) IBOutlet QMUIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@end

@implementation MCBindALIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"绑定支付宝" tintColor:nil];
    
    
    
    self.bindBtn.layer.cornerRadius = self.bindBtn.ly_height * 0.5;
    self.bindBtn.layer.masksToBounds = YES;
    self.codeBtn.layer.borderColor = [UIColor qmui_colorWithHexString:@"#F22D2D"].CGColor;
    self.codeBtn.layer.borderWidth = 1;
    self.codeBtn.layer.cornerRadius = 4;
    self.codeBtn.layer.masksToBounds = YES;
    
    
    [self.phoneView addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChanged:(UITextField *)textField {
    if (textField.text.length == 11) {
        self.bindBtn.enabled = YES;
        self.bindBtn.backgroundColor = [UIColor qmui_colorWithHexString:@"#1577FF"];
    } else {
        self.bindBtn.enabled = NO;
        self.bindBtn.backgroundColor = [UIColor qmui_colorWithHexString:@"#D9D9D9"];
    }
}

- (IBAction)getCodeAction:(QMUIButton *)sender {
    NSString *phone = self.phoneView.text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入正确的手机号"];
        return;
    }
    [self requestDataForSendSMS];
    [self changeSendBtnText];
}
//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText {
    __block NSInteger second = 60;
    // 全局队列 默认优先级
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 定时器模式 事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // NSEC_PER_SEC是秒 *1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                [self.codeBtn setTitle:[NSString stringWithFormat:@"(%ldS)后重发", second] forState:UIControlStateNormal];
                [self.codeBtn setUserInteractionEnabled:NO];
                second--;
            }else {
                dispatch_source_cancel(timer);
                [self.codeBtn setTitle:@"重新发送" forState:(UIControlStateNormal)];
                [self.codeBtn setUserInteractionEnabled:YES];
            }
        });
    });
    // 启动源
    dispatch_resume(timer);
}
//------ 短信验证码发送 ------//
- (void)requestDataForSendSMS
{
    NSDictionary *sendDic = @{@"phone":self.phoneView.text, @"brand_id":SharedConfig.brand_id};
    
    [MCSessionManager.shareManager mc_GET:@"/notice/app/sms/send" parameters:sendDic ok:^(MCNetResponse * _Nonnull resp) {
        
    }];
}
/** 绑定支付宝账号 */
- (IBAction)bindAliPhone:(UIButton *)sender {
    NSString *code = self.codeView.text;
    if (code.length != 6) {
        [MCToast showMessage:@"请输入正确的验证码"];
        return;
    }
    // 校验验证码
    NSDictionary *sendDic = @{@"phone":self.phoneView.text, @"smsCode":self.codeView.text};
    
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/notice/app/sms/verifysmscode" parameters:sendDic ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf bindAli];
    }];
}
- (void)bindAli
{
    __weak typeof(self)mySelf = self;
    
    NSString *token = TOKEN;
    NSString *realName = SharedUserInfo.realname;
    NSDictionary *bankDic = [[NSDictionary alloc] init];
    bankDic = @{
        @"userId":[NSString stringWithFormat:@"%ld", SharedUserInfo.userid],
        @"realname":realName,
        @"bankcard":self.phoneView.text,
        @"mobile":SharedUserInfo.phone,
        @"type":@"3",
        @"idcard":SharedUserInfo.idcard
    };
    
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/add/%@",TOKEN] parameters:bankDic ok:^(MCNetResponse * _Nonnull resp) {
        QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:nil message:@"绑定成功！" preferredStyle:QMUIAlertControllerStyleAlert];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
        }]];
        [alert showWithAnimated:YES];
    }];
    
}





@end
