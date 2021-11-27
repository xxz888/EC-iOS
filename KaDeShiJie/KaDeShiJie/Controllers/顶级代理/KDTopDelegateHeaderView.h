//
//  KDTopDelegateHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDTopDelegateHeaderViewDelegate <NSObject>

- (void)topDelegateHeaderViewSearchText:(NSString *)text;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KDTopDelegateHeaderView : UIView

@property (nonatomic, weak) id<KDTopDelegateHeaderViewDelegate>delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
