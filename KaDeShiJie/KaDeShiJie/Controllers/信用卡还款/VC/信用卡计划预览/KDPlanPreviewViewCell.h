//
//  KDPlanPreviewViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDTotalOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDPlanPreviewViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) KDTotalOrderModel *orderModel;
@property (nonatomic, assign) NSInteger whereCome;    // 1 下单 2 历史记录 3 信用卡还款进来

@property (nonatomic, strong) NSString * balancePlanId;//


@end

NS_ASSUME_NONNULL_END
