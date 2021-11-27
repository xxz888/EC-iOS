//
//  KDTTFJiaoYiViewController.h
//  OEMSDK
//
//  Created by apple on 2020/11/28.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDTTFJiaoYiViewController : MCBaseViewController
@property (nonatomic, strong) MCBankCardModel *cardModel;
@property (nonatomic, strong) MCCustomModel   * extendModel;

- (instancetype)initWithClassification:(MCBankCardModel *)cardModel extend:(MCCustomModel *)extendModel;
@property (nonatomic, strong) NSString *money;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *validityLabel;
@property (weak, nonatomic) IBOutlet UILabel *safeCodeLabel;
@property(nonatomic, copy) NSString *orderCode;//订单order
@property(nonatomic, copy) NSString *provinceCode;//省code
@property(nonatomic, copy) NSString *incitycode;//市code
@property(nonatomic, copy) NSString *mcccode;//商户code

@property(nonatomic, copy) NSString *bindcardmessageid;//验证码id
@property (weak, nonatomic) IBOutlet UIView *shengView;
@property (weak, nonatomic) IBOutlet UIView *shiView;
@property (weak, nonatomic) IBOutlet UILabel *shengLbl;
@property (weak, nonatomic) IBOutlet UILabel *shiLbl;
@property (weak, nonatomic) IBOutlet UIView *shanghuView;
@property (weak, nonatomic) IBOutlet UILabel *shanghuLbl;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)codeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *codeView;

@property (weak, nonatomic) IBOutlet UIView *yanzhengmaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * stackViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@end

NS_ASSUME_NONNULL_END
