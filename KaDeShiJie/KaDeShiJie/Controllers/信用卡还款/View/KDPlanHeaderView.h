//
//  KDPlanHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDPlanHeaderViewDelegate <NSObject>

- (void)planHeaderViewDelegateWithOpenType:(BOOL)open;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KDPlanHeaderView : UIView
@property (nonatomic, assign) BOOL open;
@property (nonatomic, weak) id <KDPlanHeaderViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
