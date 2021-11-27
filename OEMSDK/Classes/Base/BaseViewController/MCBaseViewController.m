//
//  MCBaseViewController.m
//  MCOEM
//
//  Created by wza on 2020/3/6.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"
#import <JAnalytics/JANALYTICSService.h>


@interface MCBaseViewController () <MCSessionManagerDelegate>

@property (nonatomic, strong) UIColor *mc_nav_color;
@property (nonatomic, strong) UIImage *mc_nav_img;

@property (nonatomic, strong) UIImageView * navBarHairlineImageView;

@end

@implementation MCBaseViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navBarHairlineImageView.hidden = NO;
}

- (instancetype)init
{
    NSBundle *bundle = [NSBundle wg_subBundleWithBundleName:@"OEMSDK" targetClass:[self class]];
    
    NSString *nibPath = [bundle pathForResource:NSStringFromClass([self class]) ofType:@"nib"];
    
    
    
    if (nibPath) {  //判断是否有xib文件，有则重写init方法
        self = [super initWithNibName:NSStringFromClass([self class]) bundle:bundle];
    } else {
        self = [super init];
    }
    
    
    
    if (self) {
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutTableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWhite;
    
    if (![self isKindOfClass:[MCWebViewController class]]) {
        MCModelStore.shared.appInfo.latestController = self;
    }
    
    [self.navigationController.navigationBar setShadowImage:nil];
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if (view.ly_height <= 1) {
            view.hidden = YES;
        }
    }
//    UIView *navBottomLine = backgroundView.subviews.firstObject;
//    if (navBottomLine.height <= 1) {
//        navBottomLine.hidden = YES;
//    }
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

 - (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self isKindOfClass:[MCWebViewController class]]) {
        MCModelStore.shared.appInfo.latestController = self;
    }
    self.navBarHairlineImageView.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated {
    NSString *page_tag = nil;
    if (self.title) {
        page_tag = self.title;
    } else {
        page_tag = NSStringFromClass([self class]);
    }
    [JANALYTICSService startLogPageView:page_tag];
    [super viewDidAppear:animated];
    MCModelStore.shared.appInfo.latestController = self;
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:NSStringFromClass([self class])];
    [super viewDidDisappear:animated];
}
- (void)setNavigationBarTitle:(NSString *)title tintColor:(UIColor *)color {
    self.mc_nav_color = color ?: UIColorWhite;
    if (title && title.length > 0) {
        self.mc_titleview.title = title;
        self.navigationItem.titleView = self.mc_titleview;
    }
    self.navigationItem.title = title;
    [self updateNavigationBarAppearance];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)setNavigationBarTitle:(NSString *)title backgroundImage:(UIImage *)image {
    
    self.mc_nav_img = image;
    if (title && title.length > 0) {
        self.mc_titleview.title = title;
        self.navigationItem.titleView = self.mc_titleview;
    }
    [self updateNavigationBarAppearance];
    [self setNeedsStatusBarAppearanceUpdate];
}

/// 导航栏背景色
- (UIColor *)navigationBarBarTintColor {
    return self.mc_nav_color;
}

/// 导航栏背景图片
- (UIImage *)navigationBarBackgroundImage {
    return self.mc_nav_img;
}

