//
//  KDPayJianQuanViewController.h
//  OEMSDK
//
//  Created by apple on 2020/11/28.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDPayJianQuanViewController : MCBaseViewController
@property (nonatomic, strong) MCBankCardModel *cardModel;
@property (nonatomic, strong) MCCustomModel   * extendModel;//TTFPay_QUICK 统统付     kongkahuankuan_jianquan空卡鉴权 yuehuankuan_jianquan信用卡鉴权

- (instancetype)initWithClassification:(MCBankCardModel *)cardModel extend:(MCCustomModel *)extendModel;


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *validityLabel;
@property (weak, nonatomic) IBOutlet UILabel *safeCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;


@end

NS_ASSUME_NONNULL_END
