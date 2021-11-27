//
//  KDCancelCreditViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/18.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDCancelCreditViewController.h"
#import "KDCancelCreditHeaderView.h"

@interface KDCancelCreditViewController ()

@end

@implementation KDCancelCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F1F1F1"];
    [self setNavigationBarTitle:@"取消授信" tintColor:[UIColor whiteColor]];
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    KDCancelCreditHeaderView *header = [[KDCancelCreditHeaderView alloc] initWithFrame:CGRectZero];
    header.model = self.model;
    self.mc_tableview.tableHeaderView = header;
}

@end
