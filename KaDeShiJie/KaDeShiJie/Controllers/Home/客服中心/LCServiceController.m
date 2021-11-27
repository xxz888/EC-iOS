//
//  LCServiceController.m
//  Lianchuang_477
//
//  Created by wza on 2020/8/19.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "LCServiceController.h"
#import <OEMSDK/OEMSDK.h>
#import <OEMSDK/MCQuestionViewController.h>
#import <OEMSDK/MCFeedBackController.h>
#import "LCServiceCell.h"

@interface LCServiceController () <QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, copy) NSArray<NSDictionary *> *dataSource;

@end

@implementation LCServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHidden];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorInset = UIEdgeInsetsMake(0, 36, 0, 16);
    self.mc_tableview.mj_header = nil;
    self.mc_tableview.rowHeight = 65;
    self.mc_tableview.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.mc_tableview.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"LCKFTableHeader" owner:nil options:nil].lastObject;
    
    self.dataSource = @[
        @{@"img":[UIImage imageNamed:@"lc_kf_0"],@"title":@"在线客服"},
        @{@"img":[UIImage imageNamed:@"lc_kf_1"],@"title":@"电话客服"},
        @{@"img":[UIImage imageNamed:@"lc_kf_3"],@"title":@"投诉建议"}
    ];
    [self.mc_tableview reloadData];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"联系我们";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LCServiceCell cellFromTableview:tableView data:self.dataSource[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [MCServiceStore pushMeiqiaVC];
    }
    if (indexPath.row == 1) {
        [MCServiceStore callBrand];
    }
//    if (indexPath.row == 2) {
//        [MCServiceStore jumpWeixin];
//    }
    if (indexPath.row == 2) {
        [self.navigationController pushViewController:[MCFeedBackController new] animated:YES];
    }
    if (indexPath.row == 3) {
        [self.navigationController pushViewController:[MCQuestionViewController new] animated:YES];
    }
}

@end
