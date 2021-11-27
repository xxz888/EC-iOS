//
//  MCBrandInfo.m
//  MCOEM
//
//  Created by wza on 2020/3/4.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBrandConfiguration.h"



@implementation MCBrandConfiguration

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MCBrandConfiguration *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        
        //初始化
        instance.tab_iscenter = NO;
        instance.tab_selected_index = 0;
        
        instance.is_dairen_buy = NO;
        instance.is_bank_card_ocr = NO;
        instance.is_location_banner = NO;
        instance.is_guide_page = YES;
        instance.is_notify_sound = NO;
        instance.is_share_conin = NO;
        instance.color_main = [UIColor qmui_randomColor];
        instance.safe_title = @"账户安全";
        instance.api_version = @"v1.0";
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (NSString *)brand_company {
    if (!_brand_company) {
        return _brand_name;
    }
    return _brand_company;
}
- (void)registerURLPattern:(NSString *)url toObjectHandler:(MGJRouterObjectHandler)handler {
    [MGJRouter registerURLPattern:url toObjectHandler:handler];
}

+ (void)load {
    
    #pragma mark - 通知
    [MGJRouter registerURLPattern:rt_notice_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCMessageController new];
    }];
    
    #pragma mark - tabbar
    [MGJRouter registerURLPattern:rt_tabbar_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCTabBarViewController new];
    }];
    
    #pragma mark - 新闻分类
    [MGJRouter registerURLPattern:rt_news_list toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = routerParameters[MGJRouterParameterUserInfo];
        NSString *classification = info[@"classification"];
        return [[MCNewsListController alloc] initWithClassification:classification?:@"信用秘籍"];
    }];
    [MGJRouter registerURLPattern:rt_news_community toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCShequController new];
    }];
    [MGJRouter registerURLPattern:rt_news_operation toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCCaozuoController new];
    }];
    [MGJRouter registerURLPattern:rt_news_videos toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCVideoController new];
    }];
    
    #pragma mark - 分享
    [MGJRouter registerURLPattern:rt_share_single toObjectHandler:^id(NSDictionary *routerParameters) {
        return [[MCShareSingleImgViewController alloc] initWithImageType:MCShareSingleImageRed];
    }];
    [MGJRouter registerURLPattern:rt_share_many toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCShareManyViewController new];
    }];
    [MGJRouter registerURLPattern:rt_share_article toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCArticlesController new];
    }];
    
    
    #pragma mark - 团队
    [MGJRouter registerURLPattern:rt_team_overview toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCTeamController new];
    }];
    [MGJRouter registerURLPattern:rt_team_ranking toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCRateRankViewController new];
    }];
    
    #pragma mark - 用户
    [MGJRouter registerURLPattern:rt_user_info toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCUserInfoViewController new];
    }];
    [MGJRouter registerURLPattern:rt_user_realname toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCRealNameViewController new];
    }];
    [MGJRouter registerURLPattern:rt_user_signupin toObjectHandler:^id(NSDictionary *routerParameters) {
        MCNavigationController *navVC = [[MCNavigationController alloc] initWithRootViewController:[XLLoginViewController new]];
        return navVC;
    }];
    [MGJRouter registerURLPattern:rt_user_sign toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCSignViewController new];
    }];
    
    #pragma mark - 银行卡管理
    [MGJRouter registerURLPattern:rt_card_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCCardManagerController new];
    }];
    [MGJRouter registerURLPattern:rt_card_edit toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = [routerParameters objectForKey:MGJRouterParameterUserInfo];
        MCBankCardType type = [[info objectForKey:@"type"] intValue];
        MCBankCardModel *model = [info objectForKey:@"model"];
        BOOL login = [[info objectForKey:@"isLogin"] boolValue];
        MCEditBankCardController *vc = [[MCEditBankCardController alloc] initWithType:type cardModel:model];
        vc.loginVC = login;
        vc.whereCome = [info objectForKey:@"whereCome"];
        return vc;
    }];
    
    #pragma mark - 设置
    [MGJRouter registerURLPattern:rt_setting_list toObjectHandler:^id(NSDictionary *routerParameters) {
        MCSettingViewController *vc = [[MCSettingViewController alloc] initWithSettingItems:@[MCSettingItemVersionCheck,MCSettingItemClearCache,MCSettingItemCountSafe,MCSettingItemAboutUs]];
        return vc;
    }];
    [MGJRouter registerURLPattern:rt_setting_service toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCServiceController new];
    }];
    [MGJRouter registerURLPattern:rt_setting_accountsafe toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCCountSafeController new];
    }];
    
    #pragma mark - 升级
    [MGJRouter registerURLPattern:rt_update_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCUpdateViewController new];
    }];
    [MGJRouter registerURLPattern:rt_update_updatesave toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCUpdateSaveController_X new];
    }];
    
    #pragma mark - 收款
    [MGJRouter registerURLPattern:rt_collection_cashier toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCCashierController new];
    }];
    [MGJRouter registerURLPattern:rt_collection_npcashier toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCNPCashierController new];
    }];
    
    #pragma mark - 账单
    [MGJRouter registerURLPattern:rt_order_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCOrderListController new];
    }];
    
    #pragma mark - 收益
    [MGJRouter registerURLPattern:rt_profit_overview toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCProfitController new];
    }];
    [MGJRouter registerURLPattern:rt_profit_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCProfitListController new];
    }];
    
    #pragma mark - 余额
    [MGJRouter registerURLPattern:rt_balance_overview toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCBalanceController new];
    }];
    
    #pragma mark - 费率
    [MGJRouter registerURLPattern:rt_rate_myrate toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCMyRateController new];
    }];
    
    #pragma mark - 定制化功能
    [MGJRouter registerURLPattern:rt_custom_dailishang toObjectHandler:^id(NSDictionary *routerParameters) {
        return [DelegateShangViewController new];
    }];
    
    #pragma mark - webVc
    [MGJRouter registerURLPattern:rt_web_controller toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = [routerParameters objectForKey:MGJRouterParameterUserInfo];
        NSString *urlString = [info objectForKey:@"url"];
        NSString *title = [info objectForKey:@"title"];
        NSString *classification = [info objectForKey:@"classification"];
        MCWebViewController *web = [[MCWebViewController alloc] init];
        web.urlString = urlString;
        if (title) {
            web.title = title;
        }
        if (classification) {        
            web.classifty = classification;
        }
        return web;
    }];
    
    #pragma mark - 鉴权和收款确认
    [MGJRouter registerURLPattern:rt_card_add toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = routerParameters[MGJRouterParameterUserInfo];
        MCBankCardModel * cardModel = info[@"param"];
        return [[KDPayGatherViewController alloc] initWithClassification:cardModel];
    }];

    
    
    #pragma mark - 身份认证1
    [MGJRouter registerURLPattern:rt_card_vc1 toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCAccreditation1ViewController new];
    }];
    #pragma mark - 身份认证2
    [MGJRouter registerURLPattern:rt_card_vc2 toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCAccreditation2ViewController new];
    }];
    #pragma mark - 重置忘记密码
    [MGJRouter registerURLPattern:rt_user_restPwd toObjectHandler:^id(NSDictionary *routerParameters) {
        return [KDForgetPwdViewController new];
    }];
    
    #pragma mark - 联系客服
    [MGJRouter registerURLPattern:rt_user_homeService toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCHomeServiceViewController new];
    }];
    #pragma mark - 统统鉴权
    [MGJRouter registerURLPattern:rt_card_jianquan toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = routerParameters[MGJRouterParameterUserInfo];
        MCBankCardModel * cardModel = info[@"param"];
        MCCustomModel * extendModel = info[@"extend"];
        return [[KDPayJianQuanViewController alloc] initWithClassification:cardModel extend:extendModel];
    }];
    #pragma mark - 统统交易
    [MGJRouter registerURLPattern:rt_card_jiaoyi toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = routerParameters[MGJRouterParameterUserInfo];
        MCBankCardModel * cardModel = info[@"param"];
        MCCustomModel * extendModel = info[@"extend"];
        return [[KDTTFJiaoYiViewController alloc] initWithClassification:cardModel extend:extendModel];
    }];
    #pragma mark - 留言板
    [MGJRouter registerURLPattern:rt_card_liuyanban toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCLiuYanBanViewController new];
    }];
    
    
}

- (NSString *)pureHost {
    NSString *h = @"";
    //  截取baseUrl中 :// 到 / 中间的内容
    if ([SharedDefaults.host hasPrefix:@"https://"]) {
        if ([SharedDefaults.host hasSuffix:@"/"]) {
            h = [SharedDefaults.host substringWithRange:NSMakeRange(8, SharedDefaults.host.length - 9)];
        } else {
            h = [SharedDefaults.host substringWithRange:NSMakeRange(8, SharedDefaults.host.length - 8)];
        }
    }
    if ([SharedDefaults.host hasPrefix:@"http://"]) {
        if ([SharedDefaults.host hasSuffix:@"/"]) {
            h = [SharedDefaults.host substringWithRange:NSMakeRange(7, SharedDefaults.host.length - 8)];
        } else {
            h = [SharedDefaults.host substringWithRange:NSMakeRange(7, SharedDefaults.host.length - 7)];
        }
    }
    return h;
}


@end
