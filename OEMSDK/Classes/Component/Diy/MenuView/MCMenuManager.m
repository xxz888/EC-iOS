//
//  MCMenuManager.m
//  Project
//
//  Created by Ning on 2019/11/14.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCMenuManager.h"
#import "CreateQRCodeViewController.h"
#import "PayOrderViewController.h"
#import "WBQRCodeVC.h"
#import "CommonEncourageVC.h"
#import "KDCommonAlert.h"
@interface MCMenuManager ()<WBQRCodeVCDelegate>

@end

@implementation MCMenuManager
+ (instancetype)sharedConfig {
    static dispatch_once_t oneceToken;
    static MCMenuManager *_singleConfig = nil;
    dispatch_once(&oneceToken, ^{
        if (_singleConfig == nil) {
            _singleConfig = [[self alloc] init];
        }
    });
    return _singleConfig;
}
- (void) pushModuleWithData:(NSDictionary*)data{
    BOOL realName = [data[@"realname"] boolValue];
    if (realName) {
        [MCVerifyStore verifyRealName:^(MCUserInfo * _Nonnull userinfo) {
            [self verfyGrade:data];
        }];
    } else {
        [self verfyGrade:data];
    }
}

- (void)verfyGrade:(NSDictionary *)dict {
    NSInteger grade = [dict[@"grade"] integerValue];
    
    
    if (MCModelStore.shared.userInfo.grade.integerValue < grade) {
        [MCGradeName getGradeNameWithGrade:[NSString stringWithFormat:@"%ld", (long)grade] callBack:^(NSString * _Nonnull gradeName) {
            
            NSString * message = [NSString stringWithFormat:@"只有《%@》级别及以上才能查看此内容,是否前往充值升级？",gradeName];
            KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
            [commonAlert initKDCommonAlertContent:message  isShowClose:NO];
            commonAlert.rightActionBlock = ^{
                [MCPagingStore pagingURL:rt_update_list];
            };
            
            
//            [MCAlertStore showWithTittle:@"温馨提示" message:[NSString stringWithFormat:@"只有《%@》级别及以上才能查看此内容,是否前往充值升级？",gradeName] buttonTitles:@[@"暂不需要",@"前往升级"] sureBlock:^{
//                [MCPagingStore pagingURL:rt_update_list];
//            }];
        }];
    } else {
        [self paging:dict];
    }
}
- (void)paging:(NSDictionary *)dict {
    
    
    NSString* sortType = dict[@"sortType"];
    NSString* title = dict[@"title"];
    NSString* isAddParam = dict[@"param"];
    NSString* sortt = [NSString stringWithFormat:@"%@",dict[@"sortt"]];
    NSString* sorttValue = [NSString stringWithFormat:@"%@",dict[@"sortValue"]];
    if (![sortType isEqualToString:@"0"]) {
        //web
        if ([isAddParam isEqualToString:@"1"]) {
            [self pushWebWithUrl:[self appendOtherParams:sorttValue] title:title];
        }else{
            [self pushWebWithUrl:sorttValue title:title];
        }
    }else{
        if ([sortt isEqualToString:@"代理商入口"]) {
            [MCLATESTCONTROLLER.navigationController pushViewController:[DelegateShangViewController new] animated:YES];
            return;
        }
        if ([sortt isEqualToString:@"商户收款"]) {
            CreateQRCodeViewController *vc = [[CreateQRCodeViewController alloc] initWithNibName:@"CreateQRCodeViewController" bundle:[NSBundle OEMSDKBundle]];
            [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
            return;
        }
        if ([sortt isEqualToString:@"幸运转盘"]) {
            [MCLATESTCONTROLLER.navigationController pushViewController:[CommonEncourageVC new] animated:YES];
            return;
        }
        if ([sortt isEqualToString:@"扫一扫"]) {
            WBQRCodeVC *scanner = [WBQRCodeVC new];
            scanner.delegate = self;
            [MCLATESTCONTROLLER.navigationController pushViewController:scanner animated:YES];
            return;
        }
        if ([sortt containsString:@"NP收款"]) {
            [MCPagingStore pagingURL:rt_collection_npcashier];
            return;
        }
        if ([sortt containsString:@"NP消费"]) {
            [MCPagingStore pagingURL:rt_collection_npcashier];
            return;
        }
        if ([sortt containsString:@"商学院"]) {
            [MCPagingStore pagingURL:rt_news_list withUerinfo:@{@"classification":@"商学院"}];
            return;
         }
             
        //0原生
        if ([sortt containsString:@"收款"]) {
            [MCPagingStore pagingURL:rt_collection_cashier];
            return;
        }
        if ([sortt containsString:@"升级"]) {
            [MCPagingStore pagingURL:rt_update_list];
            return;
        }
        
        if ([sortt containsString:@"我要激活"]) {
            //TODO::
            return;
        }
        if ([sortt containsString:@"账户余额"]) {
            [MCPagingStore pagingURL:rt_balance_overview];
            return;
        }
        if ([sortt containsString:@"我的激活码"]) {
            //TODO::
            return;
        }
        if ([sortt containsString:@"卡片管理"]) {
            [MCPagingStore pagingURL:rt_card_list];
            return;
        }
        if ([sortt containsString:@"我的收益"]) {
            [MCPagingStore pagingURL:rt_profit_overview];
            return;
        }
        if ([sortt containsString:@"我的费率"]) {
            [MCPagingStore pagingURL:rt_rate_myrate];
            return;
        }
        if ([sortt containsString:@"我的团队"]) {
            [MCPagingStore pagingURL:rt_team_overview];
            return;
        }
        if ([sortt containsString:@"交易明细"]) {
            [MCPagingStore pagingURL:rt_order_list];
            return;
        }
        if ([sortt containsString:@"收益排行"]) {
            [MCPagingStore pagingURL:rt_team_ranking];
            return;
        }
        if ([sortt containsString:@"信用社区"]) {
            [MCPagingStore pagingURL:rt_news_community];
            return;
        }
        if ([sortt containsString:@"操作手册"]) {
            [MCPagingStore pagingURL:rt_news_operation];
            return;
        }
        if ([sortt containsString:@"信用秘籍"]) {
            [MCPagingStore pagingURL:rt_news_list withUerinfo:@{@"classification":@"信用秘籍"}];
            return;
        }
        if ([sortt containsString:@"视频教程"]) {
            [MCPagingStore pagingURL:rt_news_videos];
//            [MCPagingStore pagingURL:rt_news_list withUerinfo:@{@"classification":@"视频教程"}];
            return;
        }
        if ([sortt containsString:@"朋友圈"]) {
            [MCPagingStore pagingURL:rt_share_article];
            return;
        }
        if ([sortt containsString:@"密码管理"]) {
            [MCPagingStore pagingURL:rt_setting_accountsafe];
            return;
        }
        if ([sortt containsString:@"联系客服"]) {
            [MCPagingStore pagingURL:rt_setting_service];
            return;
        }
        if ([sortt containsString:@"实名认证"]) {
            [MCPagingStore pagingURL:rt_user_realname];
            return;
        }
        if ([sortt containsString:@"签到"]) {
            [MCPagingStore pagingURL:rt_user_sign];
            return;
        }
        if ([sortt containsString:@"设置"]) {
            [MCPagingStore pagingURL:rt_setting_list];
            return;
        }
        if ([sortt containsString:@"消息"]) {
            [MCPagingStore pagingURL:rt_notice_list];
            return;
        }

        [MCToast showMessage:@"暂未开通，请检查配置是否正确或升级app"];
    }
    
}
- (void)pushWebWithUrl:(NSString*)url title:(NSString*)title{
    NSString *urlNew = [MCVerifyStore verifyURL:url];
    if (!urlNew) {
        urlNew = @"http://mc.mingchetech.com/link/soon.html";
    }
    [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":urlNew, @"title":title}];
}
- (NSString*)appendOtherParams:(NSString*)url{
    NSString *phone = MCModelStore.shared.userInfo.phone;
    NSString *token = TOKEN;
    NSString *userID = MCModelStore.shared.userInfo.userid;
    NSString *ip = BCFI.pureHost;
    url = [NSString stringWithFormat:@"%@?phone=%@&token=%@&brandid=%@&userid=%@&ip=%@", url,phone,token,BCFI.brand_id,userID,ip];
    return url;
}
- (void)scancodeViewControllerComplete:(NSString *)str
{
    
    PayOrderViewController *payVC = [PayOrderViewController new];
    payVC.codeStr = str;
    [MCLATESTCONTROLLER.navigationController pushViewController:payVC animated:YES];
}
@end