/// 导航栏前景色（文字和返回箭头）
- (UIColor *)navigationBarTintColor {
    
    if (self.mc_nav_img) {  //背景是图片，白色
        return [UIColor whiteColor];
    } else if (self.mc_nav_color) {
        BOOL equelW = CGColorEqualToColor(self.mc_nav_color.CGColor, [UIColor whiteColor].CGColor);
        BOOL equelWW = CGColorEqualToColor(self.mc_nav_color.CGColor, UIColorWhite.CGColor);
        if (equelW || equelWW) {
            return [UIColor qmui_colorWithHexString:@"#121212"];
        } else {
            return [UIColor whiteColor];
        }
    } else {
        return [UIColor qmui_colorWithHexString:@"#121212"];
    }
    
    
}
- (void)setNavigationBarHidden {
    self.mc_nav_hidden = YES;
    [self updateNavigationBarAppearance];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.mc_nav_img) {  //背景是图片，白色
        return UIStatusBarStyleLightContent;
    } else if (self.mc_nav_color) {
        BOOL equelW = CGColorEqualToColor(self.mc_nav_color.CGColor, [UIColor whiteColor].CGColor);
        BOOL equelWW = CGColorEqualToColor(self.mc_nav_color.CGColor, UIColorWhite.CGColor);
        if (equelW || equelWW) {
            return UIStatusBarStyleDefault;
        } else {
            return UIStatusBarStyleLightContent;
        }
    } else {
        return UIStatusBarStyleDefault;
    }
}

/// 隐藏导航栏
- (BOOL)preferredNavigationBarHidden {
    return self.mc_nav_hidden;
}
- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}
- (QMUITableView *)mc_tableview {
    if (!_mc_tableview) {
        _mc_tableview = [[QMUITableView alloc] initWithFrame:self.view.bounds];
        _mc_tableview.showsHorizontalScrollIndicator = NO;
        _mc_tableview.showsVerticalScrollIndicator = NO;
        
        _mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mc_tableviewRefresh)];
        [self.view addSubview:_mc_tableview];
        

    }
    return _mc_tableview;
}
- (void)mc_tableviewRefresh {
    if (!_sessionManager) {
        [_mc_tableview.mj_header endRefreshing];
    } else {
        [_sessionManager mc_reloadTasks];
    }
}
- (QMUINavigationTitleView *)mc_titleview {
    if (!_mc_titleview) {
        _mc_titleview = [[QMUINavigationTitleView alloc] initWithStyle:QMUINavigationTitleViewStyleDefault];
    }
    return _mc_titleview;
}

- (MCSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [MCSessionManager manager];
        _sessionManager.delegate = self;
    }
    return _sessionManager;
}
- (void)dealloc
{
//    MCLog(@"%@ dealloc", NSStringFromClass([self class]));
}
#pragma mark - MCSessionManagerDelegate

- (void)mc_session:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveResponse:(id)response {
    if (_sessionManager.tasks.count == 0 && _mc_tableview.mj_header.isRefreshing) {
        [_mc_tableview.mj_header endRefreshing];
    }
}
- (void)layoutTableView {
    BOOL shouldChangeTableViewFrame = !CGRectEqualToRect(self.view.bounds, _mc_tableview.frame);
    if (shouldChangeTableViewFrame) {
        _mc_tableview.qmui_frameApplyTransform = self.view.bounds;
    }
}

- (QMUITableView *)getMCTableView {
    return _mc_tableview;
}


#pragma mark --- 提示框
- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
    [alertVC addAction:cancelAC];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)showAlertWithMessage:(NSString*)message title:(NSString*)title sureHandler:(void (^)(UIAlertAction *action))sureHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:sureHandler];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showAlertWithMessage:(NSString*)message title:(NSString*)title cancelTitle:(NSString *)cancel sureTitle:(NSString *)sure cancelHandler:(void (^)(UIAlertAction *action))cancelHandler sureHandler:(void (^)(UIAlertAction *action))sureHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:(UIAlertActionStyleDestructive) handler:cancelHandler];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:sureHandler];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText:(UIButton *)codeBtn{
    __block NSInteger second = 60;
    // 全局队列 默认优先级
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 定时器模式 事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // NSEC_PER_SEC是秒 *1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                [codeBtn setTitle:[NSString stringWithFormat:@"%lds", second] forState:UIControlStateNormal];
                [codeBtn setUserInteractionEnabled:NO];
                second--;
            }else {
                dispatch_source_cancel(timer);
                [codeBtn setTitle:@"重新发送" forState:(UIControlStateNormal)];
                [codeBtn setUserInteractionEnabled:YES];
            }
        });
    });
    // 启动源
    dispatch_resume(timer);
}
@end
