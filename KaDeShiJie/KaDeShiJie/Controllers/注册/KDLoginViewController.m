//
//  KDLoginViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDLoginViewController.h"
#import "KDLoginHeaderView.h"
#import "KDWebContainer.h"

@interface KDLoginViewController ()

@end

@implementation KDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden];
    
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    KDLoginHeaderView *headView = [[KDLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mc_tableview.tableHeaderView = headView;
    self.mc_tableview.mj_header = nil;
    self.mc_tableview.mj_footer = nil;
    self.mc_tableview.bounces = NO;
    
    // 请求个人信息，判断token
    
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {

            if ([userInfo.realnameStatus integerValue] == 1 && [userInfo.verificationStatus integerValue] == 0) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRSTSHIMING"];
            }
            if ([userInfo.realnameStatus integerValue] != 1) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRSTWEISHIMING"];
            }
            [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];

    //        [[KDLoginTool shareInstance] getChuXuCardData:YES];
    //        if (userInfo.realnameStatus.intValue == 1) {
    //            [KDWebContainer.shared setupContainer];
    //            // 获取默认卡
    //            [[KDLoginTool shareInstance] getChuXuCardData:NO];
    //        } else {
    //            [MCLATESTCONTROLLER.navigationController pushViewController:[MGJRouter objectForURL:rt_card_vc1] animated:YES];
    //        }
            
            // 5.绑定推送别名
            NSString *userid = [NSString stringWithFormat:@"%@",userInfo.userid];
            [MCApp setJPushAlias:userid];
            [MCApp setJAnalyticsIdentifyAccount:userInfo];
            
            
        }];
    });

    
}


@end
