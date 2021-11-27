//
//  MCPagingStore.m
//  MCOEM
//
//  Created by wza on 2020/4/3.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCPagingStore.h"
#import "MCProductModel.h"
#import "KDCommonAlert.h"
@implementation MCPagingStore
+ (void)pagingURL:(NSString *)url {
    [self pagingURL:url withUerinfo:nil];
}
+ (void)pagingURL:(NSString *)url withUerinfo:(NSDictionary *)info {
    id obj = [MGJRouter objectForURL:url withUserInfo:info];
    
    
    
    if ([obj isKindOfClass:[UIViewController class]]) {
        
        
        //如果升级在tabbar，则返回
        if ([url isEqualToString:rt_update_list] ||
            [url isEqualToString:rt_update_updatesave]) {
            UIViewController *current = MCLATESTCONTROLLER;
            
            UITabBarController *tab = current.navigationController.tabBarController;
            if (tab) {
                for (int i = 0; i < tab.viewControllers.count; i++) {
                    UINavigationController *nav = tab.viewControllers[i];
                    if ([nav.topViewController isKindOfClass:[[MGJRouter objectForURL:rt_update_updatesave] class]] ||
                        [nav.topViewController isKindOfClass:[[MGJRouter objectForURL:rt_update_list] class]]) {
                        [current.navigationController popToRootViewControllerAnimated:NO];
                        tab.selectedIndex = i;
                        return;
                    }
                }
            }
        }
        
//        MCLog(@"MCLATESTCONTROLLER---------%@", MCLATESTCONTROLLER);
        UIViewController *current = MCLATESTCONTROLLER;
        [current.navigationController pushViewController:obj animated:YES];
    } else {
        [MCToast showMessage:@"暂未开通"];
    };
}

+ (void)presentLoginViewController:(void (^)(void))completion {
    id obj = [MGJRouter objectForURL:rt_user_signupin];
    if ([obj isKindOfClass:[UIViewController class]]) {
        
        [MCLATESTCONTROLLER presentViewController:obj animated:YES completion:^{
            if (completion) {
                completion();
            }
        }];
    }
}

+ (void)pushWebWithTitle:(NSString *)title classification:(NSString *)classification {
    NSDictionary *param = nil;
    if (classification) {
        param = @{@"brandId":SharedConfig.brand_id,@"size":@"999",@"classifiCation":classification};
    }
    [MCSessionManager.shareManager mc_POST:@"/user/app/news/getnewsby/brandidandclassification/andpage" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        NSMutableString *urlString = nil;
        NSInteger rGrade = 0;
        BOOL isParams = NO;
        BOOL isBrand = SharedUserInfo.brandStatus.boolValue;
        for (NSDictionary *dic in resp.result[@"content"]) {
            NSString *rTitle = [dic objectForKey:@"title"];
            if ([title containsString:rTitle]) {
                urlString = [NSMutableString stringWithString:[dic objectForKey:@"content"]];
                rGrade = [[dic objectForKey:@"onOff"] integerValue];
                isParams = ([[dic objectForKey:@"publisher"] isEqualToString:@"add"]);
                break;
            }
        }
        if (!urlString) {
            [MCToast showMessage:@"敬请期待"];
            return;
        }
        if (!isBrand && SharedUserInfo.grade.integerValue < rGrade) {
            //升级弹窗
            [MCSessionManager.shareManager mc_GET:[NSString stringWithFormat:@"/user/app/thirdlevel/prod/brand/%@",SharedConfig.brand_id] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
                NSArray *models = [MCProductModel mj_objectArrayWithKeyValuesArray:resp.result];
                NSString *gradeName = nil;
                for (MCProductModel *model in models) {
                    if (model.grade.integerValue == rGrade) {
                        gradeName = model.name;
                        break;
                    }
                }
                if (gradeName) {
                    
                    kWeakSelf(self);
                    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
                    [commonAlert initKDCommonAlertContent:[NSString stringWithFormat:@"只有《%@》级别及以上才能查看此内容,是否前往充值升级？",gradeName]  isShowClose:NO];
                    commonAlert.rightActionBlock = ^{
                        [MCPagingStore pagingURL:rt_update_list];                    };
                    
                    
//                    [MCAlertStore showWithTittle:@"温馨提示" message:[NSString stringWithFormat:@"只有《%@》级别及以上才能查看此内容,是否前往充值升级？",gradeName] buttonTitles:@[@"暂不需要",@"前往升级"] sureBlock:^{
//                        [MCPagingStore pagingURL:rt_update_list];
//                    }];
                }
            }];
            return;
        }
        if (isParams) {
            
            [urlString appendFormat:@"?phone=%@&token=%@&brandid=%@&userid=%@&ip=%@&deviceId=%@",SharedUserInfo.phone,TOKEN,SharedConfig.brand_id,SharedUserInfo.userid,BCFI.pureHost, SharedDefaults.deviceid];
        }
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        [info setObject:urlString forKey:@"url"];
        if (title) {
            [info setObject:title forKey:@"title"];
        }
        [info setObject:classification forKey:@"classification"];
        [MCPagingStore pagingURL:rt_web_controller withUerinfo:info];
    }];
}

@end
