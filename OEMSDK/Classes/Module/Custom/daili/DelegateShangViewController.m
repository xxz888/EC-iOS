//
//  DelegateShangViewController.m
//  Project
//
//  Created by liuYuanFu on 2019/8/15.
//  Copyright © 2019 LY. All rights reserved.
//

#import "DelegateShangViewController.h"
#import "DLSTextView.h"

@implementation DelegateShangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /* 初始化 */
    [self setNavigationBarTitle:@"代理商入口" tintColor:MAINCOLOR];
    self.mc_tableview.tableHeaderView = [DLSTextView newFromNib];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];   
}


@end
