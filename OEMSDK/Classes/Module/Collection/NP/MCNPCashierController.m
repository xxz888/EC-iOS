//
//  MCNPCashierController.m
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCNPCashierController.h"
#import "MCNPCashierHeader.h"

@interface MCNPCashierController ()<MCNPCashierHeaderDelegate>

@property(nonatomic, strong) MCNPCashierHeader *header;

@end

@implementation MCNPCashierController

- (MCNPCashierHeader *)header {
    if (!_header) {
        _header = [MCNPCashierHeader newFromNib];
        _header.delegate = self;
    }
    return _header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    
    [self setNavigationBarTitle:@"NP消费" tintColor:nil];
    self.mc_tableview.tableHeaderView = self.header;
    self.mc_tableview.backgroundColor = self.header.backgroundColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.header requestDefaultXinyong];
}

- (void)clickServiceOnLine
{
    if (self.serviceBlock) {
        self.serviceBlock();
    } else {
        [MCPagingStore pagingURL:rt_setting_service];
    }
}
@end
