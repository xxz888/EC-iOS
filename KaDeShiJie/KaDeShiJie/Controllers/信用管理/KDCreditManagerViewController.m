//
//  KDCreditManagerViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDCreditManagerViewController.h"
#import "KDCreditManagerHeaderView.h"

@interface KDCreditManagerViewController ()

@end

@implementation KDCreditManagerViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    KDCreditManagerHeaderView *header = [[KDCreditManagerHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mc_tableview.tableHeaderView = header;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setNavigationBarHidden];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"信用规则" forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor whiteColor]];
    shareBtn.layer.cornerRadius = 11;
    [shareBtn setTitleColor:UIColor.mainColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 84, StatusBarHeightConstant + 12, 94, 22);
    [self.view addSubview:shareBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"信用管理";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightBtnAction
{
    [MCPagingStore pushWebWithTitle:@"信用规则" classification:@"功能跳转"];
}
@end
