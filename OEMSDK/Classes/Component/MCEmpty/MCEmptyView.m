//
//  MCEmptyView.m
//  MCOEM
//
//  Created by yujia tian on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCEmptyView.h"

@implementation MCEmptyView

+ (instancetype)emptyView {
    MCEmptyView *empty = [MCEmptyView emptyViewWithImage:[UIImage mc_imageNamed:@"list_empty"] titleStr:@"暂无数据，下拉刷新试试" detailStr:@""];
    return empty;
}

+ (instancetype)emptyViewWithKDTitle:(NSString *)title
{
    NSString *msg = [NSString stringWithFormat:@"还没有获得%@", title];
    MCEmptyView *empty = [MCEmptyView emptyViewWithImage:[UIImage mc_imageNamed:@"kd_profit_direct_push_empty_img"] titleStr:msg detailStr:@""];
    return empty;
}
+ (instancetype)emptyViewWithKDDelegateTitle:(NSString *)title
{
    MCEmptyView *empty = [MCEmptyView emptyViewWithImage:[UIImage mc_imageNamed:@"kd_direct_no_data"] titleStr:nil detailStr:@""];
    return empty;
}
- (void)prepare {
    [super prepare];
//    self.titleLabFont = [UIFont systemFontOfSize:25];
//    self.titleLabTextColor = UIColorMake(90, 180, 160);
//    self.detailLabFont = [UIFont systemFontOfSize:17];
//    self.detailLabTextColor = UIColorMake(180, 120, 90);
//    self.detailLabMaxLines = 5;
//    self.actionBtnBackGroundColor = UIColorMake(90, 180, 160);
//    self.actionBtnTitleColor = [UIColor whiteColor];
}

@end
