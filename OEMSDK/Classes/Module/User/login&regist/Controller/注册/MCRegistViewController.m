//
//  MCRegistViewController.m
//  MCOEM
//
//  Created by SS001 on 2020/3/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCRegistViewController.h"
#import "LoginAndRegistHTTPTools.h"
#import "MCProtocolViewController.h"
#import "KDCommonAlert.h"
@interface MCRegistViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *registBg;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet QMUITextField *phoneView;
@property (weak, nonatomic) IBOutlet QMUITextField *vericodeView;
@property (weak, nonatomic) IBOutlet QMUITextField *pwdView;
@property (weak, nonatomic) IBOutlet QMUITextField *inviterView;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolView;
@property (weak, nonatomic) IBOutlet UIButton *vericodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@end

@implementation MCRegistViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.vericodeBtn setTitleColor:UIColor.mainColor forState:UIControlStateNormal];
    [self.protocolView setTitle:[NSString stringWithFormat:@"《%@服务协议》",BCFI.brand_name] forState:UIControlStateNormal];
    [self.protocolView setTitleColor:UIColor.mainColor forState:UIControlStateNormal];
    
    [self.registBtn setBackgroundColor:UIColor.mainColor];
    self.registBtn.layer.cornerRadius = 6.0f;
    self.registBtn.layer.masksToBounds = YES;
    
    // 判断背景图是否隐藏/协议按钮图片
    if ([_noHaveBg isEqualToString:@"noHaveBg"]) {
        self.registBg.hidden = YES;
        [self.protocolBtn setImage:[UIImage mc_imageNamed:@"mc_check_box"] forState:(UIControlStateNormal)];
        [self.protocolBtn setImage:[[UIImage mc_imageNamed:@"mc_check_box"] imageWithColor:[UIColor mainColor]] forState:(UIControlStateSelected)];
    
    }else{
        self.registBg.hidden = NO;
    }
     
    [[MCModelStore shared] reloadBrandInfo:^(MCBrandInfo * _Nonnull brandInfo) {
        NSString *phoneStr = brandInfo.brandPhone;
        if (phoneStr) {
            NSString *str = [NSString stringWithFormat:@"客服热线： %@", phoneStr];
            NSRange range = [str rangeOfString:phoneStr];
            NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:str];
            [atts addAttribute:NSForegroundColorAttributeName value:[UIColor mainColor] range:range];
            [self.bottomBtn setAttributedTitle:atts forState:UIControlStateNormal];
        }
    }];
}
- (IBAction)clickLoginBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取验证
- (IBAction)clickVericodeBtn:(UIButton *)sender {
    NSString *phone = self.phoneView.text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入手机号"];
        return;
    }
    // 启动倒计时
    [self changeSendBtnText];
    
    // 发送验证码
    [LoginAndRegistHTTPTools getSMS:phone];
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
                
                [self.vericodeBtn setTitle:[NSString stringWithFormat:@"(%ldS)后重发", second] forState:UIControlStateNormal];
                [self.vericodeBtn setUserInteractionEnabled:NO];
                second--;
            }else {
                dispatch_source_cancel(timer);
                [self.vericodeBtn setTitle:@"重新发送" forState:(UIControlStateNormal)];
                [self.vericodeBtn setUserInteractionEnabled:YES];
            }
            
        });
    });
    // 启动源
    dispatch_resume(timer);
}
#pragma mark - 点击复选框
- (IBAction)clickProtocolBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
#pragma mark - 用户协议
- (IBAction)clickProtocolView:(UIButton *)sender {
    MCProtocolViewController * vc = [MCProtocolViewController new];
    vc.whereCome = @"1";
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController pushViewController:[MCProtocolViewController new] animated:YES];
}
#pragma mark - 注册
- (IBAction)clickRegisterBtn:(UIButton *)sender {
    NSString *phone = self.phoneView.text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入手机号"];
        return;
    }
    NSString *code = self.vericodeView.text;
    if (code.length != 6) {
        [MCToast showMessage:@"请输入6位数字验证码"];
        return;
    }
    NSString *pwd = self.pwdView.text;
    if (pwd.length < 6) {
        [MCToast showMessage:@"请输入6~16位数字字母组合的密码"];
        return;
    }
    NSString *invite = self.inviterView.text;
    if (invite.length != 11) {
        [MCToast showMessage:@"请填写推荐人手机号"];
        return;
    }
    if (!self.protocolBtn.isSelected) {
        [MCToast showMessage:@"请先阅读并同意注册服务协议"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];
    [params setValue:code forKey:@"vericode"];
    [params setValue:pwd forKey:@"password"];
    [params setValue:invite forKey:@"invitecode"];
    [params setValue:MCModelStore.shared.brandConfiguration.brand_id forKey:@"brand_id"];
    [params setValue:MCModelStore.shared.brandConfiguration.brand_name forKey:@"brand_name"];
    [params setValue:@"" forKey:@"paypass"];
    [LoginAndRegistHTTPTools registWithParams:params result:^(BOOL result) {
        if (result) {
            
            
            kWeakSelf(self);
            KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
            [commonAlert initKDCommonAlertContent:@"注册成功"  isShowClose:YES];
            commonAlert.middleActionBlock = ^{
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            };
            
            
//            [MCAlertStore showWithTittle:@"提示" message:@"注册成功" buttonTitles:@[@"确定"] sureBlock:^{
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
        }
    }];
}

- (IBAction)clickBottomAction:(id)sender {
    NSString *phoneStr = SharedBrandInfo.brandPhone;
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneStr]]];
}

@end
