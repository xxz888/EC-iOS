//
//  MCPayPWDInputView.h
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@protocol MCPayPWDInputViewDelegate <NSObject>

- (void)payPWDInputViewDidCommited:(NSString *)pwd ;

@end

@interface MCPayPWDInputView : UIView

@property(nonatomic, weak) id<MCPayPWDInputViewDelegate> delegate;

@property(nonatomic, strong) QMUIModalPresentationViewController *modal;

@end

NS_ASSUME_NONNULL_END
