//
//  KDRefundTimeView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDRefundTimeViewDelegate <NSObject>

- (void)refundTimeViewDelegateChangeTimeViewHig:(CGFloat)hig;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KDRefundTimeView : UIView
@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, weak) id<KDRefundTimeViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
