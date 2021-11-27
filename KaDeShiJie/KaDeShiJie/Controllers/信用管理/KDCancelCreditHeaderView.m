//
//  KDCancelCreditHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/18.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDCancelCreditHeaderView.h"
#import "KDCreditModel.h"
#import <KDFillButton.h>

@interface KDCancelCreditHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet KDFillButton *sureBtn;
/** 用户可用授信额度 */
@property (nonatomic, assign) CGFloat creditBalance;
/** 用户可用授信额度View */
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeView;
@property (nonatomic, strong) KDCreditModel *creditModel;
@end

@implementation KDCancelCreditHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 12;
    self.textView.layer.cornerRadius = 12;
    
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH - 18.5 * 2 - 20,44);
    gl.startPoint = CGPointMake(0.53, 0);
    gl.endPoint = CGPointMake(0.53, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:204/255.0 green:162/255.0 blue:100/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:170/255.0 green:115/255.0 blue:34/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.sureBtn.layer.cornerRadius = 22;
    self.sureBtn.layer.masksToBounds = YES;
    [self.sureBtn.layer insertSublayer:gl atIndex:0];
    
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/get/quota" parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        self.creditModel = [KDCreditModel mj_objectWithKeyValues:resp.result];
    }];
}

- (void)setModel:(KDCreditExtensionModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.firstUserName;
    self.idLabel.text = model.firstUserId;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDCancelCreditHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 512);
}

- (IBAction)getSMSCode:(UIButton *)sender {
    NSString *phone = SharedUserInfo.phone;
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
                
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds", second] forState:UIControlStateNormal];
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
- (IBAction)clickConfirmCreditAction:(UIButton *)sender {
    
    NSString *code = self.codeView.text;
    if (code.length != 6) {
        [MCToast showMessage:@"请输入正确的验证码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:code forKey:@"smsCode"];
    [params setValue:self.model.firstUserId forKey:@"sonUserId"];
    [params setValue:@"0" forKey:@"authQuota"];
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/authorization/quota" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"000000"]) {
            [MCLATESTCONTROLLER.navigationController qmui_popViewControllerAnimated:YES completion:^{
                [MCToast showMessage:@"取消成功"];
            }];
        }
    }];
}

@end
