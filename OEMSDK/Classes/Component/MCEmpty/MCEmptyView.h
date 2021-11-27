//
//  MCEmptyView.h
//  MCOEM
//
//  Created by yujia tian on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <LYEmptyView/LYEmptyView.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCEmptyView : LYEmptyView

+ (instancetype)emptyView;

+ (instancetype)emptyViewWithKDTitle:(NSString *)title;

+ (instancetype)emptyViewWithKDDelegateTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
