//
//  CommonEncourageVC.m
//  Project
//
//  Created by 熊凤伟 on 2018/3/20.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "CommonEncourageVC.h"

/** 转盘宽度 */
static const CGFloat roundW = 300;

@interface CommonEncourageVC ()<CAAnimationDelegate>

/** 转盘 */
@property (nonatomic, weak) UIImageView *roundImageView;
/** 转动按钮 */
@property (nonatomic, weak) UIButton *animateButton;

@end

@implementation CommonEncourageVC

#pragma mark --- LIFE
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 主界面
    [self setupMainView];
}
#pragma mark --- SET UP VIEW
//------ 主界面 ------//
- (void)setupMainView {
    
    // 0. 初始值
    [self setNavigationBarHidden];
    
//    self.navigationItem.title = @"";
//    [self setupNavViewWithColor:[UIColor clearColor] canBack:YES];
    
    // 1. 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundImageView.image = [UIImage mc_imageNamed:@"zhuanpan_image"];
    [self.view addSubview:backgroundImageView];
    // 2. 转盘
    UIImageView *roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - roundW) / 2, (SCREEN_HEIGHT-roundW)/2-Ratio(40), roundW, roundW)];
    roundImageView.image = [UIImage mc_imageNamed:@"common_encourage_round"];
    [self.view addSubview:roundImageView];
    self.roundImageView = roundImageView;
    // 箭头
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 40) / 2, (roundImageView.ly_height - 50) / 2 + roundImageView.ly_y, 40, 50)];
    arrowImageView.image = [UIImage mc_imageNamed:@"common_encourage_arrow"];
    [self.view addSubview:arrowImageView];
    // 转动按钮
    UIButton *animateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    animateButton.frame = arrowImageView.frame;
    [animateButton addTarget:self action:@selector(animateButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:animateButton];
    self.animateButton = animateButton;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, NavigationBarHeight, 44, 44);
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
}
- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- TARGET METHOD
/// 1. 转动按钮点击事件
- (void)animateButtonAction {
    
    self.animateButton.userInteractionEnabled = NO;
    [self addAnimation];
}

#pragma mark --- DELEGATE
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    self.animateButton.userInteractionEnabled = YES;
    
    // 请求数据
    [self requestDataForMessage];
}

#pragma mark --- PRIVATE METHOD
/// 1. 转动
- (void)addAnimation {
    
    CGFloat angle = M_PI * 15 + M_PI * ((double)arc4random() / 0x100000000);
    
    CABasicAnimation *layer = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    layer.toValue = @(angle);
    layer.duration = 6;
    layer.removedOnCompletion = NO;
    layer.fillMode = kCAFillModeForwards;
    layer.repeatCount = 0;
    layer.delegate = self;
    
    [self.roundImageView.layer addAnimation:layer forKey:nil];
}
#pragma mark LOAD DATA
/// 1. 请求抽奖数据
#pragma mark --- 请求数据 ------------------
- (void)requestDataForMessage {
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"/facade/app/red/payment/%@", TOKEN];
    [[MCSessionManager shareManager] mc_GET:url parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"000000"]) {
            [weakSelf showAlertWithMessage:[NSString stringWithFormat:@"获得%@", resp.result]];
        }else {
            [weakSelf showAlertWithMessage:[NSString stringWithFormat:@"%@", resp.messege]];
        }
    }];
}

@end
