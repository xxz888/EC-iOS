//
//  MCCashierController.m
//  MCOEM
//
//  Created by wza on 2020/5/4.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCCashierController.h"
#import "MCCashierHeader.h"


@interface MCCashierController ()

@property(nonatomic, strong) MCCashierHeader *header ;

@end

@implementation MCCashierController

- (MCCashierHeader *)header {
    if (!_header) {
        _header = [MCCashierHeader newFromNib];
    }
    return _header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarHidden];
     
    self.mc_tableview.tableHeaderView = self.header;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.header requestDefaultCards];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.header.height = SCREEN_HEIGHT-(self.hidesBottomBarWhenPushed?0:TabBarHeight)-2;
}

- (void)layoutTableView {
    self.mc_tableview.frame = CGRectMake(0, -StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT+StatusBarHeight-(self.hidesBottomBarWhenPushed?0:TabBarHeight));
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
