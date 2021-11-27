//
//  KDSlotCardHistoryViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDSlotCardHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDSlotCardHistoryViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) KDSlotCardHistoryModel *slotHistoryModel;

@end

NS_ASSUME_NONNULL_END
