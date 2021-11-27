//
//  MCOrderListCell.h
//  MCOEM
//
//  Created by wza on 2020/4/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCOrderListCell : UITableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableView orderModel:(MCOrderModel *)model;

@end

NS_ASSUME_NONNULL_END
