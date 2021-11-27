//
//  MCBlockStore.m
//  Pods
//
//  Created by wza on 2020/9/2.
//

#import "MCBlockStore.h"
#import "MCNewsModel.h"

static NSString *api_native_limit = @"/user/app/setup/brand/user";

@implementation MCBlockStore

- (didLoginBlock)blockNativeOrH5 {
    didLoginBlock b = ^(MCNetResponse *resp) {
        [MCSessionManager.shareManager mc_POST:api_native_limit parameters:@{@"userid":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
            //进h5页面
            [MCSessionManager.shareManager mc_POST:@"/user/app/news/getnewsby/brandidandclassification/andpage" parameters:@{@"brandId":SharedConfig.brand_id,@"size":@"999",@"classifiCation":@"功能跳转"} ok:^(MCNetResponse * _Nonnull resp) {
                NSArray *array = [MCNewsModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
                for (MCNewsModel *model in array) {
                    if ([model.title isEqualToString:@"商城"] || [model.title isEqualToString:@"自营商城"]) {
                        BCFI.native_limit = @"";
                        NSMutableString *ms = [NSMutableString stringWithFormat:@"%@",model.content];
                        [ms appendFormat:
                         @"?phone=%@&token=%@&brandid=%@&userid=%@&ip=%@",
                         SharedUserInfo.phone,TOKEN,SharedConfig.brand_id,SharedUserInfo.userid,BCFI.pureHost];
                        UIViewController *webVC = [MGJRouter objectForURL:rt_web_controller withUserInfo:@{@"title":model.title, @"url":ms}];
                        [UIApplication sharedApplication].keyWindow.rootViewController = webVC;
                        return;
                    }
                }
                //其他情况拋个错误
                UIViewController *root = [UIViewController new];
                [UIApplication sharedApplication].keyWindow.rootViewController = root;
                QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"温馨提示" message:@"暂时无法使用，请联系客服" preferredStyle:QMUIAlertControllerStyleAlert];
                [alert addAction:[QMUIAlertAction actionWithTitle:@"好的" style:QMUIAlertActionStyleCancel handler:nil]];
                [alert showWithAnimated:YES];
            } other:^(MCNetResponse * _Nonnull resp) {
                //其他情况拋个错误
                UIViewController *root = [UIViewController new];
                [UIApplication sharedApplication].keyWindow.rootViewController = root;
                QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"温馨提示" message:@"暂时无法使用，请联系客服" preferredStyle:QMUIAlertControllerStyleAlert];
                [alert addAction:[QMUIAlertAction actionWithTitle:@"好的" style:QMUIAlertActionStyleCancel handler:nil]];
                [alert showWithAnimated:YES];
            }];
        } other:^(MCNetResponse * _Nonnull resp) {
            //进原生页面
            SharedDefaults.not_auto_logonin = YES;
            BCFI.native_limit = @"native";
            [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
        }];
    };
    return b;
}

@end
