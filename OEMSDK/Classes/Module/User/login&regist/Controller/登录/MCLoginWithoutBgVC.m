//
//  MCLoginViewController.m
//  MCOEM
//
//  Created by SS001 on 2020/3/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCLoginWithoutBgVC.h"
#import "LoginAndRegistHTTPTools.h"
#import "MCApp.h"
#import "MCRegistViewController.h"
#import "MCForgetPWDViewController.h"

@interface MCLoginWithoutBgVC ()
@property (weak, nonatomic) IBOutlet UIImageView *loginIcon;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;

@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registBtnTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopCons;

@property (weak, nonatomic) IBOutlet QMUITextField *phoneView;
@property (weak, nonatomic) IBOutlet QMUITextField *pwdView;

@property (weak, nonatomic) IBOutlet UILabel *copyrightLb;

@end

@implementation MCLoginWithoutBgVC



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor qmui_randomColor];
    self.loginIcon.image = BCFI.image_login_logo;
    self.line1.backgroundColor = [UIColor mainColor];
    self.line2.backgroundColor = [UIColor mainColor];
    
    // 登录
    [self.loginBt setBackgroundColor:UIColor.mainColor];
    self.loginBt.layer.cornerRadius = 6.0;
    self.loginBt.layer.masksToBounds = YES;
    
    [self.forgetPwdBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    self.registBtnTopCons.constant = NavigationBarHeight;
    self.iconTopCons.constant = 93 * SCREEN_WIDTH / 375;
    self.pwdView.secureTextEntry = YES;
    
    NSString *phone = MCModelStore.shared.userDefaults.phone;
    NSString *pwd = MCModelStore.shared.userDefaults.pwd;
    self.phoneView.text = phone;
    self.pwdView.text = pwd;
    if (phone.length != 0 && pwd.length != 0) {
        if (SharedDefaults.not_auto_logonin) {
            [self clickLoginBtn:nil];
        }
    }    
    self.copyrightLb.text = [NSString stringWithFormat:@"Copyright @2020 %@",BCFI.brand_company];
}

#pragma mark - 忘记密码
- (IBAction)clickForgetPwdBtn:(UIButton *)sender {
    [self.navigationController pushViewController:[MCForgetPWDViewController new] animated:YES];
}
#pragma mark - 注册
- (IBAction)clickRegistBtn:(UIButton *)sender {
    MCRegistViewController *registBt = [MCRegistViewController new];
    registBt.noHaveBg = @"noHaveBg";
    [self.navigationController pushViewController:registBt animated:YES];
}

#pragma mark - 登录
- (IBAction)clickLoginBtn:(UIButton *)sender {
    NSString *phone = self.phoneView.text;
    NSString *pwd = self.pwdView.text;
    if (phone.length == 0 || phone.length != 11) {
        [MCToast showMessage:@"请输入手机号"];
        return;
    }
    if (pwd.length < 6) {
        [MCToast showMessage:@"密码格式不正确,必须输入6-16位数字或字母"];
        return;
    }
    SharedDefaults.not_rember_pwd = YES;
    [LoginAndRegistHTTPTools loginWithPhone:phone pwd:pwd remberPwd:YES result:nil];
}

@end
