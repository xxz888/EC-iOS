//
//  XLRegistViewController.m
//  AFNetworking
//
//  Created by SS001 on 2020/7/16.
//

#import "XLRegistViewController.h"
#import "LoginAndRegistHTTPTools.h"
#import "MCProtocolViewController.h"
#import "KDCommonAlert.h"
@interface XLRegistViewController ()
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIButton *protocolBtn;
@end

@implementation XLRegistViewController

#pragma mark - 懒加载
- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"已有账号？立即登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont qmui_lightSystemFontOfSize:15];
        [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

#pragma mark - 系统方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden];
    [self setupBaseView];
}

- (void)setupBaseView {
    self.view.backgroundColor = [UIColor whiteColor];
    //背景的渐变
    CAGradientLayer* gradient= [CAGradientLayer new];
    gradient.frame=CGRectMake(0, 0, SCREEN_WIDTH, 300*MCSCALE);
    gradient.colors=@[(__bridge id)[UIColor mainColor].CGColor,(__bridge id)[UIColor mainColor].CGColor];
    gradient.startPoint= CGPointMake(0, 0);
    gradient.endPoint= CGPointMake(1, 1);
    [self.view.layer addSublayer:gradient];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
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
    self.contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).mas_equalTo(16 * MCSCALE);
        make.top.equalTo(logoView.mas_centerY);
        make.height.mas_equalTo(414 * MCSCALE);
    }];
    
    NSArray *imgArray = @[@"xl_phone_icon", @"xl_vericode_icon", @"xl_pwd_icon", @"xl_inviter_icon"];
    NSArray *placeholderArr = @[@"手机号", @"手机验证码", @"登录密码", @"邀请人手机号码(必选)"];
    NSArray *maxLength = @[@"11", @"6", @"16", @"11"];
    for (int i = 0; i < imgArray.count; i++) {
        UIImageView *iconImg = [[UIImageView alloc] initWithImage:[UIImage mc_imageNamed:imgArray[i]]];
        iconImg.contentMode = UIViewContentModeScaleAspectFit;
        [contentView addSubview:iconImg];
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(27 * MCSCALE);
            make.width.mas_equalTo(16 * MCSCALE);
            make.height.mas_equalTo(19 * MCSCALE);
            make.top.mas_equalTo((69 + 45 * i) * MCSCALE);
        }];
        
        QMUITextField *textView = [[QMUITextField alloc] init];
        textView.maximumTextLength = [maxLength[i] intValue];
        textView.placeholder = placeholderArr[i];
        textView.font = [UIFont qmui_lightSystemFontOfSize:16];
        textView.tag = 100 + i;
        if (i == 2) {
            textView.secureTextEntry = YES;
            textView.keyboardType = UIKeyboardTypeDefault;
        } else {
            textView.keyboardType = UIKeyboardTypeNumberPad;
            textView.secureTextEntry = NO;
        }
        [contentView addSubview:textView];
        if (i == 1) {
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImg.mas_right).mas_equalTo(15 * MCSCALE);
                make.centerY.equalTo(iconImg);
                make.width.mas_equalTo(100 * MCSCALE);
            }];
            
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor qmui_colorWithHexString:@"e2e7ed"];
            [contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(textView.mas_right).mas_equalTo(30 * MCSCALE);
                make.centerY.equalTo(textView);
                make.width.mas_equalTo(1);
                make.height.mas_equalTo(15 * MCSCALE);
            }];
            
            UIButton *codeBT = [UIButton buttonWithType:UIButtonTypeCustom];
            [codeBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [codeBT setTitle:@"获取验证码" forState:UIControlStateNormal];
            codeBT.titleLabel.font = LYFont(14);
            codeBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [codeBT addTarget:self action:@selector(clickCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:codeBT];
            self.codeBtn = codeBT;
            [codeBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(line.mas_right);
                make.right.equalTo(contentView.mas_right).mas_equalTo(-27 * MCSCALE);
                make.centerY.equalTo(textView);
                make.height.mas_equalTo(20);
            }];
        } else {
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImg.mas_right).mas_equalTo(15 * MCSCALE);
                make.centerY.equalTo(iconImg);
                make.right.mas_equalTo(-27 * MCSCALE);
            }];
        }
        
        //分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor qmui_colorWithHexString:@"e2e7ed"];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(27 * MCSCALE);
            make.centerX.equalTo(contentView);
            make.top.equalTo(textView.mas_bottom).mas_equalTo(8);
            make.height.mas_equalTo(1);
        }];
    }
    
    UIView *textView = [self.contentView viewWithTag:103];
    QMUIButton *leftBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[[UIImage mc_imageNamed:@"xl_xieyi_icon"] qmui_imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [leftBtn setImage:[[UIImage mc_imageNamed:@"xl_xieyi_icon"] qmui_imageWithTintColor:[UIColor mainColor]] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(clickProtocolBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:leftBtn];
    self.protocolBtn = leftBtn;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * MCSCALE);
        make.top.equalTo(textView.mas_bottom).mas_equalTo(30);
        make.width.height.mas_equalTo(30);
    }];
    UILabel *centerView = [[UILabel alloc] init];
    centerView.text = @"我已经阅读并同意";
    centerView.textColor = [UIColor grayColor];
    centerView.font = LYFont(12);
    [contentView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right).mas_equalTo(2);
        make.centerY.equalTo(leftBtn);
        make.height.equalTo(leftBtn);
        make.width.mas_equalTo(100);
    }];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *title = [NSString stringWithFormat:@"《%@服务协议》", MCModelStore.shared.brandConfiguration.brand_name];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = LYFont(12);
    [rightBtn addTarget:self action:@selector(clickXieyiBtn) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_right);
        make.centerY.equalTo(leftBtn);
        make.height.equalTo(leftBtn);
        make.width.mas_equalTo(150);
    }];
    
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setBackgroundColor:[UIColor mainColor]];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.clipsToBounds=YES;
    registBtn.layer.cornerRadius=19*MCSCALE;
    registBtn.layer.shadowOffset=CGSizeMake(0, 3);
    registBtn.layer.shadowColor= [UIColor mainColor].CGColor;
    registBtn.layer.masksToBounds=NO;
    registBtn.layer.shadowOpacity=0.5;
    [contentView addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27 * MCSCALE);
        make.centerX.equalTo(contentView);
        make.height.mas_equalTo(38 * MCSCALE);
        make.bottom.mas_equalTo(-50 * MCSCALE);
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).mas_equalTo(- (TabBarHeight) * MCSCALE);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - 按钮点击
- (void)clickLoginBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickCodeBtn:(UIButton *)sender
{
    
    UITextField *textView = (UITextField *)[self.contentView viewWithTag:100];
    NSString *phone = textView.text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请正确输入手机号"];
        return;
    }
    
    // 发送验证码
    NSDictionary *params = @{@"phone":phone, @"brand_id":MCModelStore.shared.brandConfiguration.brand_id};
    [[MCSessionManager shareManager] mc_GET:@"/notice/app/sms/send" parameters:params ok:^(MCNetResponse * _Nonnull okResponse) {
        // 启动倒计时
        [self changeSendBtnText];
    }];
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
- (void)clickXieyiBtn
{
    MCProtocolViewController * vc = [MCProtocolViewController new];
    vc.whereCome = @"1";
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController pushViewController:[MCProtocolViewController new] animated:YES];
}
- (void)clickProtocolBtn:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}
- (void)clickRegisterBtn
{
    NSString *phone = ((UITextField *)[self.contentView viewWithTag:100]).text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入手机号"];
        return;
    }
    NSString *code = ((UITextField *)[self.contentView viewWithTag:101]).text;
    if (code.length != 6) {
        [MCToast showMessage:@"请输入6位数字验证码"];
        return;
    }
    NSString *pwd = ((UITextField *)[self.contentView viewWithTag:102]).text;
    if (pwd.length < 6) {
        [MCToast showMessage:@"请输入6~16位数字字母组合的密码"];
        return;
    }
    NSString *invite = ((UITextField *)[self.contentView viewWithTag:103]).text;
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
@end
