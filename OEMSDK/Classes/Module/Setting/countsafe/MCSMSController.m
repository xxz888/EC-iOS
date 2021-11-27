//
//  MCSMSController.m
//  MCOEM
//
//  Created by wza on 2020/4/21.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCSMSController.h"
#import "MCCountSafeController.h"
#import "KDFillButton.h"

@interface MCSMSController ()

@property(nonatomic, assign) MCResetPWDType type;

@property(nonatomic, strong) QMUILabel *label;
@property(nonatomic, strong) QMUITextField *textField;
@property(nonatomic, strong) QMUIButton *smsButton;
@property(nonatomic, strong) KDFillButton *nextButton;
@property(nonatomic, copy) NSString *pwd;

@end

@implementation MCSMSController

- (QMUILabel *)label {
    if (!_label) {
        _label = [[QMUILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
    }
    return _label;
}
- (QMUITextField *)textField {
    if (!_textField) {
        _textField = [[QMUITextField alloc] init];
        _textField.placeholder = @"请输入验证码";
        _textField.font = UIFontMake(14);
    }
    return _textField;
}
- (QMUIButton *)smsButton {
    if (!_smsButton) {
        _smsButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_smsButton addTarget:self action:@selector(smsClick:) forControlEvents:UIControlEventTouchUpInside];
        [_smsButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_smsButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        _smsButton.titleLabel.font = UIFontMake(14);
    }
    return _smsButton;
}
- (KDFillButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[KDFillButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 50)];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextTouched:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nextButton;
}

- (instancetype)initWithType:(MCResetPWDType)type password:(nonnull NSString *)pwd{
    self = [super init];
    if (self) {
        self.type = type;
        self.pwd = pwd;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorForBackground;
    [self setNavigationBarTitle:@"短信验证" tintColor:nil];
    [self setupSubViews];
    
    [self changeSendBtnText];
}
- (void)smsClick:(UIButton *)sender {
    [self changeSendBtnText];
}
- (void)setupSubViews {
    
    NSString *typeName = (self.type == MCResetPWDTypeTrade)?@"重置交易密码":@"重置登录密码";
    
    NSString *str = [NSString stringWithFormat:@"您正在发起 %@ 业务，短信验证码已下发手机尾号为 %@ 用户手机请查收",typeName,[SharedUserInfo.phone substringFromIndex:SharedUserInfo.phone.length-4]];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    [text addAttribute:NSForegroundColorAttributeName value:UIColorGrayDarken range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:UIFontMake(15) range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:MAINCOLOR range:NSMakeRange(6, 6)];
    [text addAttribute:NSFontAttributeName value:[UIFont qmui_dynamicSystemFontOfSize:15 weight:QMUIFontWeightBold italic:NO] range:NSMakeRange(6, 6)];
    [text addAttribute:NSForegroundColorAttributeName value:MAINCOLOR range:NSMakeRange(30, 4)];
    [text addAttribute:NSFontAttributeName value:[UIFont qmui_dynamicSystemFontOfSize:15 weight:QMUIFontWeightBold italic:NO] range:NSMakeRange(30, 4)];
    
    self.label.attributedText = text;
    
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(@(NavigationContentTop+40));
    }];
    [self.view layoutIfNeeded];
    
    
    
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(40, self.label.qmui_bottom + 60, SCREEN_WIDTH-80, 50)];
    vv.layer.cornerRadius = 2;
    [self.view addSubview:vv];
    vv.backgroundColor = UIColorWhite;
    self.textField.frame = CGRectMake(20, 0, vv.qmui_width*2/3-40, vv.qmui_height);
    self.textField.qmui_centerY = vv.qmui_height/2;
    self.smsButton.frame = CGRectMake(vv.qmui_width*2/3+1, 0, vv.qmui_width*1/3-1, vv.qmui_height);
    [vv addSubview:self.textField];
    [vv addSubview:self.smsButton];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(vv.qmui_width*2/3, 4, 0.5, 42)];
    line.backgroundColor = UIColorGrayDarken;
    [vv addSubview:line];
    
    self.nextButton.frame = CGRectMake(20, vv.qmui_bottom + 40, SCREEN_WIDTH-40, 50);
    self.nextButton.layer.cornerRadius = self.nextButton.height/2;

    [self.view addSubview:self.nextButton];
    
}
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
                
                [self.smsButton setTitle:[NSString stringWithFormat:@"%lds后重发", second] forState:UIControlStateNormal];
                [self.smsButton setUserInteractionEnabled:NO];
                second--;
            }else {
                dispatch_source_cancel(timer);
                [self.smsButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
                [self.smsButton setUserInteractionEnabled:YES];
            }
            
        });
    });
    // 启动源
    dispatch_resume(timer);
}



- (void)nextTouched:(QMUIButton *)sender {
    if (!self.textField.text || self.textField.text.length == 0) {
        [MCToast showMessage:@"请输入短信验证码"];
        return;
    }
    if (self.type == MCResetPWDTypeLogin) {
        NSDictionary *param = @{@"phone":SharedUserInfo.phone,
                                @"vericode":self.textField.text,
                                @"password":@"",
                                @"brandId":SharedBrandInfo.ID};
        [MCSessionManager.shareManager mc_POST:@"/user/app/password/update" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
            QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:nil message:@"登录密码修改成功，请重新登录" preferredStyle:QMUIAlertControllerStyleAlert];
            [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
                UIApplication.sharedApplication.keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_signupin];
            }]];
            [alert showWithAnimated:YES];
        }];
    } else {
        NSDictionary *param = @{@"paypass":self.pwd,
                                @"vericode":self.textField.text,
                                @"brandId":BCFI.brand_id};
        [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/paypass/update/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
            [MCToast showMessage:@"修改成功" position:MCToastPositionCenter];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }];
    }
    
}

@end
