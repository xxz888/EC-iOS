//
//  MCQuestionViewController.m
//  MCOEM
//
//  Created by SS001 on 2020/4/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCQuestionViewController.h"
#import "MCQuestionDelegate.h"
#import "MCQuestionDataSource.h"
#import "MCQuestionModel.h"

@interface MCQuestionViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MCQuestionDataSource *dataSource;
@property (nonatomic, strong) MCQuestionDelegate *delegate;
@property (nonatomic, strong) MCQuestionModel *model;
@end

@implementation MCQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"常见问题";
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.font = [UIFont qmui_dynamicSystemFontOfSize:18 weight:QMUIFontWeightNormal italic:YES];
    titleView.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleView;
//    [self setNavigationBarTitle:@"常见问题" tintColor:[UIColor whiteColor]];
    
    self.dataSource = [[MCQuestionDataSource alloc] init];
    self.delegate = [[MCQuestionDelegate alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTopConstant, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTopConstant) style:UITableViewStylePlain];
    _tableView.dataSource = self.dataSource;
    _tableView.delegate = self.delegate;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    self.model = [[MCQuestionModel alloc] init];
    [self.model requestDataWithCallBack:^(NSArray * _Nonnull array) {
        self.dataSource.data = array;
        self.delegate.data = array;
        [self.tableView reloadData];
    }];
}

@end
