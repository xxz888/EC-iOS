//
//  KDRemedyView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDRemedyView.h"
#import "KDChosePayTypeView.h"
#import "KDChosePayTypeModel.h"
#import "KDRemedyModel.h"

@interface KDRemedyView ()<MCPayPWDInputViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyView;
@property(nonatomic, strong) QMUIModalPresentationViewController *showModal;

@property(nonatomic, strong) QMUIModalPresentationViewController *modalVC;
@property(nonatomic, strong) MCPayPWDInputView *pwdInput;
@property (weak, nonatomic) IBOutlet UILabel *successQuotaLabel;
@property (weak, nonatomic) IBOutlet UILabel *needAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (nonatomic, strong) KDRemedyModel *quotaModel;
@end

@implementation KDRemedyView

- (MCPayPWDInputView *)pwdInput {
    if (!_pwdInput) {
        _pwdInput = [MCPayPWDInputView newFromNib];
        _pwdInput.delegate = self;
        _pwdInput.modal = self.modalVC;
    }
    return _pwdInput;
}

- (QMUIModalPresentationViewController *)modalVC {
    if (!_modalVC) {
        _modalVC = [[QMUIModalPresentationViewController alloc] init];
        _modalVC.contentView = self.pwdInput;
        __weak __typeof(self)weakSelf = self;
        _modalVC.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
            weakSelf.pwdInput.frame = CGRectMake(10, NavigationContentTop+20, SCREEN_WIDTH-20, 170);
        };
    }
    return _modalVC;
}


- (QMUIModalPresentationViewController *)showModal
{
    if (!_showModal) {
        _showModal = [[QMUIModalPresentationViewController alloc] init];
    }
    return _showModal;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDRemedyView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH - 28 * 2,45);
    gl.startPoint = CGPointMake(0.53, 0);
    gl.endPoint = CGPointMake(0.53, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:204/255.0 green:162/255.0 blue:100/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:170/255.0 green:115/255.0 blue:34/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.payBtn.layer.cornerRadius = 22.5;
    self.payBtn.layer.masksToBounds = YES;
    [self.payBtn.layer insertSublayer:gl atIndex:0];
    
    if (SharedBrandInfo.brandPhone.length == 0) {
        self.phoneLabel.hidden = YES;
    } else {    
        self.phoneLabel.text = [NSString stringWithFormat:@"联系客服线下弥补：%@", SharedBrandInfo.brandPhone];
    }
}
- (void)setCreditExtensionModel:(KDCreditExtensionModel *)creditExtensionModel
{
    _creditExtensionModel = creditExtensionModel;
    
    self.moneyView.text = creditExtensionModel.lostSuperiorQuota;
}

- (void)showView
{
    self.showModal.contentView = self;
    self.showModal.contentViewMargins = UIEdgeInsetsZero;
    [self.showModal showWithAnimated:YES completion:nil];
    [self getUserQuota];
}
#pragma mark - 按钮点击
/** 点击问号 */
- (IBAction)clickIssueAction:(UIButton *)sender {
    
}
/** 取消 */
- (IBAction)clickCancelAction:(UIButton *)sender {
    [self.showModal hideWithAnimated:YES completion:nil];
}

/** 点击支付按钮 */
- (IBAction)payAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.showModal hideWithAnimated:YES completion:^(BOOL finished) {
        [weakSelf.modalVC showWithAnimated:YES completion:nil];
    }];
}
- (void)payPWDInputViewDidCommited:(NSString *)pwd
{
    if (pwd.length != 6) {
        [MCToast showMessage:@"输入密码错误"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:pwd forKey:@"payPassword"];
    [params setValue:self.creditExtensionModel.lostSuperiorQuota forKey:@"amount"];
    [params setValue:self.creditExtensionModel.firstUserId forKey:@"userId"];
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/excluding/debt" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)getUserQuota
{
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/query/user/quota/info" parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        self.quotaModel = [KDRemedyModel mj_objectWithKeyValues:resp.result];
    }];
}
- (void)setQuotaModel:(KDRemedyModel *)quotaModel
{
    _quotaModel = quotaModel;
    
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"总弥补金额：%.2f", quotaModel.totalAmount];
    self.successQuotaLabel.text = [NSString stringWithFormat:@"已弥补金额：%.2f", quotaModel.successAmount];
    self.needAmountLabel.text = [NSString stringWithFormat:@"剩余弥补金额：%.2f", quotaModel.needAmount];
}
@end
