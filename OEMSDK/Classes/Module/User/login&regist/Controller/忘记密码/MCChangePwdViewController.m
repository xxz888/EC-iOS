//
//  MCChangePwdViewController.m
//  AFNetworking
//
//  Created by SS001 on 2020/7/16.
//

#import "MCChangePwdViewController.h"
#import "MQStringSizeUtil.h"
#import "LoginAndRegistHTTPTools.h"
#import "KDCommonAlert.h"
@interface MCChangePwdViewController ()
/** 验证码输入框 */
@property (nonatomic, strong) QMUITextField *inputTF;
/** 倒计时按钮 */
@property (nonatomic, strong) UIButton *resetButton;
@end

@implementation MCChangePwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"短信验证";

    // 主界面
    [self setupMainView];
    // 验证码倒计时
    [self changeSendBtnText];
    //发送验证码
    [self requestDataForSendSMS];
    
}


#pragma mark --- SET UP VIEW

//------ 主界面 ------//
- (void)setupMainView
{
    
    NSString * phoneStr = [self.phone substringFromIndex:self.phone.length-4];
    NSString *indexString = (self.index == 0 ? @"重置登录密码" : (self.index == 1 ? @"重置交易密码" : @"忘记交易密码" ));
    
    [self setNavigationBarTitle:indexString tintColor:nil];
    
    NSString *infoString = [NSString stringWithFormat:@"您正在发起%@业务，短信验证码已下发手机尾号为%@用户手机请查收", indexString,phoneStr];
    CGFloat infoHeight = [MQStringSizeUtil getHeightForText:infoString withFont:LYFont(14) andWidth:SCREEN_WIDTH - 60];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, SCREEN_WIDTH - 60, infoHeight)];
    infoLabel.font = LYFont(14);
    infoLabel.text = infoString;
    infoLabel.textColor = [UIColor lightGrayColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 0;
    [self.view addSubview:infoLabel];
    //------ 输入区 ------//
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(50, infoLabel.qmui_bottom+20, SCREEN_WIDTH-100, 40)];
    inputView.layer.cornerRadius = 4;
    inputView.layer.masksToBounds = YES;
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    // 输入框
    self.inputTF = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 120, inputView.qmui_height)];
    self.inputTF.textColor = [UIColor blackColor];
    self.inputTF.tintColor = [UIColor blackColor];
    self.inputTF.placeholder = @"请输入验证码";
    self.inputTF.textAlignment = NSTextAlignmentLeft;
    self.inputTF.keyboardType = UIKeyboardTypePhonePad;
    self.inputTF.font = LYFont(14);
    self.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.inputTF addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:(UIControlEventEditingChanged)];
    [inputView addSubview:self.inputTF];
    self.inputTF.delegate  = self;
    // 竖线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.inputTF.qmui_right+40, 5, 1, inputView.qmui_height-10)];
    lineView.backgroundColor = LYColor(210, 210, 210);
    [inputView addSubview:lineView];
    // 发送按钮
    self.resetButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.resetButton.frame = CGRectMake(lineView.qmui_right, 0, inputView.qmui_width-lineView.qmui_right, inputView.qmui_height);
    self.resetButton.titleLabel.font = LYFont(14);
    self.resetButton.userInteractionEnabled = NO;
    [self.resetButton setTitle:@"重新发送" forState:(UIControlStateNormal)];
    [self.resetButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [self.resetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [inputView addSubview:self.resetButton];
    // 提交按钮
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureButton.frame = CGRectMake(30, inputView.qmui_bottom+30, SCREEN_WIDTH-60, 40);
    sureButton.backgroundColor = [UIColor mainColor];
    sureButton.layer.cornerRadius = 4;
    sureButton.layer.masksToBounds = YES;
    [sureButton setTitle:@"提交" forState:(UIControlStateNormal)];
    [sureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sureButton];
}


#pragma mark --- TARGET METHOD
//------ 重置按钮点击事件 ------//
- (void)resetButtonClick:(UIButton *)sender {
    
    [self changeSendBtnText];
    //发送验证码
    [self requestDataForSendSMS];
}
//------ 提交按钮点击事件 ------//
- (void)sureButtonClick:(UIButton *)sender {
    
    if (self.inputTF.text.length == 0) return;
    // 请求修改数据
    [self requestDataForReset];
}
#pragma mark --- DELEGATE

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.inputTF) {
        
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        
        else if (self.inputTF.text.length >= 6) {
            self.inputTF.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}

#pragma mark --- PRIVATE METHOD
//------ 输入框值改变 ------//
- (void)textFieldChangeAction:(UITextField *)textField {
    
    
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
                
                [self.resetButton setTitle:[NSString stringWithFormat:@"%ldS", second] forState:UIControlStateNormal];
                [self.resetButton setUserInteractionEnabled:NO];
                second--;
            }else {
                
                dispatch_source_cancel(timer);
                [self.resetButton setTitle:@"重新发送" forState:(UIControlStateNormal)];
                [self.resetButton setUserInteractionEnabled:YES];
            }
            
        });
    });
    // 启动源
    dispatch_resume(timer);
}

#pragma mark --- SET DATA
//------ 短信验证码发送 ------//
- (void)requestDataForSendSMS {
    
    [LoginAndRegistHTTPTools getSMS:self.phone];
}
//------ 更改登录密码 ------//
- (void)requestDataForReset {
    
    if (self.index == 0) { // 重置登录密码
        /* phone:手机号 vericode:验证码  password:新密码 */
        NSDictionary *changepassDic = @{@"phone":self.phone, @"vericode":self.inputTF.text, @"password":self.nowDataString, @"brandId":MCModelStore.shared.brandConfiguration.brand_id};
        __weak typeof(self) weakSelf = self;
        [[MCSessionManager shareManager] mc_POST:@"/user/app/password/update" parameters:changepassDic ok:^(MCNetResponse * _Nonnull resp) {
            
            kWeakSelf(self);
            KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
            [commonAlert initKDCommonAlertContent:@"登录密码重置成功，请重新登录！"  isShowClose:YES];
            commonAlert.middleActionBlock = ^{
                MCModelStore.shared.userDefaults.pwd = @"";
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            };
//            [MCAlertStore showWithTittle:@"提示" message:@"登录密码重置成功，请重新登录！" buttonTitles:@[@"确定"] sureBlock:^{
//                MCModelStore.shared.userDefaults.pwd = @"";
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }];
        }];
    }
    
    if (self.index == 1 || self.index == 2) { // 重置交易密码
        /* token  paypass:新的交易密码 */
        NSString *token = TOKEN;
        NSDictionary *dic = @{@"paypass":self.nowDataString, @"vericode":self.inputTF.text, @"brandId":MCModelStore.shared.brandConfiguration.brand_id};
        __weak typeof(self) weakSelf = self;
        NSString *url = [NSString stringWithFormat:@"/user/app/paypass/update/%@", TOKEN];
        [[MCSessionManager shareManager] mc_POST:url parameters:dic ok:^(MCNetResponse * _Nonnull resp) {
            
            kWeakSelf(self);
            KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
            [commonAlert initKDCommonAlertContent:@"交易密码重置成功！"  isShowClose:YES];
            commonAlert.middleActionBlock = ^{
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            };

            
//            [MCAlertStore showWithTittle:@"提示" message:@"交易密码重置成功！" buttonTitles:@[@"确定"] sureBlock:^{
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }];
        }];
    }
}

@end
