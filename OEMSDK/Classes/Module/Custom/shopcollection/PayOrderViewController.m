//
//  PayOrderViewController.m
//  Project
//
//  Created by SS001 on 2019/11/30.
//  Copyright © 2019 LY. All rights reserved.
//

#import "PayOrderViewController.h"
#import "QRCodeInfoModel.h"
#import <OEMSDK.h>


@interface PayOrderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) QRCodeInfoModel *codeInfoModel;
@property (weak, nonatomic) IBOutlet UIImageView *choseAliImg;
@property (weak, nonatomic) IBOutlet UIImageView *choseWXImg;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
/** 备注 */
@property (weak, nonatomic) IBOutlet UITextView *markView;

@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation PayOrderViewController

- (UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.font = self.markView.font; //这里也可以设置和textView不同的font
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.textColor = [UIColor qmui_colorWithHexString:@"#888888"];
        _placeHolderLabel.text = @"添加备注";
        [_placeHolderLabel sizeToFit];
    }
    return _placeHolderLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"付款" tintColor:[UIColor whiteColor]];
    
    
    
//    UIImage *image = [[UIImage imageNamed:@"nav_left_blue"] imageWithColor:[UIColor darkGrayColor]];
//    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [button setImage:image forState:(UIControlStateNormal)];
//    [button setImage:image forState:(UIControlStateHighlighted)];
//    [button addTarget:self action:@selector(leftItemClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [button sizeToFit];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.payBtn.layer.cornerRadius = 8;
    self.payBtn.layer.masksToBounds = YES;
    self.choseAliImg.hidden = NO;
    
    self.markView.layer.cornerRadius = 5;
    self.markView.layer.masksToBounds = YES;
    [self.markView addSubview:self.placeHolderLabel];
    [self.markView setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
    
    [self getCodeInfo];
}

- (void)leftItemClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)getCodeInfo
{
    
    NSDictionary *params = @{@"payUrl":self.codeStr};
    NSString *url = @"/facade/app/get/gathering/qrcode";
    [self.sessionManager mc_POST:url parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        self.codeInfoModel = [QRCodeInfoModel mj_objectWithKeyValues:resp.result];
    }];
}

- (void)setCodeInfoModel:(QRCodeInfoModel *)codeInfoModel
{
    _codeInfoModel = codeInfoModel;
    
    NSString *receiveName = codeInfoModel.userNameReceived;
    NSString *firstName = [receiveName substringWithRange:NSMakeRange(0, 1)];
    NSString *name = @"";
    if (receiveName.length == 2) {
        name = [NSString stringWithFormat:@"%@*", firstName];
    } else if([receiveName isEqualToString:@"null"]){
        name = @"未实名";
    } else {
        name = [NSString stringWithFormat:@"%@**", firstName];
    }
    
    NSString *phone = codeInfoModel.phoneReceived;
    NSString *firstPhone = [phone substringWithRange:NSMakeRange(0, 3)];
    NSString *lastPhone = [phone substringWithRange:NSMakeRange(7, 4)];
    
    NSString *first = [NSString stringWithFormat:@"付款给%@ ", name];
    NSString *la = [NSString stringWithFormat:@"付款给%@ (%@****%@)", name, firstPhone, lastPhone];
    NSRange range = [la rangeOfString:first];
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:la];
    [atts addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#333333"] range:range];
    self.topLabel.attributedText = atts;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@", codeInfoModel.amount];
}

- (IBAction)aliPayBtnClick:(UIButton *)sender {
   self.choseAliImg.hidden = YES;
    self.choseWXImg.hidden = NO;
}
- (IBAction)clickWXPayBtn:(UIButton *)sender {
    self.choseAliImg.hidden = NO;
    self.choseWXImg.hidden = YES;
}

- (IBAction)createOrderBtn:(UIButton *)sender {
    
    sender.enabled = NO;
    [sender setBackgroundColor:[UIColor grayColor]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
        [sender setBackgroundColor:[UIColor qmui_colorWithHexString:@"#FF832F"]];
    });
    



//    amount
//    token
    MCWebViewController *web = [[MCWebViewController alloc] init];
    
    NSString *channe_tag;
    if (self.choseAliImg.isHidden) {
        channe_tag = @"ALI";
        web.title = @"支付宝";
    } else {
        channe_tag = @"WX";
        web.title = @"微信";
    }
    
    
    NSString *url = [[NSString stringWithFormat:@"%@v1.0%@?userId=%@&channe_tag=%@&order_desc=%@&amount=%.2f&token=%@", SharedConfig.pureHost, @"/facade/app/send/gathering/aliandwx", self.codeInfoModel.userIdReceived, channe_tag,@"商户收款", [self.codeInfoModel.amount doubleValue], TOKEN] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    web.urlString = [MCVerifyStore verifyURL:url];
    [MCLATESTCONTROLLER.navigationController pushViewController:web animated:YES];
}
@end
