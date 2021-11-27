//
//  MCSignViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/16.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCSignViewController.h"
#import "MCSignHeader.h"
#import "CalendarShowView.h"
#import "WSShadowWithCustomView.h"

@interface MCSignViewController ()

@end

@implementation MCSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"签到" tintColor:MAINCOLOR];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"签到记录" target:self action:@selector(signHistory:)];
    MCSignHeader *header = [MCSignHeader newFromNib];
    self.mc_tableview.tableHeaderView = header;
    
    header.qmui_height = SCREEN_HEIGHT - NavigationContentTop;
    
    [self setNavigationBarTitle:@"签到" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    
}
- (void)signHistory:(UIBarButtonItem *)sender {
    CalendarShowView * calendar = [[CalendarShowView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 420)];
    calendar.qmui_centerY = self.view.qmui_centerY;
    calendar.viewTouch = ^{
        [WSShadowWithCustomView hideShadow];
    };
    [WSShadowWithCustomView showShadow:calendar withAlpha:0.5 withClips:5 withFram:CGRectMake(10, 80, SCREEN_WIDTH-20,420)];
}




@end
