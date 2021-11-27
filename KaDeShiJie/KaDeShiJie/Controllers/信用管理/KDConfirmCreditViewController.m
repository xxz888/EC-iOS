//
//  KDConfirmCreditViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDConfirmCreditViewController.h"
#import "KDConfirmCreditHeaderView.h"

@interface KDConfirmCreditViewController ()

@end

@implementation KDConfirmCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F1F1F1"];
    [self setNavigationBarTitle:@"确认授信" tintColor:[UIColor whiteColor]];
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    KDConfirmCreditHeaderView *header = [[KDConfirmCreditHeaderView alloc] initWithFrame:CGRectZero];
    header.model = self.model;
    self.mc_tableview.tableHeaderView = header;
}

@end
