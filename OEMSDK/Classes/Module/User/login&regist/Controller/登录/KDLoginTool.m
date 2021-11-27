//
//  KDLoginTool.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/26.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDLoginTool.h"
#import "MCMessageModel.h"
#import "KDCommonAlert.h"
static KDLoginTool *tool = nil;

@implementation KDLoginTool

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tool == nil) {
            tool = [[self alloc]init];
        }
    });
    return tool;
}

- (void)getChuXuCardData:(BOOL)isHandLogin
{
    //默认储蓄卡
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/user/app/bank/query/userid/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        NSMutableArray *arr = [NSMutableArray array];
        for (MCBankCardModel *model in temArr) {
            if ([model.nature containsString:@"借"]) {
                [arr addObject:model];
            }
        }
        if (arr.count != 0) {
            [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
            //登录成功弹出系统消息
            [self requestPlatform:isHandLogin];
        } else {
            [self nocardAlertShowWithMessage:@"你还未添加到账提现卡(储蓄卡)，是否前往添加？" type:MCBankCardTypeChuxuka cardModel:nil];
        }
    }];
}

- (void)requestPlatform:(BOOL)isHandLogin{
    if (!isHandLogin) {
        return;
    }
    
    
    
    NSDictionary *param = @{@"page":@(0),@"size":@"1"};
    __weak __typeof(self)weakSelf = self;
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/user/app/jpush/history/brand/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *tempA = [MCMessageModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        MCMessageModel * model = tempA[0];
        NSInteger currentInterva = [weakSelf getNowTimeStamp];
        NSInteger endInterva = [weakSelf cTimestampFromString:model.endTime];
        NSInteger chazhi = endInterva - currentInterva;
        if (endInterva - currentInterva > 0) {
            //记录id
            NSString * contentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"contentId"];
            
            //showalert之前进行 一天一次判断
            NSDate *now = [NSDate date];
            
            NSDate *agoDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowDate"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *ageDateString = [dateFormatter stringFromDate:agoDate];
            NSString *nowDateString = [dateFormatter stringFromDate:now];
            if ([ageDateString isEqualToString:nowDateString] && [contentId integerValue] == [model.id integerValue]) {
                NSLog(@"一天就显示一次");
            }else{
                //记录弹窗时间
                NSDate *nowDate = [NSDate date];
                NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
                [dataUser setObject:nowDate forKey:@"nowDate"];
                [dataUser synchronize];
                
                NSUserDefaults * contentIdUser = [NSUserDefaults standardUserDefaults];
                [contentIdUser setObject:model.id forKey:@"contentId"];
                [contentIdUser synchronize];
                
                
                KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
                [commonAlert initKDCommonAlertContent:model.content  isShowClose:YES];
            }
        }
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
        [MCToast showMessage:error.localizedFailureReason];
    }];
}
-(NSInteger)getNowTimeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这一点对时间的处理很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *dateNow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];

    return [timeSp integerValue];
}

// 字符串时间—>时间戳
-(NSInteger)cTimestampFromString:(NSString *)theTime {
    // theTime __@"%04d-%02d-%02d %02d:%02d:00"
    // 转换为时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* dateTodo = [formatter dateFromString:theTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]];
    return [timeSp integerValue];
}
- (void)nocardAlertShowWithMessage:(NSString *)msg type:(MCBankCardType)cardType cardModel:(MCBankCardModel *)cardModel {
    [self pushCardVCWithType:cardType];
}
- (void)pushCardVCWithType:(MCBankCardType)cardType
{
    [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(1), @"isLogin":@(YES)}];
}

@end
