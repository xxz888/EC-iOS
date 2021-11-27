//
//  MCHomeServiceViewController.h
//  OEMSDK
//
//  Created by apple on 2020/11/25.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCHomeServiceViewController : MCBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *zhituiPhoneLbl;
@property (weak, nonatomic) IBOutlet UIButton *zhituiTelBtn;
- (IBAction)zhituiTelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
- (IBAction)kefuAction:(id)sender;
- (IBAction)guanfangkefuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *kefuImv;
@property (weak, nonatomic) IBOutlet UIView *kefuView;
@property (weak, nonatomic) IBOutlet UILabel *liuyanbanMessageLbl;
@property (weak, nonatomic) IBOutlet UIView *liuyanbanView;

@end

NS_ASSUME_NONNULL_END
