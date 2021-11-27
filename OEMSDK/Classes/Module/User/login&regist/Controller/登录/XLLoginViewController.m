//
//  XLLoginViewController.m
//  AFNetworking
//
//  Created by SS001 on 2020/7/16.
//

#import "XLLoginViewController.h"
#import <Masonry.h>
#import "MCForgetPWDViewController.h"
#import "XLRegistViewController.h"
#import "LoginAndRegistHTTPTools.h"

@interface XLLoginViewController ()
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIImageView *phoneView;
@property (nonatomic, strong) QMUITextField *phoneTextView;
@property (nonatomic, strong) UIImageView *pwdView;
@property (nonatomic, strong) QMUITextField *pwdTextView;
@property (nonatomic, strong) QMUIButton *recordBtn;
@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *registBtn;
@end

@implementation XLLoginViewController

#pragma mark - 懒加载
- (UIButton *)registBtn
{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registBtn setTitle:@"还没有账号？立即注册" forState:UIControlStateNormal];
        [_registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _registBtn.titleLabel.font = [UIFont qmui_lightSystemFontOfSize:15];
        [_registBtn addTarget:self action:@selector(clickRegistBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}

 - (UIButton *)forgetBtn
{
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetBtn.titleLabel.font = [UIFont qmui_lightSystemFontOfSize:15];
        [_forgetBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(clickForgetBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}

- (QMUIButton *)recordBtn
{
    if (!_recordBtn) {
        _recordBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setTitle:@"记住密码" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:[UIColor qmui_colorWithHexString:@"a0a0a0"] forState:UIControlStateNormal];
        [_recordBtn setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
        _recordBtn.titleLabel.font = [UIFont qmui_lightSystemFontOfSize:15];
        [_recordBtn setImage:[[UIImage mc_imageNamed:@"mc_check_no"] qmui_imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [_recordBtn setImage:[[UIImage mc_imageNamed:@"mc_check_yes"] qmui_imageWithTintColor:[UIColor mainColor]] forState:UIControlStateSelected];
        _recordBtn.spacingBetweenImageAndTitle = 10;
        _recordBtn.selected = YES;
        [_recordBtn addTarget:self action:@selector(clickRecodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (QMUITextField *)pwdTextView
{
    if (!_pwdTextView) {
        _pwdTextView = [[QMUITextField alloc] init];
        _pwdTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTextView.secureTextEntry = YES;
        _pwdTextView.placeholder = @"请输入登录密码";
        _pwdTextView.text = SharedDefaults.pwd;
        _pwdTextView.keyboardType=UIKeyboardTypeASCIICapable;
        _pwdTextView.maximumTextLength = 16;
        _pwdTextView.secureTextEntry = YES;
    }
    return _pwdTextView;
}

- (UIImageView *)pwdView
{
    if (!_pwdView) {
        _pwdView = [[UIImageView alloc] initWithImage:[UIImage mc_imageNamed:@"xl_pwd_icon"]];
        _pwdView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pwdView;
}

- (QMUITextField *)phoneTextView
{
    if (!_phoneTextView) {
        _phoneTextView = [[QMUITextField alloc] init];
        _phoneTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextView.placeholder = @"请输入手机号";
        _phoneTextView.maximumTextLength = 11;
        _phoneTextView.text = SharedDefaults.phone;
        _phoneTextView.tintColor = [UIColor mainColor];
        _phoneTextView.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneTextView;
}

- (UIImageView *)phoneView
{
    if (!_phoneView) {
        _phoneView = [[UIImageView alloc] initWithImage:[UIImage mc_imageNamed:@"xl_phone_icon"]];
        _phoneView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _phoneView;
}

- (UIButton *)loginBtn
{
    if (_loginBtn == nil) {
        //登录按钮
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setBackgroundColor:[UIColor mainColor]];
        CAGradientLayer* gradient= [CAGradientLayer new];
        gradient.colors=@[(__bridge id)[UIColor mainColor].CGColor,(__bridge id)[UIColor mainColor].CGColor];
        gradient.startPoint= CGPointMake(0, 0);
        gradient.endPoint= CGPointMake(1, 1);
        gradient.masksToBounds = NO;
        gradient.cornerRadius = 24*MCSCALE;
        [_loginBtn.layer addSublayer:gradient];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.clipsToBounds=YES;
        _loginBtn.layer.cornerRadius=24*MCSCALE;
        _loginBtn.layer.shadowOffset=CGSizeMake(0, 3);
        _loginBtn.layer.shadowColor= [UIColor mainColor].CGColor;
        _loginBtn.layer.masksToBounds=NO;
        _loginBtn.layer.shadowOpacity=0.5;
        [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

#pragma mark - 系统方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES];
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBaseView];
    [self setNavigationBarHidden];
    NSString *phone = MCModelStore.shared.userDefaults.phone;
    NSString *pwd = MCModelStore.shared.userDefaults.pwd;
    self.phoneTextView.text = phone;
    self.pwdTextView.text = pwd;
    if (phone.length != 0 && pwd.length != 0) {
        BOOL not_auto_login = SharedDefaults.not_auto_logonin;
        if (not_auto_login) {
            [self clickLoginBtn];
        }
    }
}

#pragma mark - 页面设置
- (void)setupBaseView {
    self.view.backgroundColor = [UIColor whiteColor];
    //背景的渐变
    CAGradientLayer* gradient= [CAGradientLayer new];
    gradient.frame=CGRectMake(0, 0, SCREEN_WIDTH, 300*MCSCALE);
    gradient.colors=@[(__bridge id)[UIColor mainColor].CGColor,(__bridge id)[UIColor mainColor].CGColor];
    gradient.startPoint= CGPointMake(0, 0);
    gradient.endPoint= CGPointMake(1, 1);
    [self.view.layer addSublayer:gradient];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:BCFI.image_logo];
    logoView.layer.cornerRadius = 39 * MCSCALE;
    logoView.layer.masksToBounds = YES;
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(78 * MCSCALE);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).mas_equalTo(142 * MCSCALE);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 10;
    contentView.layer.shadowColor = [UIColor grayColor].CGColor;
    contentView.layer.shadowOpacity = 0.5;
    contentView.layer.shadowOffset = CGSizeMake(0, 5);
    contentView.layer.shadowRadius = 3;
    [self.view insertSubview:contentView belowSubview:logoView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).mas_equalTo(16 * MCSCALE);
        make.top.equalTo(logoView.mas_centerY);
        make.height.mas_equalTo(360 * MCSCALE);
    }];
    
    [contentView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(contentView.mas_left).mas_equalTo(27 * MCSCALE);
        make.bottom.equalTo(contentView.mas_bottom).mas_equalTo(-40 * MCSCALE);
        make.height.mas_equalTo(48 * MCSCALE);
    }];
    
    [contentView addSubview:self.phoneView];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32 * MCSCALE);
        make.top.mas_equalTo(79 * MCSCALE);
        make.height.mas_equalTo(19 * MCSCALE);
        make.width.mas_equalTo(16 * MCSCALE);
    }];
    
    [contentView addSubview:self.phoneTextView];
    [self.phoneTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneView.mas_right).mas_equalTo(12 * MCSCALE);
        make.centerY.equalTo(self.phoneView);
        make.right.mas_equalTo(-27 * MCSCALE);
    }];
    
    //分割线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor qmui_colorWithHexString:@"e2e7ed"];
    [contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27 * MCSCALE);
        make.centerX.equalTo(contentView);
        make.top.equalTo(self.phoneView.mas_bottom).mas_equalTo(13);
        make.height.mas_equalTo(1);
    }];
    
    [contentView addSubview:self.pwdView];
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneView);
        make.top.equalTo(topLine.mas_bottom).mas_equalTo(28 * MCSCALE);
        make.height.mas_equalTo(19 * MCSCALE);
        make.width.mas_equalTo(16 * MCSCALE);
    }];
    
    [contentView addSubview:self.pwdTextView];
    [self.pwdTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdView.mas_right).mas_equalTo(12 * MCSCALE);
        make.centerY.equalTo(self.pwdView);
        make.right.mas_equalTo(-27 * MCSCALE);
    }];
    
    //分割线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor qmui_colorWithHexString:@"e2e7ed"];
    [contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27 * MCSCALE);
        make.centerX.equalTo(contentView);
        make.top.equalTo(self.pwdTextView.mas_bottom).mas_equalTo(13);
        make.height.mas_equalTo(1);
    }];
    
    [contentView addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27 * MCSCALE);
        make.top.equalTo(bottomLine.mas_bottom).mas_equalTo(30 * MCSCALE);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(100);
    }];
    
    [contentView addSubview:self.forgetBtn];
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtn);
        make.right.mas_equalTo(-27 * MCSCALE);
        make.height.equalTo(self.recordBtn);
    }];
    
    [self.view addSubview:self.registBtn];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).mas_equalTo(- (TabBarHeight + 10) * MCSCALE);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - 按钮点击
/** 记住密码 */
- (void)clickRecodeBtn:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}
/** 忘记密码 */
- (void)clickForgetBtn
{
    [self.navigationController pushViewController:[MCForgetPWDViewController new] animated:YES];
}
/** 注册 */
- (void)clickRegistBtn
{
    [self.navigationController pushViewController:[XLRegistViewController new] animated:YES];
}
- (void)clickLoginBtn
{
    NSString *phone = self.phoneTextView.text;
    NSString *pwd = self.pwdTextView.text;
    if (phone.length == 0 || phone.length != 11) {
        [MCToast showMessage:@"请输入手机号"];
        return;
    }
    if (pwd.length < 6) {
        [MCToast showMessage:@"密码格式不正确,必须输入6-16位数字或字母"];
        return;
    }
    SharedDefaults.not_rember_pwd = self.recordBtn.isSelected;
    [LoginAndRegistHTTPTools loginWithPhone:phone pwd:pwd remberPwd:self.recordBtn.isSelected result:nil];
}
@end
