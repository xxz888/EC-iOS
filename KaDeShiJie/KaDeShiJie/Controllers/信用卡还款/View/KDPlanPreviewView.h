//
//  KDPlanPreviewView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDPlanPreviewViewDelegate <NSObject>

- (void)planPreviewViewWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KDPlanPreviewView : UIView
- (void)showView;
@property (nonatomic, weak) id <KDPlanPreviewViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
