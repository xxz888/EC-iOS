//
//  MCQuestionModel.m
//  MCOEM
//
//  Created by SS001 on 2020/4/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCQuestionModel.h"
#import "MCNewsModel.h"

static NSString *api_getnews = @"/user/app/news/getnewsby/brandidandclassification/andpage";

@implementation MCQuestionModel

- (void)requestDataWithCallBack:(callBack)callBack
{
    NSDictionary *params = @{@"brandId":MCModelStore.shared.brandConfiguration.brand_id,
                             @"classifiCation":@"常见问题",
                             @"size":@"100",
                             @"page":@"0"};
    [[MCSessionManager shareManager] mc_POST:api_getnews parameters:params ok:^(MCNetResponse * _Nonnull okResponse) {
        NSArray *arr = okResponse.result[@"content"];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (arr.count != 0) {
            dataArray = [MCNewsModel mj_objectArrayWithKeyValuesArray:arr];
        } else {
            NSArray *titleArr = @[@"问题一",@"问题二",@"问题三",@"问题四",@"问题五",@"问题六",@"问题七",@"问题八"];
            for (int i = 0; i < titleArr.count; i++) {
                MCNewsModel *model = [[MCNewsModel alloc] init];
                model.title = titleArr[i];
                model.classifiCation = @"功能跳转";
                [dataArray addObject:model];
            }
        }
        callBack(dataArray);
    }];
}

@end
