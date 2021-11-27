//
//  MCGradeName.m
//  Project
//
//  Created by SS001 on 2019/6/10.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCGradeName.h"

@interface MCGradeName ()
@property (nonatomic, strong) NSMutableArray *productArray;
@end

@implementation MCGradeName

+ (void)getGradeNameWithGrade:(NSString *)grade callBack:(void (^)(NSString *gradeName))callBack
{
    
    NSString *token = TOKEN;
    
    NSDictionary *shopDic = @{};
    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/usersys/query/%@",token] parameters:shopDic ok:^(MCNetResponse * _Nonnull resp) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in resp.result[@"thirdLevelDistribution"]) {
            [array addObject:dic];
        }
        NSString *gradeName = @"普通用户";
        for (NSDictionary *dict in array) {
            if ([dict[@"grade"] intValue] == [grade intValue]) {
                gradeName = dict[@"name"];
            }
        }
        callBack(gradeName);
    }];
}
@end
