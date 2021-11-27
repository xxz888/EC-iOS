//
//  KDPlanCenterKongKaCell.h
//  KaDeShiJie
//
//  Created by apple on 2020/11/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDDirectRefundModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDPlanCenterKongKaCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) KDDirectRefundModel *directModel;
@property (nonatomic, strong) NSString * version;
@end

NS_ASSUME_NONNULL_END
