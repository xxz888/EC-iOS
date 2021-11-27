//
//  MCBaseViewController.h
//  MCOEM
//
//  Created by wza on 2020/3/6.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "MCSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

/*
 *
 */
@interface MCBaseViewController : QMUICommonViewController

//若需要隐藏导航栏，请使用setNavigationBarHidden
@property (nonatomic, assign) BOOL mc_nav_hidden;

/// 自带tableview，处理了下拉刷新
@property (nonatomic, strong) QMUITableView *mc_tableview;
/// 顶部导航标题视图
@property (nonatomic, strong) QMUINavigationTitleView *mc_titleview;
/// 需要用到下拉刷新时请使用这个来创建请求任务
@property(nonatomic, strong) MCSessionManager *sessionManager;

/// 设置导航栏标题、颜色
/// @param title 标题
/// @param color 颜色 默认白色
- (void)setNavigationBarTitle:(nullable NSString *)title tintColor:(nullable UIColor *)color;

/// 设置导航栏标题、背景图片
/// @param title 标题
/// @param image 背景图片
- (void)setNavigationBarTitle:(nullable NSString *)title backgroundImage:(nullable UIImage *)image;

/// 设置导航栏隐藏
- (void)setNavigationBarHidden;


/// 用于重写tableview位置
- (void)layoutTableView;


/// return _mc_tablevie
- (QMUITableView *)getMCTableView;


//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText:(UIButton *)codeBtn;


#pragma mark --- 提示框(TODO::优化)
- (void)showAlertWithMessage:(nullable NSString *)message;

- (void)showAlertWithMessage:(nullable NSString*)message title:(nullable NSString*)title sureHandler:(nullable void (^)(UIAlertAction *action))sureHandler;

- (void)showAlertWithMessage:(nullable NSString*)message title:(nullable NSString*)title cancelTitle:(nullable NSString *)cancel sureTitle:(nullable NSString *)sure cancelHandler:(nullable void (^)(UIAlertAction *action))cancelHandler sureHandler:(nullable void (^)(UIAlertAction *action))sureHandler;


@end

NS_ASSUME_NONNULL_END
