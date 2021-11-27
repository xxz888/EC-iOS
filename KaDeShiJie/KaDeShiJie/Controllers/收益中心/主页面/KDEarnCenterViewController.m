//
//  KDEarnCenterViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDEarnCenterViewController.h"
#import "KDEarnCenterHeaderView.h"

@interface KDEarnCenterViewController ()

@end

@implementation KDEarnCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    KDEarnCenterHeaderView *header = [[KDEarnCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mc_tableview.tableHeaderView = header;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [header reloadData];
//    }];
    
    [self setNavigationBarTitle:@"收益中心" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"收益规则" forState:UIControlStateNormal];
    shareBtn.layer.cornerRadius = 11;
    [shareBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
}

- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightBtnAction
{
    [MCPagingStore pushWebWithTitle:@"收益规则" classification:@"功能跳转"];
}
@end
