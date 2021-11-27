//
//  KDRegisterViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDRegisterViewController.h"
#import "KDRegisterHeaderView.h"

@interface KDRegisterViewController ()

@end

@implementation KDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    KDRegisterHeaderView *headView = [[KDRegisterHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mc_tableview.tableHeaderView = headView;
    self.mc_tableview.mj_header = nil;
    self.mc_tableview.mj_footer = nil;
    self.mc_tableview.bounces = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [self.view addSubview:backBtn];
}

- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
