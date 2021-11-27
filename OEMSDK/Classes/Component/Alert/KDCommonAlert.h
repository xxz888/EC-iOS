//
//  KDCommonAlert.h
//  OEMSDK
//
//  Created by apple on 2020/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LeftActionBlock)(void);
typedef void(^RightActionBlock)(void);
typedef void(^MiddleActionBlock)(void);

@interface KDCommonAlert : UIView
@property (weak, nonatomic) IBOutlet UIImageView *alertImv;
@property (weak, nonatomic) IBOutlet UIView *twoBtnView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *alertContent;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeAction:(id)sender;
- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;
@property(nonatomic,copy)LeftActionBlock leftActionBlock;
@property(nonatomic,copy)RightActionBlock rightActionBlock;
@property(nonatomic,copy)MiddleActionBlock middleActionBlock;
@property(nonatomic,strong)QMUIModalPresentationViewController * qmuiAlter;
-(void)initKDCommonAlertContent:(NSString *)content isShowClose:(BOOL)isShowClose;
@end

NS_ASSUME_NONNULL_END
