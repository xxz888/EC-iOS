//
//  MCBase.h
//  LocalPodDemo
//
//  Created by wza on 2020/6/23.
//  Copyright © 2020 MingChe. All rights reserved.
//  导入的头文件可以暴露给外面，也可以供sdk内部使用，作用类似pch

#ifndef MCBase_h
#define MCBase_h

#pragma mark - System
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




#pragma mark - Pods
#import <QMUIKit/QMUIKit.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <MJExtension/MJExtension.h>
#import <MGJRouter/MGJRouter.h>
#import <iCarousel/iCarousel.h>
#import <SDWebImage/SDWebImage.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <LYEmptyView/LYEmptyViewHeader.h>

#pragma mark - Base
#import "KD_Utils.h"
#import "MCNavigationController.h"
#import "MCBaseViewController.h"
#import "MCTabBarViewController.h"
#import "MCAppDelegate.h"
#import "MCTabBarViewController.h"

#pragma mark - Tool
#import "MCBrandConfiguration.h"
#import "MCModelStore.h"
#import "MCImageStore.h"
#import "MCSessionManager.h"
#import "MCNetPublic.h"
#import "MCPagingStore.h"
#import "MCStoreHeader.h"
#import "MCPayStore.h"
#import "MCCategories.h"
#import "MCGradeName.h"


#pragma mark - Component
#import "MCTabBarModel.h"
#import "MCToast.h"
#import "MCAlertStore.h"
#import "MCUpdateAlertView.h"
#import "MCLoading.h"
#import "MCChoosePayment.h"
#import "MCEmptyView.h"
#import "MCBannerView.h"

#pragma mark - 组件化
#import "MCCustomMenuView.h"  // 主副功能区
#import "MCRunLightView.h"    //跑马灯
#import "MCTitleCustomView.h" //标题和竖条颜色
#import "MCSafeCustomView.h"  //保险
#import "MCNewsView.h"        //资讯
#import "MCGradientView.h"
#import "MCDataProfessor.h"
#import "MCMenuItemView.h"
#import "MCMenuManager.h"
#import "MCUserHeaderView.h"

#pragma mark - Module
#import "MCModuleHeader.h"









#pragma mark - 宏定义
//  Macro
#ifdef DEBUG
# define MCLog(...) NSLog(@"[🐸%s,L:%d🐸]:\n%@",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__]);
#else
# define MCLog(...);
#endif


#pragma mark - 老项目
/** RGB */
#define LYColor(r,g,b) [UIColor colorWithRed:(r)/225.0 green:(g)/225.0 blue:(b)/225.0 alpha:1.0]
#define LYFont(s)                     [UIFont systemFontOfSize:s]
#define LY_TabbarSafeBottomMargin          (LY_iPhoneX ? 34.f : 0.f)
#define LY_iPhoneX                         [UIApplication sharedApplication].statusBarFrame.size.height == 44

//以375的比例
#define MCSCALE SCREEN_WIDTH/375

#define Ratio(w)                ([UIScreen mainScreen].bounds.size.width/375)*w

// maincolor
#define MAINCOLOR MCModelStore.shared.brandConfiguration.color_main
// 当前正在展示的controller
#define MCLATESTCONTROLLER MCModelStore.shared.appInfo.latestController

#define TOKEN MCModelStore.shared.userDefaults.token


#endif /* MCBase_h */
