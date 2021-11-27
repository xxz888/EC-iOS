//
//  KDForgetPwdViewController.m
//  KaDeShiJie
//
//  Created by apple on 2020/11/3.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDForgetPwdViewController.h"
#import "MCToast.h"
#import "KDFillButton.h"
#import <MeiQiaSDK/MQDefinition.h>

@interface KDForgetPwdViewController ()
@property(nonatomic, strong) UIView *footView;
@end

@implementation KDForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (SharedUserInfo.phone && SharedUserInfo.phone.length == 11) {
        self.phoneTf.text = SharedUserInfo.phone;
    }
    self.pwd2Tf.font = self.pwd1Tf.font = Font_System(14);
    [self setNavigationBarTitle:@"重置登录密码" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    [self.bottomView addSubview:self.footView];
    
    self.phoneTf.text = self.startPhone;
    [self.phoneTf addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTf addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"客服" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(14);
    shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);


    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
}
-(void)clickRightBtnAction{
    [MCServiceStore pushMeiqiaVC];
}
-(void)textFiledEditChanged:(UITextField *)tf{
    if (tf == self.phoneTf && tf.text.length > 11) {
        tf.text = [tf.text substringToIndex:11];
    }
    if (tf == self.codeTf && tf.text.length > 6) {
        tf.text = [tf.text substringToIndex:6];
    }
}
- (IBAction)getCodeAction:(id)sender {
    NSString *phone = self.phoneTf.text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入正确的手机号"];
        return;
    }

    // 发送验证码
    NSDictionary *params = @{@"phone":phone, @"brand_id":MCModelStore.shared.brandConfiguration.brand_id};
    [[MCSessionManager shareManager] mc_GET:@"/notice/app/sms/send" parameters:params ok:^(MCNetResponse * _Nonnull okResponse) {
        [self changeSendBtnText];
    }];
}




- (IBAction)finishAction:(id)sender {
    
   
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


- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        KDFillButton *logoutBtn = [[KDFillButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 50)];
        logoutBtn.layer.cornerRadius = logoutBtn.height / 2;
        
        logoutBtn.center = _footView.center;
        [logoutBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_footView addSubview:logoutBtn];
        [logoutBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}
-(void)next:(id)sender{
    if (self.pwd1Tf.text.length < 6) {
        [MCToast showMessage:@"新密码至少六位字符"];
        return;
    }
    if (self.pwd2Tf.text.length < 6) {
        [MCToast showMessage:@"新密码至少六位字符"];
        return;
    }
    if ([self.pwd1Tf.text isEqualToString:self.pwd2Tf.text] ) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.phoneTf.text forKey:@"phone"];
        [params setValue:self.pwd1Tf.text forKey:@"password"];
        [params setValue:self.codeTf.text forKey:@"vericode"];
        [params setValue:SharedConfig.brand_id forKey:@"brandId"];

        __weak typeof(self) weakSelf = self;
        [[MCSessionManager shareManager] mc_POST:@"/user/app/password/update" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
            if ([resp.code isEqualToString:@"000000"]) {
                [MCToast showMessage:@"修改成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        [MCToast showMessage:@"两次密码不一致"];
    }
}
@end
