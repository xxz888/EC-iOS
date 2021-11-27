//
//  MCCashierKeyBoard.h
//  MCOEM
//
//  Created by wza on 2020/5/4.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol MCCashierKeyBoardDelegate <NSObject>

- (void)cashierKeyBoardDidClickOnTitle:(NSString *)title;

@end

@interface MCCashierKeyBoard : UIView

@property(nonatomic, weak) id <MCCashierKeyBoardDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
