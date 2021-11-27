//
//  KDWithDrawHistoryViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDProfitDirectPushModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDWithDrawHistoryViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) KDProfitDirectPushModel *model;
@end

NS_ASSUME_NONNULL_END
