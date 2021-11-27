//
//  KDCreditAlertView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDCreditAlertView : UIView
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) void (^cancelBtnAction)(void);
@property (nonatomic, copy) void (^sureBtnAction)(void);
@end

NS_ASSUME_NONNULL_END
