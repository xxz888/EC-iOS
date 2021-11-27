//
//  KDDirectPushHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDDirectPushHeaderViewDelegate <NSObject>

- (void)directPushHeaderViewChoseStatus:(NSString *)status;
- (void)directPushHeaderViewSearchText:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KDDirectPushHeaderView : UIView

@property (nonatomic, weak) id<KDDirectPushHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
