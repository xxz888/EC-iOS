//
//  MCTiXianAlertView.h
//  OEMSDK
//
//  Created by apple on 2021/4/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCTiXianAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
- (IBAction)closeAction:(id)sender;
@property(nonatomic,strong)QMUIModalPresentationViewController * presentView;

@end

NS_ASSUME_NONNULL_END
