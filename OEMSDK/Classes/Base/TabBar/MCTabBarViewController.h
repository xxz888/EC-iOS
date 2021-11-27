//
//  MCTabBarViewController.h
//  MCOEM
//
//  Created by wza on 2020/3/6.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCTabBarViewController : QMUITabBarViewController
- (void)setupChilds;
@property(nonatomic, readonly) NSUInteger preSelectedIndex;//上次选中的index

@end

NS_ASSUME_NONNULL_END
