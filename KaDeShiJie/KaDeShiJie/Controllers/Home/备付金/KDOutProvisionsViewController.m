//
//  KDOutProvisionsViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDOutProvisionsViewController.h"
#import "KDChosePayTypeView.h"
#import "KDProvisionsTopView.h"

@interface KDOutProvisionsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property(nonatomic, strong) QMUIModalPresentationViewController *withdrawTypeModal;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHigCons;
@property (weak, nonatomic) IBOutlet UITextField *moneyView;
@property (nonatomic, assign) BOOL isHavePayType;
@property (nonatomic, strong) NSString *selectName;
@end

@implementation KDOutProvisionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [self setNavigationBarTitle:@"转出" tintColor:nil];
    self.sureBtn.layer.cornerRadius = self.sureBtn.ly_height * 0.5;
    [self.moneyView addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.isHavePayType = NO;
}
- (IBAction)chosePayType:(id)sender {
    QMUIModalPresentationViewController *diaVC = [[QMUIModalPresentationViewController alloc] init];
    self.withdrawTypeModal = diaVC;
    diaVC.contentViewMargins = UIEdgeInsetsMake(SCREEN_HEIGHT - 390, 0, 0, 0);
    KDChosePayTypeView *typeView = [[KDChosePayTypeView alloc] initWithFrame:self.view.bounds];
    diaVC.contentView = typeView;
    typeView.bankName = self.selectName;
    [diaVC showWithAnimated:YES completion:nil];
    
    __weak typeof(self) weakSelf = self;
    typeView.callBack = ^(KDChosePayTypeModel * _Nonnull choseModel, NSString *selectName) {
        [diaVC hideWithAnimated:YES completion:^(BOOL finished) {
            weakSelf.selectName = selectName;
            weakSelf.topViewHigCons.constant = 60;
            weakSelf.isHavePayType = YES;
            [weakSelf.view updateConstraints];
            
            for (UIView *view in weakSelf.topView.subviews) {
                [view removeFromSuperview];
            }
            
            KDProvisionsTopView *topView = [[KDProvisionsTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
            [weakSelf.topView addSubview:topView];
            topView.model = choseModel;
            
            [weakSelf setSureBtnColor];
        }];
    };
}
- (void)changedTextField:(UITextField *)textField
{
    if (textField.text.floatValue >0) {
        [self setSureBtnColor];
    }
}
- (void)setSureBtnColor
{
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = self.sureBtn.ly_height * 0.5;
    if (self.moneyView.text.floatValue > 0 && self.isHavePayType) {
        self.sureBtn.enabled = YES;
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,self.sureBtn.ly_width,self.sureBtn.ly_height);
        gl.startPoint = CGPointMake(0.53, 0);
        gl.endPoint = CGPointMake(0.53, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:204/255.0 green:162/255.0 blue:100/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:170/255.0 green:115/255.0 blue:34/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [self.sureBtn.layer insertSublayer:gl atIndex:0];
    } else {
        self.sureBtn.enabled = NO;
        [self.sureBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#D9D9D9"]];
    }
}
- (IBAction)sureBtnAction:(UIButton *)sender {
    
}



@end
