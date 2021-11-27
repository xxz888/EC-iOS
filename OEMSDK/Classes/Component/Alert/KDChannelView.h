//
//  KDChannelView.h
//  OEMSDK
//
//  Created by apple on 2020/12/14.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^CloseActionBlock)(void);
typedef void(^SendBtnActionBlock)(void);
typedef void(^BindBtnActionBlock)(void);

@interface KDChannelView : UIView
- (IBAction)closeAction:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *codeTf;
- (IBAction)closeAction:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)codeAction:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *bindChannelBtn;
- (IBAction)bindChannelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property(nonatomic,copy)CloseActionBlock closeActionBlock;
@property(nonatomic,copy)SendBtnActionBlock sendBtnActionBlock;
@property(nonatomic,copy)BindBtnActionBlock bindBtnActionBlock;

@end

NS_ASSUME_NONNULL_END
