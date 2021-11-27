//
//  KDMineViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDMineViewController.h"
#import "KDMineHeaderView.h"
#import "MCUserHeaderView.h"
@interface KDMineViewController ()
@property (nonatomic, strong) KDMineHeaderView *header;
@end

@implementation KDMineViewController

- (KDMineHeaderView *)header
{
    if (!_header) {
        _header = [[KDMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight)];
    }
    return _header;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [self reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadBannerImage" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mc_tableview.tableHeaderView = self.header;
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    
    [self setNavigationBarTitle:@"我的" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
}

- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop - TabBarHeight);
}
- (void)reloadData {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
    // 头部数据
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        if ([self.mc_tableview.mj_header isRefreshing]) {
            [self.mc_tableview.mj_header endRefreshing];
        }
        
        SharedUserInfo = userInfo;
        self.header.nameLabel.text = SharedUserInfo.nickname || SharedUserInfo.nickname.length != 0 ? SharedUserInfo.nickname :SharedUserInfo.realname;
        
//        NSString *firstName = [userInfo.realname substringWithRange:NSMakeRange(0, 1)];
//        if (userInfo.realname.length == 2) {
//            self.header.nameLabel.text = [NSString stringWithFormat:@"%@*", firstName];
//        } else {
//            NSString *lastName = [userInfo.realname substringFromIndex:userInfo.realname.length-1];
//            self.header.nameLabel.text = [NSString stringWithFormat:@"%@*%@", firstName, lastName];
//        }
        NSString *first = [userInfo.phone substringWithRange:NSMakeRange(0, 3)];
        NSString *last = [userInfo.phone substringWithRange:NSMakeRange(7, 4)];
        self.header.phoneLabel.text = [NSString stringWithFormat:@"%@****%@", first, last];
        self.header.idLabel.text = [NSString stringWithFormat:@"ID：%@", userInfo.userid];


        [self.header getUserGradeName];
        
        MCUserHeaderView * mcUserHeaderView = [self.header viewWithTag:2001];
        [mcUserHeaderView fetchHeaderPath];
    }];
}

@end
